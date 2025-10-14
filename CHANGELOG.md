# Changelog

All notable changes to Chip Companion will be documented in this file.

## [2.0.7] - Build 10 - 2025-10-14

### Android 15 + Tablet Eligibility
- **Target API 35 (Android 15)** - Updated to latest Android target
- **Tablet support restored** - NFC/BLE/NFC HCE marked optional to support tablets without these features
- **Dynamic version display** - Version now shown dynamically via package_info_plus
- **Documentation sync** - All MD files updated with correct version and repo links
- **Localization polish** - Version display improvements across all languages
- **Still 100% offline** - No INTERNET permission; browser hand-off only for external lookups

## [2.0.6] - Build 9 - 2025-10-13

### 🔒 Security & Compliance Hardening

#### Permissions & Privacy
- **Removed ACCESS_NETWORK_STATE permission** - Now 100% offline with zero network permissions
- **Enhanced BLE permission handling** - Runtime permission gating with Android 12+ bluetoothScan, Android ≤11 location
- **iOS Restore Purchases** - Prominently displayed and fully functional
- **PayPal donate hidden on iOS** - Using IAP only, compliant with App Store guidelines

#### Security Enhancements
- Added `SecurityService.sanitizeChipId()` with strict whitelist
- Created comprehensive `MicrochipValidator` module with 28 passing tests
- All external links guarded with `canLaunchUrl` + `LaunchMode.externalApplication`
- NFC services emit explicit status codes (success/unavailable/denied/canceled/error)

### ✨ Features & Improvements

#### Validation
- **New Prefix Hint Widget** - Shows "Country code" or "Manufacturer code" for ISO 15-digit chips
- **Comprehensive Validator** - Supports ISO 11784/11785 (FDX-B), AVID 10-digit, legacy 9-digit, hex-15 formats
- **NDEF Text/URI Parsing** - Extract chip IDs from NFC tags containing text or URI records

#### UX Enhancements
- **Haptic Feedback** - Light impact on copy actions for better tactile response
- **Accessibility** - Decorative tree backgrounds excluded from semantics
- **Performance** - Memoized paint objects and gradients for smoother rendering
- **Error Handling** - Better user-facing messages for permission denials

#### Documentation
- **In-App Links** - Privacy Policy, Legal Disclaimer, Security docs accessible from Support screen
- **Store Listing** - Comprehensive STORE_LISTING.md for Play Store submission
- **Tester Guide** - Detailed testing scenarios for BLE, NFC, and IAP
- **Offline Policy** - Clear documentation of 100% offline operation

### 🏗️ Build & CI
- **GitHub Actions CI** - Automated analyze/test/build with AAB artifact upload
- **Preflight Script** - Safety checks with INTERNET permission gate
- **Proguard Rules** - Keep rules for IAP and BLE plugins
- **Gradle Hardening** - Updated namespace, compileSdk=34, targetSdk=34, minSdk=21

### 📦 Data & Assets
- **Sample IDs** - Created `assets/data/sample_ids.json` with test samples for all formats
- **Constants** - Centralized docs links in `lib/constants/docs_links.dart`

### 🧪 Testing
- **55 Tests Passing** - Comprehensive test coverage for validator, security, and lookup services
- **Zero Linter Errors** - Clean codebase ready for production

### 🌍 Localization
- All 5 languages complete: English, Spanish, French, Hebrew, Russian
- Fixed duplicate l10n keys
- All translations verified

---

## [2.0.1] - 2025-10-08

### 🛠 Improvements
- NFC scanning: Added NDEF parsing to extract chip IDs from compatible tags; clarified that phone NFC cannot read implanted 134.2 kHz FDX‑B microchips
- Help & FAQ: Updated “How to Use”, “Tips”, and “Troubleshooting” with correct button text, scanner methods, and NFC limitations
- Glossary: Added in‑app Microchip Glossary (formats, prefixes, hex↔decimal)
- Registry Contacts: Email tap now falls back to copy + “Open Gmail” when no mail app is configured; long‑press to copy for email and phone

