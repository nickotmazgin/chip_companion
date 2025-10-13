#!/usr/bin/env python3
"""
Generate Google Play Store screenshots for Chip Companion app using web automation.

This script launches the Flutter web app and captures screenshots of key screens
at the required dimensions for Google Play Store submission.

Requirements:
- Phone screenshots: 8/8 (16:9 or 9:16, 320px-3840px sides, min 1080px for promotion)
- 7-inch tablet screenshots: 5/8 (16:9 or 9:16, 320px-3840px sides)  
- 10-inch tablet screenshots: 5/8 (16:9 or 9:16, 1080px-7680px sides)

Usage:
    python tools/generate_screenshots.py [--device-type phone|tablet7|tablet10] [--orientation portrait|landscape] [--all]
"""

import argparse
import asyncio
import json
import os
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path

# Configuration
ROOT_DIR = Path(__file__).parent.parent
SCREENSHOTS_DIR = ROOT_DIR / "assets" / "screenshots"
WEB_PORT = 8080

# Device configurations for Google Play Store
DEVICE_CONFIGS = {
    "phone": {
        "portrait": {"width": 1080, "height": 1920},  # 9:16 ratio, 1080px min
        "landscape": {"width": 1920, "height": 1080},  # 16:9 ratio, 1080px min
        "count": 8,
        "min_size": 1080,
    },
    "tablet7": {
        "portrait": {"width": 1200, "height": 1920},  # 5:8 ratio (7-inch tablet)
        "landscape": {"width": 1920, "height": 1200},  # 8:5 ratio
        "count": 5,
        "min_size": 1200,
    },
    "tablet10": {
        "portrait": {"width": 1600, "height": 2560},  # 5:8 ratio (10-inch tablet)
        "landscape": {"width": 2560, "height": 1600},  # 8:5 ratio
        "count": 5,
        "min_size": 1600,
    }
}

# Screenshot scenarios with navigation steps
SCREENSHOT_SCENARIOS = [
    {
        "name": "home_screen",
        "description": "Home screen with chip ID input field",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 2},
            {"type": "click", "selector": "input[type='text']"},
            {"type": "wait", "duration": 1}
        ]
    },
    {
        "name": "home_with_chip_id", 
        "description": "Home screen with sample chip ID entered",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 2},
            {"type": "type", "selector": "input[type='text']", "text": "982000123456789"},
            {"type": "wait", "duration": 1}
        ]
    },
    {
        "name": "validation_result",
        "description": "Chip validation result display",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 2},
            {"type": "type", "selector": "input[type='text']", "text": "982000123456789"},
            {"type": "click", "selector": "button:contains('Validate')"},
            {"type": "wait", "duration": 3}
        ]
    },
    {
        "name": "devices_screen",
        "description": "Devices screen with scanner options",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 2},
            {"type": "click", "selector": "button:contains('Devices')"},
            {"type": "wait", "duration": 2}
        ]
    },
    {
        "name": "bluetooth_scanner",
        "description": "Bluetooth scanner interface",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 2},
            {"type": "click", "selector": "button:contains('Devices')"},
            {"type": "wait", "duration": 1},
            {"type": "click", "selector": "button:contains('Bluetooth')"},
            {"type": "wait", "duration": 2}
        ]
    },
    {
        "name": "nfc_scanner",
        "description": "NFC scanner interface",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 2},
            {"type": "click", "selector": "button:contains('Devices')"},
            {"type": "wait", "duration": 1},
            {"type": "click", "selector": "button:contains('NFC')"},
            {"type": "wait", "duration": 2}
        ]
    },
    {
        "name": "help_screen",
        "description": "Help and FAQ screen",
        "url_path": "/help",
        "actions": [
            {"type": "wait", "duration": 3}
        ]
    },
    {
        "name": "settings_screen",
        "description": "Settings and preferences screen",
        "url_path": "/settings",
        "actions": [
            {"type": "wait", "duration": 3}
        ]
    }
]

