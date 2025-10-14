#!/usr/bin/env python3
"""
Simple and reliable screenshot generator for Chip Companion.
Uses JavaScript bridge and direct URLs to navigate to different screens.

Usage:
    python3 tools/simple_screenshot_generator.py [--device-type phone|tablet7|tablet10] [--all]
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
        "min_size": 1080,
    },
    "tablet7": {
        "portrait": {"width": 1200, "height": 1920, "ratio": "5x8"},
        "landscape": {"width": 1920, "height": 1200, "ratio": "8x5"},
        "count": 5,
        "min_size": 1200,
    },
    "tablet10": {
        "portrait": {"width": 1600, "height": 2560, "ratio": "5x8"},
        "landscape": {"width": 2560, "height": 1600, "ratio": "8x5"},
        "count": 5,
        "min_size": 1600,
    }
}

# Screenshot scenarios using JavaScript bridge and direct URLs
SCREENSHOT_SCENARIOS = [
    {
        "id": "home_main",
        "name": "Home Screen Main Interface",
        "description": "Main home screen with chip ID input field",
        "url": "http://localhost:8080/",
        "js_actions": [
            {"type": "wait", "duration": 15},
            {"type": "evaluate", "script": "document.querySelector('input')?.focus()"},
            {"type": "wait", "duration": 3}
        ]
    },
    {
        "id": "home_sample_chip",
        "name": "Home Screen With Sample Chip ID",
        "description": "Home screen showing sample microchip ID entered",
        "url": "http://localhost:8080/",
        "js_actions": [
            {"type": "wait", "duration": 15},
            {"type": "evaluate", "script": "const input = document.querySelector('input'); if(input) { input.value = '982000123456789'; input.dispatchEvent(new Event('input', { bubbles: true })); }"},
            {"type": "wait", "duration": 3}
        ]
    },
    {
        "id": "devices_tab",
        "name": "Devices Tab Interface",
        "description": "Devices tab showing scanner options",
        "url": "http://localhost:8080/",
        "js_actions": [
            {"type": "wait", "duration": 15},
            {"type": "evaluate", "script": "if(window.navigateToTab) { window.navigateToTab(1); } else { console.log('JS bridge not available'); }"},
            {"type": "wait", "duration": 8}
        ]
    },
    {
        "id": "glossary_screen",
        "name": "Glossary Screen",
        "description": "Microchip glossary with definitions",
        "url": "http://localhost:8080/glossary",
        "js_actions": [
            {"type": "wait", "duration": 15}
        ]
    },
    {
        "id": "support_screen",
        "name": "Support Screen",
        "description": "Support and contact information",
        "url": "http://localhost:8080/support",
        "js_actions": [
            {"type": "wait", "duration": 15}
        ]
    },
    {
        "id": "home_validation_ready",
        "name": "Home Screen Ready for Validation",
        "description": "Home screen with chip ID ready for validation",
        "url": "http://localhost:8080/",
        "js_actions": [
            {"type": "wait", "duration": 15},
            {"type": "evaluate", "script": "const input = document.querySelector('input'); if(input) { input.value = '982000123456789'; input.focus(); input.dispatchEvent(new Event('input', { bubbles: true })); }"},
            {"type": "wait", "duration": 5}
        ]
    },
    {
        "id": "devices_main",
        "name": "Devices Screen Main View",
        "description": "Main devices screen with all scanner options",
        "url": "http://localhost:8080/",
        "js_actions": [
            {"type": "wait", "duration": 15},
            {"type": "evaluate", "script": "if(window.navigateToTab) { window.navigateToTab(1); } else { console.log('JS bridge not available'); }"},
            {"type": "wait", "duration": 10}
        ]
    },
    {
        "id": "home_clean",
        "name": "Home Screen Clean State",
        "description": "Home screen in clean state without input",
        "url": "http://localhost:8080/",
        "js_actions": [
            {"type": "wait", "duration": 15},
            {"type": "evaluate", "script": "if(window.navigateToTab) { window.navigateToTab(0); } else { console.log('JS bridge not available'); }"},
            {"type": "wait", "duration": 5}
        ]
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
    """Capture screenshots with reliable navigation."""
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
                
                # Execute JavaScript actions
                for action in scenario['js_actions']:
                    if action['type'] == 'wait':
                        print(f"   ⏳ Waiting {action['duration']}s...")
                        await page.wait_for_timeout(action['duration'] * 1000)
                    elif action['type'] == 'evaluate':
                        try:
                            await page.evaluate(action['script'])
                            print(f"   🔧 Executed JS: {action['script'][:50]}...")
                        except Exception as e:
                            print(f"   ⚠️  JS error (continuing): {e}")
                
                # Take screenshot
                filename = generate_filename(device_type, orientation, scenario, dimensions)
                screenshot_path = output_dir / filename
                
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

def main():
    parser = argparse.ArgumentParser(description="Simple screenshot generator")
    parser.add_argument("--device-type", choices=["phone", "tablet7", "tablet10"], 
                       default="phone", help="Device type")
    parser.add_argument("--orientation", choices=["portrait", "landscape"], 
                       default="portrait", help="Orientation")
    parser.add_argument("--count", type=int, help="Number of screenshots")
    parser.add_argument("--all", action="store_true", help="Generate all")
    parser.add_argument("--validate-only", action="store_true", help="Only validate")
    
    args = parser.parse_args()
    
    print("🎯 Chip Companion - Simple Screenshot Generator")
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
    print(f"\n🕐 Finished: {datetime.now().strftime('%H:%M:%S')}")

if __name__ == "__main__":
    main()
