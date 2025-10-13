#!/usr/bin/env python3
"""
Automated screenshot generation for Chip Companion Google Play Store submission.

This script automatically captures all required screenshots with unique, descriptive filenames
that include device type, orientation, size, and content type.

Usage:
    python3 tools/auto_generate_screenshots.py [--device-type phone|tablet7|tablet10] [--all]
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

# Device configurations with exact Google Play Store requirements
DEVICE_CONFIGS = {
    "phone": {
        "portrait": {"width": 1080, "height": 1920, "ratio": "9x16"},
        "landscape": {"width": 1920, "height": 1080, "ratio": "16x9"},
        "count": 8,
        "min_size": 1080,
        "play_store_type": "phone"
    },
    "tablet7": {
        "portrait": {"width": 1200, "height": 1920, "ratio": "5x8"},
        "landscape": {"width": 1920, "height": 1200, "ratio": "8x5"},
        "count": 5,
        "min_size": 1200,
        "play_store_type": "7inch_tablet"
    },
    "tablet10": {
        "portrait": {"width": 1600, "height": 2560, "ratio": "5x8"},
        "landscape": {"width": 2560, "height": 1600, "ratio": "8x5"},
        "count": 5,
        "min_size": 1600,
        "play_store_type": "10inch_tablet"
    }
}

# Screenshot scenarios with unique identifiers
SCREENSHOT_SCENARIOS = [
    {
        "id": "home_main",
        "name": "Home Screen Main Interface",
        "description": "Main home screen with chip ID input field",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 15, "reason": "initial_app_load"},
            {"type": "click", "selector": "input[type='text'], input", "wait_after": 3},
            {"type": "wait", "duration": 2, "reason": "input_focus"}
        ],
        "key_elements": ["chip_input_field", "validate_button", "app_header"]
    },
    {
        "id": "home_sample_chip",
        "name": "Home Screen With Sample Chip ID",
        "description": "Home screen showing sample microchip ID entered",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 15, "reason": "initial_app_load"},
            {"type": "type", "selector": "input[type='text'], input", "text": "982000123456789", "wait_after": 3},
            {"type": "wait", "duration": 2, "reason": "input_processed"}
        ],
        "key_elements": ["sample_chip_id", "validate_button_ready", "input_styling"]
    },
    {
        "id": "validation_result",
        "name": "Chip Validation Result Display",
        "description": "Validation result showing chip format and registry information",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 15, "reason": "initial_app_load"},
            {"type": "type", "selector": "input[type='text'], input", "text": "982000123456789", "wait_after": 3},
            {"type": "click", "selector": "button:contains('Validate'), button", "wait_after": 8},
            {"type": "wait", "duration": 3, "reason": "validation_complete"}
        ],
        "key_elements": ["validation_result", "chip_format_info", "registry_info", "success_indicator"]
    },
    {
        "id": "devices_main",
        "name": "Devices Screen Scanner Options",
        "description": "Devices screen showing Bluetooth and NFC scanner options",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 15, "reason": "initial_app_load"},
            {"type": "click", "selector": "button:contains('Devices'), [data-tab='devices']", "wait_after": 5},
            {"type": "wait", "duration": 3, "reason": "devices_screen_loaded"}
        ],
        "key_elements": ["bluetooth_scanner_option", "nfc_scanner_option", "device_status", "scanner_availability"]
    },
    {
        "id": "bluetooth_scanner",
        "name": "Bluetooth Scanner Interface",
        "description": "Bluetooth scanner interface with device management",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 15, "reason": "initial_app_load"},
            {"type": "click", "selector": "button:contains('Devices'), [data-tab='devices']", "wait_after": 3},
            {"type": "click", "selector": "button:contains('Bluetooth'), [data-scanner='bluetooth']", "wait_after": 5},
            {"type": "wait", "duration": 3, "reason": "bluetooth_interface_loaded"}
        ],
        "key_elements": ["bluetooth_status", "paired_devices_list", "scan_button", "device_management"]
    },
    {
        "id": "nfc_scanner",
        "name": "NFC Scanner Interface",
        "description": "NFC scanner interface with tap-to-scan functionality",
        "url_path": "/",
        "actions": [
            {"type": "wait", "duration": 15, "reason": "initial_app_load"},
            {"type": "click", "selector": "button:contains('Devices'), [data-tab='devices']", "wait_after": 3},
            {"type": "click", "selector": "button:contains('NFC'), [data-scanner='nfc']", "wait_after": 5},
            {"type": "wait", "duration": 3, "reason": "nfc_interface_loaded"}
        ],
        "key_elements": ["nfc_status_indicator", "nfc_instructions", "scan_button", "nfc_capability_info"]
    },
    {
        "id": "help_screen",
        "name": "Help and FAQ Screen",
        "description": "Help screen with FAQ content and instructions",
        "url_path": "/help",
        "actions": [
            {"type": "wait", "duration": 20, "reason": "help_content_load"},
            {"type": "wait", "duration": 3, "reason": "tabs_rendered"}
        ],
        "key_elements": ["help_tabs", "faq_content", "instructions_text", "navigation_elements"]
    },
    {
        "id": "settings_screen",
        "name": "Settings and Preferences Screen",
        "description": "Settings screen with language and app preferences",
        "url_path": "/settings",
        "actions": [
            {"type": "wait", "duration": 15, "reason": "settings_load"},
            {"type": "wait", "duration": 3, "reason": "options_rendered"}
        ],
        "key_elements": ["language_selector", "settings_options", "app_preferences", "configuration_controls"]
    }
]

def check_dependencies():
    """Check and install required dependencies."""
    try:
        import playwright
        print("✅ Playwright is installed")
    except ImportError:
        print("❌ Playwright not installed. Installing...")
        subprocess.run([sys.executable, "-m", "pip", "install", "playwright"], check=True)
        subprocess.run(["playwright", "install", "chromium"], check=True)
        print("✅ Playwright installed successfully")
    
    try:
        from PIL import Image
        print("✅ PIL/Pillow is installed")
    except ImportError:
        print("❌ PIL not installed. Installing...")
        subprocess.run([sys.executable, "-m", "pip", "install", "Pillow"], check=True)
        print("✅ PIL installed successfully")

def generate_unique_filename(device_type, orientation, scenario, dimensions):
    """Generate unique, descriptive filename for screenshot."""
    config = DEVICE_CONFIGS[device_type]
    dims = config[orientation]
    
    # Format: device_type_orientation_size_ratio_scenario_id.png
    # Example: phone_portrait_1080x1920_9x16_home_main.png
    filename = f"{device_type}_{orientation}_{dims['width']}x{dims['height']}_{dims['ratio']}_{scenario['id']}.png"
    
    return filename

def create_screenshot_directories():
    """Create organized directory structure for screenshots."""
    SCREENSHOTS_DIR.mkdir(parents=True, exist_ok=True)
    
    for device_type in DEVICE_CONFIGS.keys():
        for orientation in ["portrait", "landscape"]:
            (SCREENSHOTS_DIR / device_type / orientation).mkdir(parents=True, exist_ok=True)
    
    print(f"✅ Created screenshot directories in {SCREENSHOTS_DIR}")

async def capture_screenshots_automated(device_type: str, orientation: str, count: int):
    """Automatically capture screenshots using Playwright."""
    from playwright.async_api import async_playwright
    
    config = DEVICE_CONFIGS[device_type]
    dimensions = config[orientation]
    
    # Create output directory
    output_dir = SCREENSHOTS_DIR / device_type / orientation
    output_dir.mkdir(parents=True, exist_ok=True)
    
    async with async_playwright() as p:
        # Launch browser with optimized settings
        browser = await p.chromium.launch(
            headless=True,
            args=['--no-sandbox', '--disable-dev-shm-usage']
        )
        
        context = await browser.new_context(
            viewport={"width": dimensions["width"], "height": dimensions["height"]},
            device_scale_factor=1,
            user_agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        )
        
        page = await context.new_page()
        
        print(f"🎯 Capturing {count} screenshots for {device_type} {orientation} ({dimensions['width']}x{dimensions['height']})")
        print("=" * 80)
        
        successful_captures = 0
        
        for i, scenario in enumerate(SCREENSHOT_SCENARIOS[:count], 1):
            print(f"\n📸 Screenshot {i}/{count}: {scenario['name']}")
            print(f"   Description: {scenario['description']}")
            
            try:
                # Navigate to the page
                url = f"http://localhost:{WEB_PORT}{scenario['url_path']}"
                print(f"   🌐 Navigating to: {url}")
                await page.goto(url, wait_until="networkidle", timeout=30000)
                
                # Execute actions with proper waiting
                for action in scenario["actions"]:
                    action_type = action["type"]
                    duration = action.get("duration", 0)
                    reason = action.get("reason", "unknown")
                    
                    if action_type == "wait":
                        print(f"   ⏳ Waiting {duration}s ({reason})...")
                        await page.wait_for_timeout(duration * 1000)
                    elif action_type == "click":
                        selector = action["selector"]
                        print(f"   🖱️  Clicking: {selector}")
                        await page.click(selector)
                        if "wait_after" in action:
                            await page.wait_for_timeout(action["wait_after"] * 1000)
                    elif action_type == "type":
                        selector = action["selector"]
                        text = action["text"]
                        print(f"   ⌨️  Typing in {selector}: {text}")
                        await page.fill(selector, text)
                        if "wait_after" in action:
                            await page.wait_for_timeout(action["wait_after"] * 1000)
                
                # Generate unique filename
                filename = generate_unique_filename(device_type, orientation, scenario, dimensions)
                screenshot_path = output_dir / filename
                
                # Take full page screenshot
                print(f"   📷 Capturing screenshot...")
                await page.screenshot(
                    path=str(screenshot_path), 
                    full_page=True,
                    type='png'
                )
                
                # Verify screenshot was created and has correct dimensions
                from PIL import Image
                with Image.open(screenshot_path) as img:
                    width, height = img.size
                    file_size = screenshot_path.stat().st_size / 1024 / 1024  # MB
                    
                    print(f"   ✅ Captured: {filename}")
                    print(f"      Dimensions: {width}x{height}")
                    print(f"      File size: {file_size:.2f} MB")
                    print(f"      Key elements: {', '.join(scenario['key_elements'])}")
                    
                    # Validate dimensions
                    if width == dimensions["width"] and height == dimensions["height"]:
                        print(f"      ✅ Dimensions correct for Google Play Store")
                    else:
                        print(f"      ⚠️  Dimensions mismatch (expected {dimensions['width']}x{dimensions['height']})")
                    
                    successful_captures += 1
                
            except Exception as e:
                print(f"   ❌ Error capturing {scenario['name']}: {e}")
                continue
        
        await browser.close()
        
        print(f"\n📊 Summary for {device_type} {orientation}:")
        print(f"   ✅ Successfully captured: {successful_captures}/{count}")
        print(f"   📁 Saved to: {output_dir}")
        
        return successful_captures

def validate_all_screenshots():
    """Validate all generated screenshots."""
    try:
        from PIL import Image
    except ImportError:
        print("❌ PIL not available for validation")
        return False
    
    print("\n🔍 Validating all screenshots...")
    print("=" * 50)
    
    total_valid = 0
    total_expected = 0
    
    for device_type, config in DEVICE_CONFIGS.items():
        print(f"\n📱 {device_type.upper()} ({config['play_store_type']})")
        print("-" * 40)
        
        for orientation in ["portrait", "landscape"]:
            dimensions = config[orientation]
            count = config["count"]
            
            screenshots_path = SCREENSHOTS_DIR / device_type / orientation
            screenshot_files = list(screenshots_path.glob("*.png"))
            
            print(f"\n{orientation.title()}:")
            print(f"  Expected: {count} screenshots")
            print(f"  Found: {len(screenshot_files)} screenshots")
            print(f"  Target: {dimensions['width']}x{dimensions['height']} ({dimensions['ratio']})")
            
            valid_count = 0
            for screenshot_file in screenshot_files:
                try:
                    with Image.open(screenshot_file) as img:
                        width, height = img.size
                        file_size = screenshot_file.stat().st_size / 1024 / 1024  # MB
                        
                        if width == dimensions["width"] and height == dimensions["height"]:
                            print(f"  ✅ {screenshot_file.name}")
                            print(f"     {width}x{height}, {file_size:.2f}MB")
                            valid_count += 1
                        else:
                            print(f"  ❌ {screenshot_file.name}")
                            print(f"     {width}x{height} (expected {dimensions['width']}x{dimensions['height']})")
                            
                except Exception as e:
                    print(f"  ❌ Error validating {screenshot_file.name}: {e}")
            
            print(f"  Valid: {valid_count}/{count}")
            total_valid += valid_count
            total_expected += count
    
    print(f"\n📊 TOTAL VALIDATION: {total_valid}/{total_expected} screenshots")
    
    if total_valid == total_expected:
        print("🎉 All screenshots are valid and ready for Google Play Store!")
    else:
        print("⚠️  Some screenshots need attention.")
    
    return total_valid == total_expected

def create_screenshot_manifest():
    """Create a manifest file documenting all screenshots."""
    manifest = {
        "generated_at": datetime.now().isoformat(),
        "total_screenshots": 0,
        "device_configs": DEVICE_CONFIGS,
        "screenshots": {}
    }
    
    total_count = 0
    
    for device_type in DEVICE_CONFIGS.keys():
        manifest["screenshots"][device_type] = {}
        for orientation in ["portrait", "landscape"]:
            screenshots_dir = SCREENSHOTS_DIR / device_type / orientation
            if screenshots_dir.exists():
                files = list(screenshots_dir.glob("*.png"))
                manifest["screenshots"][device_type][orientation] = {
                    "count": len(files),
                    "files": [f.name for f in files]
                }
                total_count += len(files)
            else:
                manifest["screenshots"][device_type][orientation] = {"count": 0, "files": []}
    
    manifest["total_screenshots"] = total_count
    
    manifest_file = SCREENSHOTS_DIR / "screenshot_manifest.json"
    manifest_file.write_text(json.dumps(manifest, indent=2))
    
    print(f"📋 Screenshot manifest created: {manifest_file}")
    return manifest

def main():
    parser = argparse.ArgumentParser(description="Automated screenshot generation for Google Play Store")
    parser.add_argument("--device-type", choices=["phone", "tablet7", "tablet10"], 
                       default="phone", help="Device type to generate screenshots for")
    parser.add_argument("--orientation", choices=["portrait", "landscape"], 
                       default="portrait", help="Screen orientation")
    parser.add_argument("--count", type=int, help="Number of screenshots to generate")
    parser.add_argument("--all", action="store_true", help="Generate all device types and orientations")
    parser.add_argument("--validate-only", action="store_true", help="Only validate existing screenshots")
    
    args = parser.parse_args()
    
    print("🎯 Chip Companion - Automated Screenshot Generation")
    print("=" * 60)
    print(f"🕐 Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Check dependencies
    check_dependencies()
    
    # Create directories
    create_screenshot_directories()
    
    if args.validate_only:
        validate_all_screenshots()
        create_screenshot_manifest()
        return
    
    if args.all:
        # Generate all combinations
        total_successful = 0
        total_expected = 0
        
        for device_type in DEVICE_CONFIGS.keys():
            for orientation in ["portrait", "landscape"]:
                print(f"\n{'='*80}")
                print(f"🎯 GENERATING: {device_type.upper()} {orientation.upper()}")
                print(f"{'='*80}")
                
                count = args.count or DEVICE_CONFIGS[device_type]["count"]
                total_expected += count
                
                successful = asyncio.run(capture_screenshots_automated(device_type, orientation, count))
                total_successful += successful
        
        print(f"\n🎉 AUTOMATION COMPLETE!")
        print(f"📊 Total: {total_successful}/{total_expected} screenshots captured")
        
    else:
        # Generate specific device type and orientation
        device_type = args.device_type
        orientation = args.orientation
        count = args.count or DEVICE_CONFIGS[device_type]["count"]
        
        successful = asyncio.run(capture_screenshots_automated(device_type, orientation, count))
        print(f"\n🎉 Generation complete: {successful}/{count} screenshots captured")
    
    # Validate and create manifest
    validate_all_screenshots()
    create_screenshot_manifest()
    
    print(f"\n🕐 Completed at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("🚀 Screenshots ready for Google Play Store submission!")

if __name__ == "__main__":
    main()
