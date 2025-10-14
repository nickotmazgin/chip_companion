# Chip Companion - Google Play Store Screenshots

## Quick Start Guide

I've created a comprehensive screenshot generation system for your Google Play Store submission. Here's what you need to do:

### 1. Start Flutter Web Server
```bash
cd /home/nickotmazgin/cursor_review/chip_companion
flutter run -d web-server --web-port 8080
```

### 2. Open Browser
Navigate to: http://localhost:8080

**⚠️ IMPORTANT: Wait 15 seconds for the app to fully load!**

### 3. Follow Detailed Instructions
Read the complete guide: `assets/screenshots/SCREENSHOT_INSTRUCTIONS_WITH_LOADING.md`

## Required Screenshots

### Phone Screenshots (8 required)
- **Portrait**: 1080x1920 pixels (9:16 ratio)
- **Landscape**: 1920x1080 pixels (16:9 ratio)
- **Minimum**: 1080px on each side (for promotion eligibility)

### Tablet Screenshots (5 each)
- **7-inch Portrait**: 1200x1920 pixels
- **7-inch Landscape**: 1920x1200 pixels
- **10-inch Portrait**: 1600x2560 pixels
- **10-inch Landscape**: 2560x1600 pixels

## Screenshot Scenarios

1. **Home Screen** - Main interface with chip ID input
2. **Sample Chip ID** - Home screen with sample chip ID entered
3. **Validation Result** - Chip validation result display
4. **Devices Screen** - Scanner options interface
5. **Bluetooth Scanner** - Bluetooth scanner interface
6. **NFC Scanner** - NFC scanner interface
7. **Help Screen** - Help and FAQ content
8. **Settings Screen** - Settings and preferences

## Browser Setup

### Chrome/Edge Developer Tools:
1. Press F12
2. Click device toggle (📱)
3. Set custom dimensions:
   - Phone Portrait: 1080 x 1920
   - Phone Landscape: 1920 x 1080
   - 7-inch Tablet Portrait: 1200 x 1920
   - 7-inch Tablet Landscape: 1920 x 1200
   - 10-inch Tablet Portrait: 1600 x 2560
   - 10-inch Tablet Landscape: 2560 x 1600

## Sample Data for Testing

Use these chip IDs for consistent screenshots:
- **ISO 11784/11785**: `982000123456789`
- **AVID**: `041123456789`
- **HomeAgain**: `982000987654321`

## Validation

After capturing screenshots, validate them:
```bash
cd assets/screenshots
python3 validate_screenshots.py
```

## File Organization

Save screenshots in:
```
assets/screenshots/
├── phone/
│   ├── portrait/
│   └── landscape/
├── tablet7/
│   ├── portrait/
│   └── landscape/
└── tablet10/
    ├── portrait/
    └── landscape/
```

## Quality Checklist

- [ ] Correct dimensions for device type
- [ ] Clear app interface visibility
- [ ] All key elements included
- [ ] No browser UI visible
- [ ] Good contrast and readability
- [ ] File size under 8MB
- [ ] PNG or JPEG format

Ready to create professional screenshots for your Google Play Store submission! 🚀
