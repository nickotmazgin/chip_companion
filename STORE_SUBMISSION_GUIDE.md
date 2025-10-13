# Chip Companion - Store Submission Guide

## Overview

This guide covers everything you need to submit Chip Companion to the Google Play Store and Apple App Store after the pre-release hardening changes.

---

## ✅ Completed Hardening Steps

All pre-release hardening has been completed:

1. **Android Permissions** - Updated with proper BLE flags:
   - `BLUETOOTH_SCAN` now includes `android:usesPermissionFlags="neverForLocation"`
   - `ACCESS_FINE_LOCATION` restricted to `android:maxSdkVersion="30"` (Android 11 and lower only)
   - No `INTERNET` permission declared
   
2. **iOS Permissions** - Updated with privacy-focused descriptions:
   - NFC: "Used to read NDEF tags containing chip IDs. No data is stored or sent."
   - Bluetooth: "Used to connect to compatible Bluetooth scanners. No data is stored or sent."

3. **Network Security** - Hardened for release:
   - Cleartext traffic blocked
   - Debug overrides removed
   - HTTPS-only for all network connections

4. **Repository Security**:
   - `.gitignore` enhanced with keystore, Google services files, and PEM patterns
   - `.gitattributes` created for consistent line endings
   - `.github/workflows/flutter-ci.yml` for automated CI/CD

5. **Build Automation**:
   - `.vscode/tasks.json` with build, test, and analysis tasks
   - `tools/preflight.sh` for comprehensive pre-release verification

---

## 🚀 Pre-Submission Checklist

### 1. Run Preflight Checks

```bash
bash tools/preflight.sh
```

This script will:
- ✓ Verify Flutter environment
- ✓ Run static analysis (`flutter analyze`)
- ✓ Run all tests
- ✓ Check for INTERNET permission (must not be present)
- ✓ Verify BLE permissions have proper flags
- ✓ Build release AAB
- ✓ Verify documentation exists
- ✓ Check for accidentally committed sensitive files

**All checks must pass before submission.**

### 2. Build Release AAB

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

Your signed AAB will be at:
```
build/app/outputs/bundle/release/app-release.aab
```

### 3. Verify Permissions

Check the built AAB doesn't contain INTERNET permission:

```bash
# Using aapt (if available)
aapt dump permissions build/app/outputs/bundle/release/app-release.aab

# Or using bundletool
bundletool dump manifest --bundle=build/app/outputs/bundle/release/app-release.aab | grep permission
```

**Critical:** Ensure `android.permission.INTERNET` is **NOT** in the output.

---

## 📱 Google Play Console Submission

### Permissions Justification

When Play Console asks about permissions, use these justifications:

#### **BLUETOOTH_CONNECT**
```
Used to establish connections with external Bluetooth Low Energy (BLE) pet microchip scanners. 
This allows the app to receive scanned chip data from compatible scanning hardware. 
All processing is done locally on the device; no data is transmitted to external servers.
```

#### **BLUETOOTH_SCAN** (with `neverForLocation` flag)
```
Used to discover nearby Bluetooth Low Energy (BLE) pet microchip scanners for pairing. 
The neverForLocation flag is set because this app does NOT use Bluetooth for location purposes.
Scanning is used solely to identify compatible scanner devices for chip validation.
On Android 11 and lower (SDK ≤30), ACCESS_FINE_LOCATION is required by the Android platform 
for BLE discovery, but it is not used for location tracking or position determination.
All scanned data is processed locally; no data is stored or transmitted.
```

#### **ACCESS_FINE_LOCATION** (maxSdkVersion="30")
```
This permission is ONLY requested on Android 11 and lower (SDK ≤30) as a platform requirement 
for Bluetooth Low Energy device discovery. On Android 12+ (SDK 31+), this permission is NOT 
requested at all.

This app does NOT use this permission for location tracking, geolocation, or any location-based 
features. The sole purpose is to enable BLE scanner discovery on older Android versions.

All microchip validation is performed offline and locally. No location data is collected, 
stored, or transmitted.
```

#### **NFC**
```
Used to read Near Field Communication (NFC) tags containing pet microchip identifiers. 
The app validates chip format and displays registry information. 
All processing is done locally; no data is transmitted to external servers.
```

#### **ACCESS_NETWORK_STATE**
```
Used to check network availability before allowing optional external lookups via 
URL launcher (opens external browser). The app does NOT make direct network requests; 
all network access is through the user's browser via url_launcher.
This permission helps provide a better user experience by detecting if a network 
connection is available before attempting to open a registry lookup URL.
```

### Data Safety Section

Use these declarations in the Play Console Data Safety form:

**Does your app collect or share user data?**
- **NO** - This app does NOT collect, store, or share any user data.

**Data types:**
- Location: **NOT COLLECTED**
- Personal info: **NOT COLLECTED**
- Financial info: **NOT COLLECTED**
- Health and fitness: **NOT COLLECTED**
- Messages: **NOT COLLECTED**
- Photos and videos: **NOT COLLECTED**
- Audio files: **NOT COLLECTED**
- Files and docs: **NOT COLLECTED**
- Calendar: **NOT COLLECTED**
- Contacts: **NOT COLLECTED**
- App activity: **NOT COLLECTED**
- Web browsing: **NOT COLLECTED**
- App info and performance: **NOT COLLECTED**
- Device or other IDs: **NOT COLLECTED**

**Security practices:**
- Data is encrypted in transit: **N/A** (no data transmission)
- Users can request data deletion: **N/A** (no data collected)
- Data collection is optional: **N/A** (no data collected)

**Privacy Policy URL:**
```
https://github.com/<your-username>/<your-public-docs-repo>/blob/main/PRIVACY_POLICY.md
```

