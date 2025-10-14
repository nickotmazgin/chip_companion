#!/usr/bin/env python3
"""
Manual screenshot generation guide for Chip Companion Google Play Store submission.

This script provides step-by-step instructions and templates for creating
the required screenshots manually using Flutter's web version.

Requirements:
- Phone screenshots: 8/8 (16:9 or 9:16, 320px-3840px sides, min 1080px for promotion)
- 7-inch tablet screenshots: 5/8 (16:9 or 9:16, 320px-3840px sides)  
- 10-inch tablet screenshots: 5/8 (16:9 or 9:16, 1080px-7680px sides)

Usage:
    python tools/generate_screenshots_manual.py
"""

import json
import os
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

# Screenshot scenarios with detailed instructions
SCREENSHOT_SCENARIOS = [
    {
        "name": "home_screen",
        "description": "Home screen with chip ID input field",
        "instructions": [
            "1. Navigate to the home screen",
            "2. Ensure the chip ID input field is visible and focused",
            "3. Capture the screen showing the main interface"
        ],
        "key_elements": ["Chip ID input field", "Validate button", "App title"]
    },
    {
        "name": "home_with_sample_chip",
        "description": "Home screen with sample chip ID entered",
        "instructions": [
            "1. Enter a sample chip ID: 982000123456789",
            "2. Show the input field with the chip ID",
            "3. Capture before validation"
        ],
        "key_elements": ["Sample chip ID in input field", "Validate button ready"]
    },
    {
        "name": "validation_result",
        "description": "Chip validation result display",
        "instructions": [
            "1. Enter chip ID: 982000123456789",
            "2. Click Validate button",
            "3. Capture the validation result showing format and registry info"
        ],
        "key_elements": ["Validation result", "Chip format info", "Registry information"]
    },
    {
        "name": "devices_screen",
        "description": "Devices screen with scanner options",
        "instructions": [
            "1. Navigate to Devices tab",
            "2. Show the scanner options interface",
            "3. Capture the main devices screen"
        ],
        "key_elements": ["Bluetooth scanner option", "NFC scanner option", "Device status"]
    },
    {
        "name": "bluetooth_scanner",
        "description": "Bluetooth scanner interface",
        "instructions": [
            "1. Go to Devices tab",
            "2. Click on Bluetooth Scanner",
            "3. Capture the Bluetooth scanner interface"
        ],
        "key_elements": ["Bluetooth status", "Paired devices", "Scan button"]
    },
    {
        "name": "nfc_scanner",
        "description": "NFC scanner interface",
        "instructions": [
            "1. Go to Devices tab", 
            "2. Click on NFC Scanner",
            "3. Capture the NFC scanner interface"
        ],
        "key_elements": ["NFC status", "NFC instructions", "Scan button"]
    },
    {
        "name": "help_screen",
        "description": "Help and FAQ screen",
        "instructions": [
            "1. Navigate to Help screen (via menu or direct URL)",
            "2. Show the help content with tabs",
            "3. Capture the help interface"
        ],
        "key_elements": ["Help tabs", "FAQ content", "Instructions"]
    },
    {
        "name": "settings_screen",
        "description": "Settings and preferences screen",
        "instructions": [
            "1. Navigate to Settings screen",
            "2. Show language and preference options",
            "3. Capture the settings interface"
        ],
        "key_elements": ["Language selector", "Settings options", "App preferences"]
    }
]

def create_screenshot_directories():
    """Create directory structure for screenshots."""
    SCREENSHOTS_DIR.mkdir(parents=True, exist_ok=True)
    
    for device_type in DEVICE_CONFIGS.keys():
        for orientation in ["portrait", "landscape"]:
            (SCREENSHOTS_DIR / device_type / orientation).mkdir(parents=True, exist_ok=True)
    
    print(f"✅ Created screenshot directories in {SCREENSHOTS_DIR}")

