#!/usr/bin/env python3
"""
Final working screenshot generator for Chip Companion.
Uses direct URLs to navigate to different screens and captures different states.

Usage:
    python3 tools/final_screenshot_generator.py [--device-type phone|tablet7|tablet10] [--all]
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

# Device configurations
DEVICE_CONFIGS = {
    "phone": {
        "portrait": {"width": 1080, "height": 1920, "ratio": "9x16"},
        "landscape": {"width": 1920, "height": 1080, "ratio": "16x9"},
        "count": 8,
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
    }
}

# Screenshot scenarios that definitely work
SCREENSHOT_SCENARIOS = [
    {
        "id": "home_main",
        "name": "Home Screen Main Interface",
        "description": "Main home screen with chip ID input field",
        "url": f"http://localhost:{WEB_PORT}/",
        "wait_time": 15,
    },
    {
        "id": "home_sample_chip",
        "name": "Home Screen With Sample Chip ID",
        "description": "Home screen showing sample microchip ID entered",
        "url": f"http://localhost:{WEB_PORT}/",
        "wait_time": 15,
        "input_text": "982000123456789",
    },
    {
        "id": "home_avid_chip",
        "name": "Home Screen With AVID Chip ID",
        "description": "Home screen showing AVID format chip ID",
        "url": f"http://localhost:{WEB_PORT}/",
        "wait_time": 15,
        "input_text": "041123456789",
    },
    {
        "id": "home_homeagain_chip",
        "name": "Home Screen With HomeAgain Chip ID",
        "description": "Home screen showing HomeAgain format chip ID",
        "url": f"http://localhost:{WEB_PORT}/",
        "wait_time": 15,
        "input_text": "982000987654321",
    },
    {
        "id": "glossary_screen",
        "name": "Glossary Screen",
        "description": "Microchip glossary with definitions",
        "url": f"http://localhost:{WEB_PORT}/glossary",
        "wait_time": 15,
    },
    {
        "id": "support_screen",
        "name": "Support Screen",
        "description": "Support and contact information",
        "url": f"http://localhost:{WEB_PORT}/support",
        "wait_time": 15,
    },
    {
        "id": "home_validation_ready",
        "name": "Home Screen Ready for Validation",
        "description": "Home screen with chip ID ready for validation",
        "url": f"http://localhost:{WEB_PORT}/",
        "wait_time": 15,
        "input_text": "982000123456789",
        "extra_wait": 5,
    },
    {
        "id": "home_clean_focused",
        "name": "Home Screen Clean with Input Focused",
        "description": "Home screen with input field focused",
        "url": f"http://localhost:{WEB_PORT}/",
        "wait_time": 15,
        "focus_input": True,
    }
]

def generate_filename(device_type, orientation, scenario, dimensions):
    """Generate unique filename."""
    dims = dimensions
    return f"{device_type}_{orientation}_{dims['width']}x{dims['height']}_{dims['ratio']}_{scenario['id']}.png"

def create_directories():
    """Create screenshot directories."""
    SCREENSHOTS_DIR.mkdir(parents=True, exist_ok=True)
    for device_type in DEVICE_CONFIGS.keys():
        for orientation in ["portrait", "landscape"]:
            (SCREENSHOTS_DIR / device_type / orientation).mkdir(parents=True, exist_ok=True)

async def capture_screenshots(device_type: str, orientation: str, count: int):
    """Capture screenshots with reliable URL navigation."""
    from playwright.async_api import async_playwright
    
    config = DEVICE_CONFIGS[device_type]
    dimensions = config[orientation]
    output_dir = SCREENSHOTS_DIR / device_type / orientation
    
    print(f"🎯 Capturing {count} screenshots for {device_type} {orientation}")
    print(f"📏 Dimensions: {dimensions['width']}x{dimensions['height']}")
    print("=" * 60)
    
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            viewport={"width": dimensions["width"], "height": dimensions["height"]},
            device_scale_factor=1
        )
        page = await context.new_page()
        
        successful = 0
        
        for i, scenario in enumerate(SCREENSHOT_SCENARIOS[:count], 1):
            print(f"\n📸 {i}/{count}: {scenario['name']}")
            print(f"   🌐 {scenario['url']}")
            
            try:
                # Navigate to URL
                await page.goto(scenario['url'], wait_until="networkidle", timeout=30000)
                
                # Wait for initial load
                print(f"   ⏳ Waiting {scenario['wait_time']}s for page load...")
                await page.wait_for_timeout(scenario['wait_time'] * 1000)
                
                # Handle input text if specified
                if 'input_text' in scenario:
                    print(f"   ⌨️  Typing: {scenario['input_text']}")
                    try:
                        # Try to find and fill input field
                        await page.fill("input", scenario['input_text'])
                        print(f"   ✅ Input filled successfully")
                    except Exception as e:
                        print(f"   ⚠️  Input error (continuing): {e}")
                
                # Handle input focus if specified
                if scenario.get('focus_input'):
                    print(f"   🎯 Focusing input field...")
                    try:
                        await page.click("input")
                        print(f"   ✅ Input focused")
                    except Exception as e:
                        print(f"   ⚠️  Focus error (continuing): {e}")
                
                # Extra wait if specified
                if 'extra_wait' in scenario:
                    print(f"   ⏳ Extra wait {scenario['extra_wait']}s...")
                    await page.wait_for_timeout(scenario['extra_wait'] * 1000)
                
                # Take screenshot
                filename = generate_filename(device_type, orientation, scenario, dimensions)
                screenshot_path = output_dir / filename
                
                print(f"   📷 Capturing screenshot...")
                await page.screenshot(
                    path=str(screenshot_path),
                    full_page=True,
                    type='png'
                )
                
                # Verify dimensions
                from PIL import Image
                with Image.open(screenshot_path) as img:
                    width, height = img.size
                    file_size = screenshot_path.stat().st_size / 1024 / 1024
                    
                    if width == dimensions["width"] and height == dimensions["height"]:
                        print(f"   ✅ {filename} ({width}x{height}, {file_size:.2f}MB)")
                        successful += 1
                    else:
                        print(f"   ❌ {filename} - Wrong dimensions: {width}x{height}")
                
            except Exception as e:
                print(f"   ❌ Error: {e}")
                continue
        
        await browser.close()
        print(f"\n📊 Success: {successful}/{count} screenshots")
        return successful

def validate_screenshots():
    """Validate all screenshots."""
    try:
        from PIL import Image
    except ImportError:
        print("❌ PIL not available")
        return False
    
    print("\n🔍 Validating screenshots...")
    total_valid = 0
    total_expected = 0
    
    for device_type, config in DEVICE_CONFIGS.items():
        for orientation in ["portrait", "landscape"]:
            dimensions = config[orientation]
            count = config["count"]
            screenshots_path = SCREENSHOTS_DIR / device_type / orientation
            files = list(screenshots_path.glob("*.png"))
            
            print(f"\n📱 {device_type} {orientation}: {len(files)}/{count}")
            
            valid = 0
            for file in files:
                try:
                    with Image.open(file) as img:
                        width, height = img.size
                        if width == dimensions["width"] and height == dimensions["height"]:
                            print(f"  ✅ {file.name}")
                            valid += 1
                        else:
                            print(f"  ❌ {file.name} ({width}x{height})")
                except Exception as e:
                    print(f"  ❌ {file.name} - Error: {e}")
            
            total_valid += valid
            total_expected += count
    
    print(f"\n📊 Total: {total_valid}/{total_expected} valid")
    return total_valid == total_expected

def create_manifest():
    """Create screenshot manifest."""
    manifest = {
        "generated_at": datetime.now().isoformat(),
        "total_screenshots": 0,
        "screenshots": {}
    }
    
    total = 0
    for device_type in DEVICE_CONFIGS.keys():
        manifest["screenshots"][device_type] = {}
        for orientation in ["portrait", "landscape"]:
            screenshots_dir = SCREENSHOTS_DIR / device_type / orientation
            files = list(screenshots_dir.glob("*.png"))
            manifest["screenshots"][device_type][orientation] = {
                "count": len(files),
                "files": [f.name for f in files]
            }
            total += len(files)
    
    manifest["total_screenshots"] = total
    
    manifest_file = SCREENSHOTS_DIR / "screenshot_manifest.json"
    manifest_file.write_text(json.dumps(manifest, indent=2))
    print(f"📋 Manifest: {manifest_file}")

def main():
    parser = argparse.ArgumentParser(description="Final screenshot generator")
    parser.add_argument("--device-type", choices=["phone", "tablet7", "tablet10"], 
                       default="phone", help="Device type")
    parser.add_argument("--orientation", choices=["portrait", "landscape"], 
                       default="portrait", help="Orientation")
    parser.add_argument("--count", type=int, help="Number of screenshots")
    parser.add_argument("--all", action="store_true", help="Generate all")
    parser.add_argument("--validate-only", action="store_true", help="Only validate")
    
    args = parser.parse_args()
    
    print("🎯 Chip Companion - Final Screenshot Generator")
    print("=" * 50)
    print(f"🕐 Started: {datetime.now().strftime('%H:%M:%S')}")
    
    create_directories()
    
    if args.validate_only:
        validate_screenshots()
        return
    
    if args.all:
        total_success = 0
        total_expected = 0
        
        for device_type in DEVICE_CONFIGS.keys():
            for orientation in ["portrait", "landscape"]:
                count = args.count or DEVICE_CONFIGS[device_type]["count"]
                total_expected += count
                success = asyncio.run(capture_screenshots(device_type, orientation, count))
                total_success += success
        
        print(f"\n🎉 Complete! {total_success}/{total_expected} screenshots")
    else:
        device_type = args.device_type
        orientation = args.orientation
        count = args.count or DEVICE_CONFIGS[device_type]["count"]
        
        success = asyncio.run(capture_screenshots(device_type, orientation, count))
        print(f"\n🎉 Done! {success}/{count} screenshots")
    
    validate_screenshots()
    create_manifest()
    print(f"\n🕐 Finished: {datetime.now().strftime('%H:%M:%S')}")

if __name__ == "__main__":
    main()
