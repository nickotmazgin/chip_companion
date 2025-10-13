#!/usr/bin/env python3
"""
Working screenshot generator for Chip Companion.
Fixes cropping, navigation, validation, and content variety using Playwright.

Usage:
        python3 tools/working_screenshot_generator.py \
                --device-type phone \
                --orientation portrait \
                [--dpr 3]

Notes:
- When --dpr > 1, we set Playwright's device scale factor and use a CSS
    viewport of width/height divided by DPR so the final PNG dimensions
    match the target device pixels exactly.

Requirements:
    pip install playwright pillow
    python -m playwright install chromium
"""
# ruff: noqa: BLE001
# pylint: disable=broad-exception-caught
import argparse
import asyncio
import threading
from functools import partial
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from urllib.request import urlopen
from datetime import datetime
from pathlib import Path
from typing import Dict, Any

from PIL import Image
from playwright.async_api import async_playwright

ROOT_DIR = Path(__file__).parent.parent
SCREENSHOTS_DIR = ROOT_DIR / "assets" / "screenshots"
WEB_PORT = 8080

DEVICE_CONFIGS: Dict[str, Dict[str, Dict[str, Any]]] = {
    "phone": {
        "portrait": {"width": 1080, "height": 1920, "ratio": "9x16"},
        "landscape": {"width": 1920, "height": 1080, "ratio": "16x9"},
        "count": 5,
    },
    "tablet7": {
        "portrait": {"width": 1200, "height": 1920, "ratio": "5x8"},
        "landscape": {"width": 1920, "height": 1200, "ratio": "8x5"},
        "count": 5,
    },
    "tablet10": {
        "portrait": {"width": 1600, "height": 2560, "ratio": "5x8"},
        "landscape": {"width": 2560, "height": 1600, "ratio": "8x5"},
        "count": 5,
    },
}


def build_url(path: str) -> str:
    return f"http://localhost:{WEB_PORT}{path}"


def _is_server_up(url: str, timeout: float = 1.0) -> bool:
    try:
        with urlopen(url, timeout=timeout) as resp:  # noqa: S310
            return resp.status == 200 or resp.status == 304
    except Exception:
        return False


def _start_static_server(
    root: Path, port: int
) -> tuple[ThreadingHTTPServer, threading.Thread]:
    # Prefer binding to 127.0.0.1 explicitly
    handler = partial(SimpleHTTPRequestHandler, directory=str(root))
    httpd = ThreadingHTTPServer(("127.0.0.1", port), handler)
    thread = threading.Thread(target=httpd.serve_forever, daemon=True)
    thread.start()
    return httpd, thread


SCENARIOS = [
    {
        "id": "home",
        "name": "Home",
        "url": build_url("/"),
        "actions": [("ensure_home", None)],
        "crop": 1.0,
    },
    {
        "id": "devices",
        "name": "Devices",
        "url": build_url("/"),
        "actions": [("tab", 1)],
        "wait": 3,
        "crop": 1.0,
    },
    {
        "id": "settings",
        "name": "Settings",
        "url": build_url("/"),
        "actions": [("navigate", "/settings")],
        "wait": 3,
        "crop": 1.0,
    },
    {
        "id": "help",
        "name": "Help",
        "url": build_url("/"),
        "actions": [("navigate", "/help")],
        "wait": 3,
        "crop": 1.0,
    },
    {
        "id": "glossary",
        "name": "Glossary",
        "url": build_url("/"),
        "actions": [("navigate", "/glossary")],
        "wait": 3,
        "crop": 1.0,
    },
]


def filename(
    device: str,
    orient: str,
    dims: Dict[str, int],
    scenario_id: str,
) -> str:
    return (
        f"{device}_{orient}_{dims['width']}x{dims['height']}"
        f"_{dims['ratio']}_{scenario_id}.png"
    )


