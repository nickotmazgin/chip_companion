# 🐾 Chip Companion

[![Flutter](https://img.shields.io/badge/Flutter-3.35.4+-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9.2+-0175C2?logo=dart)](https://dart.dev/)
[![Version](https://img.shields.io/badge/Version-2.0.6--build.9-blue)](https://github.com/nickotmazgin/chip_companion/releases)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)](https://flutter.dev/)
[![Offline](https://img.shields.io/badge/Mode-100%25%20Offline-success)](OFFLINE_MODE_POLICY.md)

**Professional pet microchip validator with Bluetooth and NFC scanning capabilities.**

Validate microchip IDs, scan with external devices or NFC, understand chip formats, and find the right registries to contact - all in one beautiful, multi-language app.

## 💎 **Pro Features**

- **Free Version**: Full microchip format validation and registry directory
- **Pro Version**: Unlock Bluetooth and NFC scanning capabilities with a one-time purchase
- **No Subscriptions**: One-time purchase for lifetime access to Pro features

## ⚠️ Important Disclaimers

- **Professional Validation Tool** - Provides microchip format validation and comprehensive registry directory
- **Scanner Support** - Compatible with Bluetooth HID scanners and NFC-enabled devices
- **Registry Directory** - Provides contact information; does not access live databases
- **Reference Tool** - For official pet identification, consult veterinarians and contact registries directly

## Trademark Notice

Registry names mentioned are trademarks of their respective owners. This app is not affiliated with any registry organization.

---

## ✨ **Features**

### 🎯 **Core Functionality**

- **Format Validation** - Instantly validate microchip ID formats against international standards (Free)
- **Registry Directory** - Contact information for pet registries worldwide (Free)
- **Chip Type Detection** - Identify ISO, AVID, HomeAgain, and other formats (Free)
- **Enhanced Results** - Detailed chip information with manufacturer hints and next steps (Free)
- **Multi-Language Support** - Available in English, Spanish, French, Hebrew, and Russian (Free)
 - **NFC NDEF Tag Support** - If an NFC tag (collar/card) encodes a chip ID in text/URL, Chip Companion extracts it, fills the Home input, and validates. Implanted chips still require 134.2 kHz readers.

### 💎 **Pro Features** (One-time purchase)

- **Bluetooth Scanning** - Connect to external RFID scanners via Bluetooth HID profile
- **NFC Scanning** - Use phone's built-in NFC reader for modern microchip tags
- **Device Management** - Enhanced paired device information and status
- **Priority Support** - Get help when you need it most

### 🎨 **User Experience**

- **Forest Theme** - Beautiful, calming design perfect for pet care
- **Responsive Design** - Works flawlessly on mobile, tablet, and desktop
- **Instant Results** - Real-time format validation as you type
- **Seamless Scanning** - Automatic data population from scanners
- **Offline Ready** - Works without internet connection

---

## 🚀 **Quick Start**

```bash
# Clone repository
git clone https://github.com/nickotmazgin/chip_companion.git
cd chip_companion

# Install dependencies
flutter pub get

# Run app
flutter run
```

**Requirements:** Flutter 3.35.4+, Dart 3.9.2+

---

## 📱 **Perfect For**

| User Type          | How It Helps                                           |
| ------------------ | ------------------------------------------------------ |
| **Pet Owners**     | Validate chip IDs, scan with phone or external scanner |
| **Veterinarians**  | Professional scanning tool for consultations           |
| **Shelters**       | Scan found pets, validate chip IDs instantly           |
| **Animal Control** | Field scanning with Bluetooth devices                  |
| **Students**       | Learn about microchip technology and scanning          |

---

## What It Actually Does

### ✅ **Free Features**
- Validates microchip ID formats against international standards
- Provides comprehensive chip type identification
- Comprehensive registry directory with contact information
- Supports ISO, AVID, HomeAgain, and legacy formats
- Enhanced chip information with manufacturer hints
- Professional guidance and next steps

### 💎 **Pro Features** (One-time purchase)
- Scans microchips via Bluetooth HID scanners
- Scans NFC-enabled microchips with phone's built-in reader
- Real-time scanning with automatic data population
- Enhanced device management and status

### ❌ **What It Does NOT Do**
- Does NOT access live registry databases
- Does NOT provide official pet identification services
- Does NOT replace veterinary consultation
- Does NOT store or transmit personal data

---

## 📱 **Devices & Scanning**

### 🔵 **Bluetooth Scanners**

- **HID Profile Support** - Works with any Bluetooth scanner that acts as a keyboard
- **Automatic Pairing** - Connect to paired devices in your Bluetooth settings
- **Real-time Scanning** - Instantly capture and validate scanned chip IDs
- **Device Management** - View connection status and manage paired devices

### 📡 **NFC Scanning**

- **Native Reader** - Use your phone's built-in NFC reader (13.56 MHz)
- **Important** - Phone NFC typically cannot read implanted ISO 11784/11785 (FDX‑B 134.2 kHz) pet microchips
- **Works With** - NFC NDEF tags (e.g., collars/cards/stickers) that contain the chip ID in text or a URL. From Devices, tap “Scan with NFC”: if a tag contains an ID, the app extracts it, populates Home, and validates it for you.
	- Implanted FDX‑B chips still require an external 134.2 kHz reader.

### 🔒 **Privacy & Security**

- **No Data Storage** - Scanned IDs are used for immediate validation only
- **No Transmission** - Data never leaves your device
- **Secure Permissions** - Minimal required permissions with clear descriptions
- **App Store Compliant** - Meets all platform requirements

---

## 🌍 **Supported Languages**

- 🇺🇸 English
- 🇪🇸 Español
- 🇫🇷 Français
- 🇮🇱 עברית
- 🇷🇺 Русский

---

## 📚 Documentation

- **[Privacy Policy](PRIVACY_POLICY.md)** - How we handle your data (spoiler: we don't collect any)
- **[Legal Disclaimer](LEGAL_DISCLAIMER.md)** - Terms, trademarks, and limitations
- **[Security Policy](SECURITY.md)** - Security measures and vulnerability reporting
- **[Offline Mode Policy](OFFLINE_MODE_POLICY.md)** - How 100% offline operation works
- **[Tester Guide](TESTER_GUIDE.md)** - Testing scenarios for BLE, NFC, and IAP
- **[Store Listing](STORE_LISTING.md)** - Google Play Store listing details
- **[Permissions Reference](PERMISSIONS_REFERENCE.md)** - Complete permissions breakdown

## License & Compliance

- License: Proprietary (see LICENSE)
- Compliance: See FINAL_COMPLIANCE_REPORT.md

---

## ❤️ Support the Project

If you'd like to support ongoing development, you can leave a tip here:

`https://www.paypal.com/paypalme/nickotmazgin`

## 🚀 Ready for Release

✅ **Fully compliant for international release** - See [FINAL_COMPLIANCE_REPORT.md](FINAL_COMPLIANCE_REPORT.md) for complete verification.

Note on media: Store screenshots are kept locally and uploaded directly to consoles; they are intentionally not committed to this repository to keep history lean.

---

_Helping pet owners navigate microchip systems with confidence._