---

## 🍎 Apple App Store Submission

### App Review Information

**Notes for Review:**
```
Chip Companion is a professional pet microchip format validator that works with 
external Bluetooth and NFC scanners.

BLUETOOTH PERMISSION:
The app uses Bluetooth to connect to external BLE pet microchip scanners. 
No location tracking is performed. All data processing is done locally on the device.

NFC PERMISSION:
The app uses NFC to read NDEF tags containing chip IDs for format validation.

PRIVACY:
This app does NOT collect, store, or transmit any user data. All microchip validation 
is performed offline and locally. The app may open external registry websites via Safari 
for optional chip lookups initiated by the user.

No analytics, tracking, or telemetry is included.

Testing:
The app can be tested without physical scanning hardware by manually entering 
test chip IDs on the home screen:
- 15-digit ISO: 982000123456789
- 10-digit AVID: 1234567890
- 9-digit legacy: 123456789
```

### App Privacy Details

**Does your app collect data?**
- **NO**

**Third-party analytics:**
- **NONE**

**Advertising:**
- **NONE**

**Data types:**
- Location: **NOT COLLECTED**
- Contacts: **NOT COLLECTED**
- Identifiers: **NOT COLLECTED**
- Usage Data: **NOT COLLECTED**
- Diagnostics: **NOT COLLECTED**

---

## 🔐 Private GitHub Repository Setup

To push your code to a private GitHub repository:

```bash
# Initialize git (if not already done)
git init

# Add all files (sensitive files are already in .gitignore)
git add .

# Create initial commit
git commit -m "chore: import app sources with pre-release hardening"

# Add your private GitHub repo as remote
git remote add origin git@github.com:<your-username>/chip_companion.git

# Push to main branch
git branch -M main
git push -u origin main
```

### Enable GitHub Actions

1. Go to your repo → **Settings** → **Actions** → **General**
2. Enable "Allow all actions and reusable workflows"
3. Save

Now, every push will trigger the CI workflow:
- ✓ Flutter analyze
- ✓ Run tests
- ✓ Build AAB
- ✓ Security audit
- ✓ Upload AAB artifact (downloadable for 30 days)

---

## 📋 Version Bump Guide

Before each release:

1. Update `pubspec.yaml`:
   ```yaml
   version: 2.0.6+8  # Increment both version name and build number
   ```

2. Update `CHANGELOG.md` with changes

3. Commit:
   ```bash
   git add pubspec.yaml CHANGELOG.md
   git commit -m "chore: bump version to 2.0.6+8"
   git tag v2.0.6
   git push origin main --tags
   ```

4. Run preflight:
   ```bash
   bash tools/preflight.sh
   ```

5. Build and submit

---

## 🛡️ Security Best Practices

### Never Commit These Files

Already in `.gitignore`:
- `key.properties`
- `*.jks`, `*.keystore`
- `upload-keystore.jks`
- `google-services.json`
- `GoogleService-Info.plist`
- `*.pem`, `*.p12`

### Signing Keys Storage

Keep your signing keys **outside** the repository:
```bash
# Store in a secure location like:
~/secure/chip-companion/
  ├── upload-keystore.jks
  ├── key.properties
  └── README.txt (with passwords in a password manager)
```

Reference them in your build with:
```bash
cp ~/secure/chip-companion/key.properties android/
cp ~/secure/chip-companion/upload-keystore.jks android/app/
flutter build appbundle --release
rm android/key.properties android/app/upload-keystore.jks
```

---

## 🎯 Quick Commands Reference

### VS Code Tasks
Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS) → "Tasks: Run Task":
- **Flutter: Clean & Get** - Clean and fetch dependencies
- **Flutter: Analyze** - Run static analysis
- **Flutter: Test** - Run all tests
- **Flutter: Build AAB (Release)** - Build release bundle
- **Android: Dump AAB Permissions** - Check AAB permissions
- **Check for INTERNET permission** - Verify no INTERNET permission
- **Full Preflight Check** - Run complete pre-release checks

### Terminal Commands
```bash
# Clean build
flutter clean && flutter pub get

# Analyze
flutter analyze

# Test
flutter test

# Build AAB
flutter build appbundle --release

# Preflight
bash tools/preflight.sh

# Check git status
git status

# View permissions
aapt dump permissions build/app/outputs/bundle/release/app-release.aab
```

---

## 📞 Support & Resources

**Documentation:**
- `PRIVACY_POLICY.md` - Privacy policy (publish to GitHub Pages)
- `LEGAL_DISCLAIMER.md` - Legal disclaimers
- `SECURITY.md` - Security practices
- `CHANGELOG.md` - Version history

**Tools:**
- `.github/workflows/flutter-ci.yml` - CI/CD pipeline
- `tools/preflight.sh` - Pre-release checks
- `.vscode/tasks.json` - VS Code tasks

---

## ✨ Final Steps Before Submission

1. ✅ Run `bash tools/preflight.sh` - **All checks must pass**
2. ✅ Build release AAB: `flutter build appbundle --release`
3. ✅ Verify no INTERNET permission in AAB
4. ✅ Test on physical device(s)
5. ✅ Prepare store screenshots
6. ✅ Upload AAB to Play Console
7. ✅ Fill out store listing with permission justifications
8. ✅ Submit for review

---

## 🎉 You're Ready!

Your app is now hardened and ready for store submission. Good luck with your launch!

For questions or issues, refer to:
- Flutter docs: https://docs.flutter.dev
- Play Console Help: https://support.google.com/googleplay/android-developer
- App Store Connect Help: https://developer.apple.com/help/app-store-connect

---

*Last updated: 2025-10-12*