### 📄 Docs
- README: NFC limitations and supported tag use cases; clarified smart parsing
- Misc: Minor wording tweaks for accuracy and consistency

---

## [2.0.2] - 2025-10-09

### ✨ New
- Settings: Added “Auto‑validate on scan” toggle (On by default)
- Diagnostics: New screen (Settings → Diagnostics) with buttons to check NFC and Bluetooth availability with clear ✅/❌ results

### 🛠 Improvements
- Home: Auto‑focuses the input field when the page is shown to help HID/USB/BT keyboard‑wedge scanners type directly
- Help & FAQ: Added a small “USB keyboard wedge scanners” tip under Troubleshooting
- NFC: Explicitly documented NDEF tag flow in multiple places (Help Tips and Troubleshooting, Devices screen disclaimer, README, and Store metadata). From Devices, if a tag contains a chip ID in text/URL, we extract it, populate Home, and validate. Implanted FDX‑B chips still require an external 134.2 kHz reader.

### 📄 Docs
- README and App Store metadata updated to clearly call out NFC NDEF tag support and implanted‑chip limitations
- Version bumped in `pubspec.yaml` to 2.0.2+4 for the new release


## [2.0.0] - 2025-09-29

### 🚀 Major Features Added

#### 📱 Devices & Scanning
- **Bluetooth Scanner Support**: Connect to external RFID scanners via Bluetooth HID profile
- **NFC Scanning**: Use phone's built-in NFC reader for modern microchip tags
- **Devices Tab**: New bottom navigation tab for managing scanner connections
- **Real-time Scanning**: Instantly capture and validate scanned chip IDs
- **Device Management**: View connection status and manage paired devices

#### 🔧 Technical Improvements
- **Bottom Navigation**: Converted to tab-based navigation (Home + Devices)
- **Seamless Data Flow**: Scanned data automatically populates validation field
- **Professional UI**: Status indicators and device management interface
- **Error Handling**: Comprehensive error management for scanning operations

#### 🔐 Privacy & Security
- **No Data Storage**: Scanned IDs used for immediate validation only
- **Local Processing**: All scanning data remains on device
- **Secure Permissions**: Minimal required permissions with clear descriptions
- **App Store Compliant**: Meets all platform requirements

#### 🌍 Localization
- **Scanner UI**: Complete localization for all new scanning features
- **Error Messages**: Localized error and warning messages
- **Disclaimers**: Translated legal disclaimers for scanner functionality

### 📋 Dependencies Added
- `flutter_blue_plus: ^1.32.12` - Bluetooth connectivity
- `nfc_manager: ^3.2.0` - NFC tag reading

### 🔧 Platform Updates
- **Android**: Added Bluetooth and NFC permissions
- **iOS**: Added NFC reader and Bluetooth usage descriptions
- **Permissions**: Clear, user-facing permission descriptions

### 📄 Documentation Updates
- **README.md**: Updated with scanning capabilities and new features
- **LEGAL_DISCLAIMER.md**: Added scanner support and data handling disclaimers
- **PRIVACY_POLICY.md**: Added scanned data handling section
- **Version**: Bumped to 2.0.0+1

### 🎯 Target Users
- **Veterinarians**: Professional scanning tool for consultations
- **Shelters**: Scan found pets, validate chip IDs instantly
- **Animal Control**: Field scanning with Bluetooth devices
- **Pet Owners**: Scan with phone or external scanner

---

## [1.0.0] - 2025-09-27

### 🎉 Initial Release
- **Format Validation**: Instantly validate microchip ID formats
- **Registry Directory**: Contact information for pet registries worldwide
- **Multi-Language Support**: English, Spanish, French, Hebrew, Russian
- **Educational Content**: Learn about microchip technology
- **Offline Ready**: Works without internet connection
- **Professional UI**: Beautiful, responsive design
- **App Store Ready**: Fully compliant for international release