async def run_scenarios(
    page,
    device: str,
    orient: str,
    dims: Dict[str, Any],
    viewport_dims: Dict[str, int],
    dpr: float,
    count: int,
) -> int:
    out_dir = SCREENSHOTS_DIR / device / orient
    out_dir.mkdir(parents=True, exist_ok=True)

    # Ensure viewport matches CSS viewport (may be reduced when DPR > 1)
    await page.set_viewport_size(
        {"width": viewport_dims["width"], "height": viewport_dims["height"]}
    )

    success = 0
    for idx, sc in enumerate(SCENARIOS[:count], 1):
        print(f"\n📸 {idx}/{count} {sc['name']} → {sc['url']}")
        try:
            await page.goto(sc["url"], wait_until="networkidle", timeout=30000)
            await page.wait_for_timeout(15000)

            # Apply a gentle zoom for phone portrait to reduce
            # bottom whitespace only when DPR == 1 (when DPR > 1,
            # content density is already appropriate)
            try:
                if (
                    device == "phone"
                    and orient == "portrait"
                    and float(dpr) == 1.0
                ):
                    await page.evaluate(
                        "document.body.style.zoom='1.12'"
                    )
                    await page.wait_for_timeout(300)
            except Exception:
                pass

            for action, value in sc.get("actions", []):
                if action == "ensure_home":
                    try:
                        # If not on home, try navigateTo('/home') then wait
                        has_nav = await page.evaluate(
                            "typeof window.navigateTo === 'function'"
                        )
                        if has_nav:
                            await page.evaluate("window.navigateTo('/home')")
                            await page.wait_for_timeout(1000)
                    except Exception:
                        pass
                    try:
                        # Click Home label as a fallback (Flutter semantics)
                        await page.click("text=Home", timeout=1000)
                    except Exception:
                        pass
                    continue
                if action == "tab":
                    # Prefer navigateToTab, else fallback to
                    # navigateTo('/devices')
                    try:
                        has_tab = await page.evaluate(
                            "typeof window.navigateToTab === 'function'"
                        )
                        if has_tab:
                            await page.evaluate(
                                f"window.navigateToTab({int(value)})"
                            )
                        else:
                            has_nav = await page.evaluate(
                                "typeof window.navigateTo === 'function'"
                            )
                            if has_nav and int(value) == 1:
                                await page.evaluate(
                                    "window.navigateTo('/devices')"
                                )
                            else:
                                # Last resort: try clicking a bottom nav
                                # semantics label
                                try:
                                    await page.click("text=Devices")
                                except Exception:
                                    pass
                    except Exception:
                        pass

                elif action == "set_chip":
                    try:
                        has_set = await page.evaluate(
                            "typeof window.setChipId === 'function'"
                        )
                        if has_set:
                            await page.evaluate(f"window.setChipId('{value}')")
                        else:
                            # Fallback: fill first input field
                            await page.fill("input", value)
                    except Exception:
                        # Last resort: try type into focused element
                        try:
                            await page.type("input", value)
                        except Exception:
                            pass

                elif action == "validate":
                    try:
                        has_validate = await page.evaluate(
                            "typeof window.validateChip === 'function'"
                        )
                        if has_validate:
                            # Call validate via JS helper (twice defensively)
                            await page.evaluate("window.validateChip()")
                            await page.wait_for_timeout(300)
                            await page.evaluate("window.validateChip()")
                        else:
                            # Try ARIA role-based clicks with localized names
                            role_attempts = [
                                {
                                    "name": r"^Validate microchip format$",
                                    "locale": "en",
                                },
                                {"name": r"^Validate", "locale": "en"},
                                {
                                    "name": (
                                        r"^Valider le format de "
                                        r"micropuce$"
                                    ),
                                    "locale": "fr",
                                },
                                {"name": r"^Valider", "locale": "fr"},
                                {
                                    "name": r"^Validar formato de microchip$",
                                    "locale": "es",
                                },
                                {"name": r"^Validar", "locale": "es"},
                                {
                                    "name": r"^Проверить формат микрочипа$",
                                    "locale": "ru",
                                },
                                {"name": r"^Проверить", "locale": "ru"},
                            ]
                            clicked = False
                            for ra in role_attempts:
                                try:
                                    await page.get_by_role(
                                        "button", name=ra["name"]
                                    ).click(timeout=800)
                                    clicked = True
                                    break
                                except Exception:
                                    continue
                            if not clicked:
                                # Try common selectors in Flutter web semantics
                                selectors = [
                                    "button:has-text('Validate')",
                                    "[role='button']:has-text('Validate')",
                                    "text=Validate",
                                    "text=/^Validate microchip/i",
                                    "text=/Validate microchip format/i",
                                    "button",
                                ]
                                for sel in selectors:
                                    try:
                                        await page.click(sel, timeout=1000)
                                        clicked = True
                                        break
                                    except Exception:
                                        continue
                            if not clicked:
                                # Try pressing Enter in case a form
                                # submission is wired
                                try:
                                    await page.keyboard.press("Enter")
                                except Exception:
                                    pass
                        # Try to detect validating state briefly
                        try:
                            await page.wait_for_selector(
                                "text=/Validating/i",
                                timeout=1200,
                            )
                        except Exception:
                            pass
                        # Wait for a visible result; look for
                        # 'For Reference Only' or a common result hint
                        # Try several likely markers and scroll them into view
                        markers = [
                            "text=Registry Information",
                            "text=Contact Registry",
                            "text=For Reference Only",
                            "text=Validation",
                            "text=Reference",
                        ]
                        found_any = False
                        for sel in markers:
                            try:
                                await page.wait_for_selector(sel, timeout=3000)
                                # Center the result marker in the viewport
                                loc = page.locator(sel)
                                handle = await loc.element_handle()
                                if handle is not None:
                                    await page.evaluate(
                                        (
                                            "el => el.scrollIntoView({"
                                            "behavior:'instant',"
                                            " block:'center'})"
                                        ),
                                        handle,
                                    )
                                # Move mouse into content area so wheel scroll
                                # applies to Flutter ScrollView
                                try:
                                    await page.mouse.move(
                                        viewport_dims["width"] // 2,
                                        int(viewport_dims["height"] * 0.7),
                                    )
                                except Exception:
                                    pass
                                await page.wait_for_timeout(400)
                                # Small wheel to reveal content below the
                                # marker
                                try:
                                    await page.mouse.wheel(0, 400)
                                except Exception:
                                    pass
                                await page.wait_for_timeout(300)
                                found_any = True
                                break
                            except Exception:
                                continue
                        if not found_any:
                            # Generic scroll sequence, then jump to bottom
                            try:
                                await page.mouse.move(
                                    viewport_dims["width"] // 2,
                                    int(viewport_dims["height"] * 0.7),
                                )
                                await page.mouse.wheel(0, 1200)
                                await page.wait_for_timeout(500)
                                await page.mouse.wheel(0, 1000)
                                await page.wait_for_timeout(500)
                                await page.evaluate(
                                    "window.scrollTo(0, "
                                    "document.body.scrollHeight)"
                                )
                                await page.wait_for_timeout(600)
                            except Exception:
                                pass
                    except Exception:
                        pass

                elif action == "focus":
                    try:
                        has_focus = await page.evaluate(
                            "typeof window.focusChipInput === 'function'"
                        )
                        if has_focus:
                            await page.evaluate("window.focusChipInput()")
                        else:
                            await page.click("input", timeout=1000)
                    except Exception:
                        pass

                elif action == "navigate":
                    # Use JS bridge first; fallback to direct path
                    try:
                        has_nav = await page.evaluate(
                            "typeof window.navigateTo === 'function'"
                        )
                        if has_nav:
                            await page.evaluate(
                                f"window.navigateTo('{value}')"
                            )
                            await page.wait_for_timeout(800)
                        else:
                            await page.goto(build_url(value),
                                            wait_until="networkidle",
                                            timeout=30000)
                    except Exception:
                        try:
                            await page.goto(build_url(value),
                                            wait_until="networkidle",
                                            timeout=30000)
                        except Exception:
                            pass

                await page.wait_for_timeout(1500)

            if sc.get("wait"):
                await page.wait_for_timeout(int(sc["wait"]) * 1000)

            # Optional scroll to reveal validation results or lower content
            if sc.get("scroll_after"):
                try:
                    await page.evaluate(
                        f"window.scrollBy(0, {int(sc['scroll_after'])})"
                    )
                    await page.wait_for_timeout(800)
                except Exception:
                    pass
            # Capture and enforce exact dimensions (device pixels)
            path = out_dir / filename(device, orient, dims, sc["id"])
            await page.screenshot(path=str(path))

            with Image.open(path) as img:
                # No post-crop: we preserve full viewport to keep
                # background and nav
                img2 = img.convert("RGB")
                if img2.size != (dims["width"], dims["height"]):
                    img2 = img2.resize(
                        (dims["width"], dims["height"]),
                        Image.Resampling.LANCZOS,
                    )
                img2.save(path, "PNG")

            with Image.open(path) as final_img:
                fw, fh = final_img.size
                if (fw, fh) == (dims["width"], dims["height"]):
                    print(f"  ✅ saved {path.name} ({fw}x{fh})")
                    success += 1
                else:
                    print(f"  ❌ wrong size {fw}x{fh}")
        except Exception as e:
            print(f"  ❌ Error: {e}")
    return success


