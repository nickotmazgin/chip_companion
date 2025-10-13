#!/usr/bin/env python3
"""
Render marketing assets (app icon and feature graphic) from SVG to PNG.

Requirements:
  pip install cairosvg

Usage:
  python tools/render_assets.py

It will create PNGs next to the SVG sources.
"""
from pathlib import Path
import sys
import re

try:
    import cairosvg
except Exception:
    sys.stderr.write(
        "CairoSVG is required. Install with: pip install cairosvg\n"
    )
    raise

try:
    from PIL import Image, ImageCms  # type: ignore
except Exception:
    Image = None  # Pillow optional; we'll warn if missing

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "final_release_google_play_store"

 
def render(svg_path: Path, out_path: Path, width: int, height: int):
    out_path.parent.mkdir(parents=True, exist_ok=True)
    cairosvg.svg2png(
        url=str(svg_path),
        write_to=str(out_path),
        output_width=width,
        output_height=height,
    )
    # Post-process: ensure PNG has no alpha (Play Console app icon requirement)
    if Image is not None:
        try:
            with Image.open(out_path) as im:
                # Always output RGB with embedded sRGB profile
                needs_flatten = (
                    im.mode in ("RGBA", "LA") or ("transparency" in im.info)
                )
                if needs_flatten:
                    bg = Image.new("RGB", im.size, "#0b1220")
                    if im.mode in ("RGBA", "LA"):
                        alpha = im.split()[-1]
                        bg.paste(im.convert("RGB"), mask=alpha)
                    else:
                        bg.paste(im.convert("RGB"))
                    im = bg
                else:
                    im = im.convert("RGB")

                # Embed sRGB ICC profile if available
                try:
                    srgb = ImageCms.createProfile("sRGB")
                    icc_bytes = ImageCms.ImageCmsProfile(srgb).tobytes()
                except Exception:
                    icc_bytes = None

                save_kwargs = {"format": "PNG", "optimize": True}
                if icc_bytes:
                    save_kwargs["icc_profile"] = icc_bytes
                im.save(out_path, **save_kwargs)
        except Exception as e:  # pragma: no cover - best-effort flatten
            print(f"Warning: could not flatten alpha for {out_path.name}: {e}")
    else:
        print(
            "Note: Pillow not installed; PNG may retain alpha. "
            "Install with: pip install pillow"
        )
    print(f"Rendered {out_path.name} ({width}x{height})")

 
SIZE_RE = re.compile(r"_(\d+)x(\d+)\.svg$", re.IGNORECASE)

 
def collect_svgs(base: Path):
    for svg in base.rglob("*.svg"):
        m = SIZE_RE.search(svg.name)
        if not m:
            continue
        w, h = int(m.group(1)), int(m.group(2))
        yield svg, w, h

 
def main():
    found = False
    for svg, w, h in collect_svgs(ASSETS):
        found = True
        png = svg.with_suffix(".png")
        render(svg, png, w, h)
    if not found:
        print(
            f"No sized SVGs found under {ASSETS}. "
            "Name files like name_1024x500.svg"
        )


if __name__ == "__main__":
    main()