def check_dependencies():
    """Check if required dependencies are installed."""
    try:
        import playwright
        print("✅ Playwright is installed")
    except ImportError:
        print("❌ Playwright not installed. Installing...")
        subprocess.run([sys.executable, "-m", "pip", "install", "playwright"], check=True)
        subprocess.run(["playwright", "install", "chromium"], check=True)
        print("✅ Playwright installed successfully")

def start_flutter_web():
    """Start Flutter web server."""
    print("Starting Flutter web server...")
    try:
        # Kill any existing Flutter processes
        subprocess.run(["pkill", "-f", "flutter"], capture_output=True)
        time.sleep(2)
        
        # Start Flutter web server
        process = subprocess.Popen(
            ["flutter", "run", "-d", "web-server", "--web-port", str(WEB_PORT)],
            cwd=ROOT_DIR,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        
        # Wait for server to start
        time.sleep(10)
        
        # Check if server is running
        try:
            import requests
            response = requests.get(f"http://localhost:{WEB_PORT}", timeout=5)
            if response.status_code == 200:
                print(f"✅ Flutter web server started on port {WEB_PORT}")
                return process
        except:
            pass
            
        print("❌ Failed to start Flutter web server")
        return None
        
    except Exception as e:
        print(f"❌ Error starting Flutter web server: {e}")
        return None

async def capture_screenshots(device_type: str, orientation: str, count: int):
    """Capture screenshots using Playwright."""
    from playwright.async_api import async_playwright
    
    config = DEVICE_CONFIGS[device_type]
    dimensions = config[orientation]
    
    # Create screenshots directory
    output_dir = SCREENSHOTS_DIR / device_type / orientation
    output_dir.mkdir(parents=True, exist_ok=True)
    
    async with async_playwright() as p:
        # Launch browser
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            viewport={"width": dimensions["width"], "height": dimensions["height"]},
            device_scale_factor=1
        )
        page = await context.new_page()
        
        print(f"Capturing {count} screenshots for {device_type} {orientation}...")
        
        for i, scenario in enumerate(SCREENSHOT_SCENARIOS[:count]):
            print(f"  Screenshot {i+1}/{count}: {scenario['name']}")
            
            try:
                # Navigate to the page
                url = f"http://localhost:{WEB_PORT}{scenario['url_path']}"
                await page.goto(url, wait_until="networkidle")
                
                # Execute actions
                for action in scenario["actions"]:
                    if action["type"] == "wait":
                        await page.wait_for_timeout(action["duration"] * 1000)
                    elif action["type"] == "click":
                        await page.click(action["selector"])
                    elif action["type"] == "type":
                        await page.fill(action["selector"], action["text"])
                
                # Take screenshot
                screenshot_path = output_dir / f"{device_type}_{orientation}_{i+1:02d}_{scenario['name']}.png"
                await page.screenshot(path=str(screenshot_path), full_page=True)
                print(f"    ✅ Saved: {screenshot_path.name}")
                
            except Exception as e:
                print(f"    ❌ Error capturing {scenario['name']}: {e}")
        
        await browser.close()

def validate_screenshots(device_type: str, orientation: str):
    """Validate screenshot dimensions and formats."""
    try:
        from PIL import Image
    except ImportError:
        print("❌ PIL not installed. Installing...")
        subprocess.run([sys.executable, "-m", "pip", "install", "Pillow"], check=True)
        from PIL import Image
    
    config = DEVICE_CONFIGS[device_type]
    dimensions = config[orientation]
    min_size = config["min_size"]
    
    screenshots_dir = SCREENSHOTS_DIR / device_type / orientation
    
    if not screenshots_dir.exists():
        print(f"❌ Screenshots directory not found: {screenshots_dir}")
        return False
    
    valid_count = 0
    screenshot_files = list(screenshots_dir.glob("*.png"))
    
    print(f"\nValidating {len(screenshot_files)} screenshots...")
    
    for screenshot_file in screenshot_files:
        try:
            with Image.open(screenshot_file) as img:
                width, height = img.size
                
                # Check dimensions
                if width == dimensions["width"] and height == dimensions["height"]:
                    print(f"✅ {screenshot_file.name}: {width}x{height}")
                    valid_count += 1
                else:
                    print(f"❌ {screenshot_file.name}: {width}x{height} (expected {dimensions['width']}x{dimensions['height']})")
                
                # Check minimum size requirement
                if min(width, height) < min_size:
                    print(f"⚠️  {screenshot_file.name}: Below minimum size requirement ({min_size}px)")
                    
        except Exception as e:
            print(f"❌ Error validating {screenshot_file.name}: {e}")
    
    print(f"\nValid screenshots: {valid_count}/{config['count']}")
    return valid_count >= config["count"]