def generate_instructions():
    """Generate detailed instructions for manual screenshot capture."""
    
    instructions_file = SCREENSHOTS_DIR / "SCREENSHOT_INSTRUCTIONS.md"
    
    content = f"""# Chip Companion - Google Play Store Screenshot Instructions

Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## Overview

This guide provides step-by-step instructions for creating the required screenshots for Google Play Store submission.

## Requirements

### Phone Screenshots (8 required)
- **Dimensions**: 1080x1920 (portrait) or 1920x1080 (landscape)
- **Format**: PNG or JPEG, up to 8MB each
- **Aspect Ratio**: 16:9 or 9:16
- **Minimum Size**: 1080px on each side (for promotion eligibility)

### 7-inch Tablet Screenshots (5 required)
- **Dimensions**: 1200x1920 (portrait) or 1920x1200 (landscape)
- **Format**: PNG or JPEG, up to 8MB each
- **Aspect Ratio**: 16:9 or 9:16

### 10-inch Tablet Screenshots (5 required)
- **Dimensions**: 1600x2560 (portrait) or 2560x1600 (landscape)
- **Format**: PNG or JPEG, up to 8MB each
- **Aspect Ratio**: 16:9 or 9:16

## Setup Instructions

### 1. Start Flutter Web Server
```bash
cd {ROOT_DIR}
flutter run -d web-server --web-port {WEB_PORT}
```

### 2. Open Browser
Navigate to: http://localhost:{WEB_PORT}

### 3. Set Browser Dimensions
Use browser developer tools to set viewport dimensions:

**Phone Portrait**: 1080x1920
**Phone Landscape**: 1920x1080
**7-inch Tablet Portrait**: 1200x1920
**7-inch Tablet Landscape**: 1920x1200
**10-inch Tablet Portrait**: 1600x2560
**10-inch Tablet Landscape**: 2560x1600

## Screenshot Scenarios

"""
    
    for i, scenario in enumerate(SCREENSHOT_SCENARIOS, 1):
        content += f"""
### {i}. {scenario['description']}

**File Name**: `{{device_type}}_{{orientation}}_{i:02d}_{scenario['name']}.png`

**Instructions**:
"""
        for instruction in scenario['instructions']:
            content += f"- {instruction}\n"
        
        content += f"""
**Key Elements to Include**:
"""
        for element in scenario['key_elements']:
            content += f"- {element}\n"
        
        content += "\n---\n"
    
    content += f"""
## File Organization

Save screenshots in the following structure:
```
assets/screenshots/
├── phone/
│   ├── portrait/
│   │   ├── phone_portrait_01_home_screen.png
│   │   ├── phone_portrait_02_home_with_sample_chip.png
│   │   └── ...
│   └── landscape/
│       ├── phone_landscape_01_home_screen.png
│       └── ...
├── tablet7/
│   ├── portrait/
│   └── landscape/
└── tablet10/
    ├── portrait/
    └── landscape/
```

## Browser Developer Tools Setup

### Chrome/Edge:
1. Press F12 to open Developer Tools
2. Click the device toggle button (📱)
3. Set custom dimensions:
   - **Phone Portrait**: 1080 x 1920
   - **Phone Landscape**: 1920 x 1080
   - **7-inch Tablet Portrait**: 1200 x 1920
   - **7-inch Tablet Landscape**: 1920 x 1200
   - **10-inch Tablet Portrait**: 1600 x 2560
   - **10-inch Tablet Landscape**: 2560 x 1600

### Firefox:
1. Press F12 to open Developer Tools
2. Click the responsive design mode button
3. Set custom dimensions in the same way

## Screenshot Capture Methods

### Method 1: Browser Screenshot
1. Set viewport dimensions
2. Navigate to the required screen
3. Use browser's screenshot feature (right-click → "Capture screenshot")

### Method 2: Developer Tools Screenshot
1. Open Developer Tools (F12)
2. Set device dimensions
3. Use "Capture screenshot" in the device toolbar

### Method 3: Full Page Screenshot
1. Set viewport dimensions
2. Navigate to the required screen
3. Use browser's "Capture full size screenshot" option

## Quality Checklist

Before submitting, ensure each screenshot:
- [ ] Has correct dimensions for device type and orientation
- [ ] Shows the app interface clearly
- [ ] Includes all key elements mentioned
- [ ] Is properly cropped (no browser UI)
- [ ] Has good contrast and readability
- [ ] File size is under 8MB
- [ ] File format is PNG or JPEG

## Sample Chip IDs for Testing

Use these sample chip IDs for consistent screenshots:
- **ISO 11784/11785**: `982000123456789`
- **AVID**: `041123456789`
- **HomeAgain**: `982000987654321`

## Troubleshooting

### App Not Loading
- Ensure Flutter web server is running
- Check browser console for errors
- Try refreshing the page

### Wrong Dimensions
- Double-check viewport settings in developer tools
- Ensure browser zoom is set to 100%
- Verify custom device dimensions are correct

### Missing Elements
- Wait for page to fully load before capturing
- Check if JavaScript is enabled
- Ensure all app features are working

## Next Steps

After capturing all screenshots:
1. Validate dimensions using the validation script
2. Organize files in the correct directory structure
3. Compress images if needed (maintain quality)
4. Upload to Google Play Console

Good luck with your Google Play Store submission! 🚀
"""
    
    instructions_file.write_text(content)
    print(f"✅ Generated instructions: {instructions_file}")

