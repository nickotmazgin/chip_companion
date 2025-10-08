# Changelog

All notable changes to Chip Companion will be documented in this file.

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