def create_screenshot_summary():
    """Create a summary of generated screenshots."""
    summary = {
        "generated_at": datetime.now().isoformat(),
        "device_configs": DEVICE_CONFIGS,
        "screenshots": {}
    }
    
    for device_type in DEVICE_CONFIGS.keys():
        summary["screenshots"][device_type] = {}
        for orientation in ["portrait", "landscape"]:
            screenshots_dir = SCREENSHOTS_DIR / device_type / orientation
            if screenshots_dir.exists():
                files = list(screenshots_dir.glob("*.png"))
                summary["screenshots"][device_type][orientation] = {
                    "count": len(files),
                    "files": [f.name for f in files]
                }
            else:
                summary["screenshots"][device_type][orientation] = {"count": 0, "files": []}
    
    summary_file = SCREENSHOTS_DIR / "screenshot_summary.json"
    summary_file.write_text(json.dumps(summary, indent=2))
    print(f"📊 Screenshot summary saved: {summary_file}")

def main():
    parser = argparse.ArgumentParser(description="Generate Google Play Store screenshots")
    parser.add_argument("--device-type", choices=["phone", "tablet7", "tablet10"], 
                       default="phone", help="Device type to generate screenshots for")
    parser.add_argument("--orientation", choices=["portrait", "landscape"], 
                       default="portrait", help="Screen orientation")
    parser.add_argument("--count", type=int, help="Number of screenshots to generate")
    parser.add_argument("--all", action="store_true", help="Generate all device types and orientations")
    parser.add_argument("--validate-only", action="store_true", help="Only validate existing screenshots")
    parser.add_argument("--no-web-server", action="store_true", help="Skip starting web server (assume already running)")
    
    args = parser.parse_args()
    
    # Check dependencies
    check_dependencies()
    
    if args.validate_only:
        print("Validating existing screenshots...")
        for device_type in DEVICE_CONFIGS.keys():
            for orientation in ["portrait", "landscape"]:
                print(f"\n--- {device_type} {orientation} ---")
                validate_screenshots(device_type, orientation)
        create_screenshot_summary()
        return
    
    # Start Flutter web server
    flutter_process = None
    if not args.no_web_server:
        flutter_process = start_flutter_web()
        if not flutter_process:
            print("❌ Cannot proceed without Flutter web server")
            return
    
    try:
        if args.all:
            # Generate all combinations
            for device_type in DEVICE_CONFIGS.keys():
                for orientation in ["portrait", "landscape"]:
                    print(f"\n=== Generating {device_type} {orientation} screenshots ===")
                    count = args.count or DEVICE_CONFIGS[device_type]["count"]
                    
                    asyncio.run(capture_screenshots(device_type, orientation, count))
                    validate_screenshots(device_type, orientation)
        else:
            # Generate specific device type and orientation
            device_type = args.device_type
            orientation = args.orientation
            count = args.count or DEVICE_CONFIGS[device_type]["count"]
            
            print(f"Generating {count} {device_type} {orientation} screenshots...")
            
            asyncio.run(capture_screenshots(device_type, orientation, count))
            validate_screenshots(device_type, orientation)
        
        create_screenshot_summary()
        print("\n🎉 Screenshot generation completed!")
        
    finally:
        # Clean up Flutter process
        if flutter_process:
            print("Stopping Flutter web server...")
            flutter_process.terminate()
            flutter_process.wait()

if __name__ == "__main__":
    main()