def create_validation_script():
    """Create a script to validate screenshot dimensions."""
    
    validation_script = SCREENSHOTS_DIR / "validate_screenshots.py"
    
    content = '''#!/usr/bin/env python3
"""
Validate screenshot dimensions for Google Play Store submission.
"""

import json
from pathlib import Path
from PIL import Image

# Device configurations
DEVICE_CONFIGS = {
    "phone": {
        "portrait": {"width": 1080, "height": 1920},
        "landscape": {"width": 1920, "height": 1080},
        "count": 8,
        "min_size": 1080,
    },
    "tablet7": {
        "portrait": {"width": 1200, "height": 1920},
        "landscape": {"width": 1920, "height": 1200},
        "count": 5,
        "min_size": 1200,
    },
    "tablet10": {
        "portrait": {"width": 1600, "height": 2560},
        "landscape": {"width": 2560, "height": 1600},
        "count": 5,
        "min_size": 1600,
    }
}

def validate_screenshots():
    """Validate all screenshots."""
    screenshots_dir = Path(__file__).parent
    
    print("🔍 Validating screenshots...")
    print("=" * 50)
    
    total_valid = 0
    total_expected = 0
    
    for device_type, config in DEVICE_CONFIGS.items():
        print(f"\\n📱 {device_type.upper()}")
        print("-" * 30)
        
        for orientation in ["portrait", "landscape"]:
            dimensions = config[orientation]
            min_size = config["min_size"]
            count = config["count"]
            
            screenshots_path = screenshots_dir / device_type / orientation
            screenshot_files = list(screenshots_path.glob("*.png")) + list(screenshots_path.glob("*.jpg"))
            
            print(f"\\n{orientation.title()}:")
            print(f"  Expected: {count} screenshots")
            print(f"  Found: {len(screenshot_files)} screenshots")
            print(f"  Dimensions: {dimensions['width']}x{dimensions['height']}")
            print(f"  Min size: {min_size}px")
            
            valid_count = 0
            for screenshot_file in screenshot_files:
                try:
                    with Image.open(screenshot_file) as img:
                        width, height = img.size
                        
                        if width == dimensions["width"] and height == dimensions["height"]:
                            print(f"  ✅ {screenshot_file.name}: {width}x{height}")
                            valid_count += 1
                        else:
                            print(f"  ❌ {screenshot_file.name}: {width}x{height} (expected {dimensions['width']}x{dimensions['height']})")
                        
                        if min(width, height) < min_size:
                            print(f"  ⚠️  {screenshot_file.name}: Below minimum size ({min_size}px)")
                            
                except Exception as e:
                    print(f"  ❌ Error validating {screenshot_file.name}: {e}")
            
            print(f"  Valid: {valid_count}/{count}")
            total_valid += valid_count
            total_expected += count
    
    print("\\n" + "=" * 50)
    print(f"📊 SUMMARY: {total_valid}/{total_expected} screenshots valid")
    
    if total_valid == total_expected:
        print("🎉 All screenshots are valid!")
    else:
        print("⚠️  Some screenshots need attention.")

if __name__ == "__main__":
    validate_screenshots()
'''
    
    validation_script.write_text(content)
    validation_script.chmod(0o755)
    print(f"✅ Created validation script: {validation_script}")

def create_sample_data():
    """Create sample data for consistent screenshots."""
    
    sample_data = {
        "chip_ids": {
            "iso_11784": "982000123456789",
            "avid": "041123456789", 
            "homeagain": "982000987654321",
            "petlink": "982000555666777"
        },
        "test_scenarios": [
            {
                "name": "valid_iso_chip",
                "chip_id": "982000123456789",
                "expected_result": "Valid ISO 11784/11785 format"
            },
            {
                "name": "valid_avid_chip", 
                "chip_id": "041123456789",
                "expected_result": "Valid AVID format"
            }
        ]
    }
    
    sample_file = SCREENSHOTS_DIR / "sample_data.json"
    sample_file.write_text(json.dumps(sample_data, indent=2))
    print(f"✅ Created sample data: {sample_file}")

def main():
    """Generate manual screenshot generation resources."""
    print("🎯 Chip Companion - Manual Screenshot Generation Setup")
    print("=" * 60)
    
    # Create directories
    create_screenshot_directories()
    
    # Generate instructions
    generate_instructions()
    
    # Create validation script
    create_validation_script()
    
    # Create sample data
    create_sample_data()
    
    print("\n✅ Setup completed!")
    print(f"📁 Screenshots directory: {SCREENSHOTS_DIR}")
    print(f"📖 Instructions: {SCREENSHOTS_DIR}/SCREENSHOT_INSTRUCTIONS.md")
    print(f"🔍 Validation script: {SCREENSHOTS_DIR}/validate_screenshots.py")
    
    print("\n🚀 Next steps:")
    print("1. Start Flutter web server: flutter run -d web-server --web-port 8080")
    print("2. Open browser to http://localhost:8080")
    print("3. Follow instructions in SCREENSHOT_INSTRUCTIONS.md")
    print("4. Validate screenshots with validate_screenshots.py")

if __name__ == "__main__":
    main()