async def capture(device: str, orient: str, count: int, dpr: float) -> int:
    dims = DEVICE_CONFIGS[device][orient]
    # Compute CSS viewport size from target device pixels and DPR
    css_w = int(round(dims["width"] / float(dpr)))
    css_h = int(round(dims["height"] / float(dpr)))
    viewport_dims = {"width": css_w, "height": css_h}
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            device_scale_factor=float(dpr),
            viewport={"width": css_w, "height": css_h},
        )
        page = await context.new_page()
        ok = await run_scenarios(
            page, device, orient, dims, viewport_dims, dpr, count
        )
        await browser.close()
        return ok


def main():
    parser = argparse.ArgumentParser(
        description="Working screenshot generator",
    )
    parser.add_argument(
        "--device-type",
        choices=["phone", "tablet7", "tablet10"],
        default="phone",
    )
    parser.add_argument(
        "--orientation",
        choices=["portrait", "landscape"],
        default="portrait",
    )
    parser.add_argument(
        "--dpr",
        type=float,
        default=1.0,
        help=(
            "Device pixel ratio to emulate. When >1, uses a smaller CSS "
            "viewport so the final PNG matches the target pixel dimensions."
        ),
    )
    parser.add_argument(
        "--count",
        type=int,
        help=(
            "Number of screenshots to take for the "
            "device/orientation"
        ),
    )
    args = parser.parse_args()

    print("🎯 Chip Companion - Working Screenshot Generator")
    print(f"🕒 {datetime.now().isoformat(timespec='seconds')}")

    SCREENSHOTS_DIR.mkdir(parents=True, exist_ok=True)
    for dev in DEVICE_CONFIGS:
        for ori in ("portrait", "landscape"):
            (SCREENSHOTS_DIR / dev / ori).mkdir(parents=True, exist_ok=True)

    count = args.count or DEVICE_CONFIGS[args.device_type]["count"]

    # Ensure a local server is available on WEB_PORT.
    server = None
    if not _is_server_up(build_url("/")):
        # Try to serve build/web; if missing, suggest building first
        web_root = ROOT_DIR / "build" / "web"
        if not web_root.exists():
            print(
                "⚠️ build/web not found. Please run 'flutter build web' "
                "before generating screenshots."
            )
            return
        print(f"🔌 Starting local static server from {web_root}...")
        server, _ = _start_static_server(web_root, WEB_PORT)
        # Small delay to ensure the server is ready
        import time
        time.sleep(0.5)

    ok = 0
    try:
        ok = asyncio.run(
            capture(args.device_type, args.orientation, count, args.dpr)
        )
    finally:
        if server is not None:
            print("🛑 Stopping local static server…")
            server.shutdown()
            server.server_close()
    print(
        f"📊 Generated {ok}/{count} screenshots for "
        f"{args.device_type} {args.orientation} @ DPR {args.dpr}"
    )


if __name__ == "__main__":
    main()
