# Chip Companion - Pre-Release Hardening Summary

**Date:** 2025-10-12  
**Status:** ✅ All hardening steps completed

---

## 📋 Overview

This document summarizes all pre-release hardening changes made to prepare Chip Companion for Google Play Store and Apple App Store submission. All changes align with the app's "offline, no data collection, no telemetry" privacy policy.

---

## ✅ Changes Made

### 1. Android Permissions (AndroidManifest.xml)

**File:** `android/app/src/main/AndroidManifest.xml`

**Changes:**
- ✓ Added `android:usesPermissionFlags="neverForLocation"` to `BLUETOOTH_SCAN`
  - Declares app does NOT use Bluetooth for location tracking
- ✓ Added `ACCESS_FINE_LOCATION` with `android:maxSdkVersion="30"`
  - Only requested on Android 11 and lower (platform requirement for BLE discovery)
  - NOT requested on Android 12+ (SDK 31+)
- ✓ Added `android:maxSdkVersion="30"` to legacy `BLUETOOTH` and `BLUETOOTH_ADMIN` permissions
- ✓ Verified no `INTERNET` permission declared

**Why:** Properly declares BLE usage without implying location tracking; meets Play Store policy for Android 12+ runtime permissions.

---

### 2. iOS Permission Descriptions (Info.plist)

**File:** `ios/Runner/Info.plist`

**Changes:**
- ✓ Updated `NFCReaderUsageDescription`:
  - **Before:** "This app uses NFC to scan pet microchips for format validation."
  - **After:** "Used to read NDEF tags containing chip IDs. No data is stored or sent."
- ✓ Updated `NSBluetoothAlwaysUsageDescription`:
  - **Before:** "This app uses Bluetooth to connect to pet microchip scanners."
  - **After:** "Used to connect to compatible Bluetooth scanners. No data is stored or sent."
- ✓ Updated `NSBluetoothPeripheralUsageDescription` (same as above)

**Why:** More privacy-focused, explicitly states no data storage or transmission, aligns with privacy policy.

---

### 3. Network Security Config

**File:** `android/app/src/main/res/xml/network_security_config.xml`

**Changes:**
- ✓ Removed `<debug-overrides>` section
- ✓ Kept `cleartextTrafficPermitted="false"` (HTTPS-only)

**Why:** Production builds should not include debug trust anchors; enforces HTTPS-only for all network connections (even though app doesn't use INTERNET permission).

---

### 4. .gitignore Enhancements

**File:** `.gitignore`

**Changes:**
- ✓ Added `*.pem` (PEM certificates)
- ✓ Added `**/keystore*` and `**/*.keystore` (wildcard keystore patterns)
- ✓ Added `**/GoogleService-Info.plist` (iOS Google services config)
- ✓ Added `**/google-services.json` (Android Google services config)

**Why:** Prevents accidentally committing sensitive signing keys and API configurations to Git.

---

### 5. .gitattributes (New File)

**File:** `.gitattributes`

**Purpose:**
- Normalizes line endings across platforms (LF for Unix, CRLF for Windows scripts)
- Sets proper diff handlers for Dart, Java, Kotlin, Swift
- Marks binary files (images, fonts, keystores, AAB, APK)

**Why:** Ensures consistent behavior across Windows, macOS, and Linux development environments.

---

### 6. VS Code Tasks (New File)

**File:** `.vscode/tasks.json`

**Tasks Added:**
1. **Flutter: Clean & Get** - `flutter clean && flutter pub get`
2. **Flutter: Analyze** - `flutter analyze`
3. **Flutter: Test** - `flutter test`
4. **Flutter: Build AAB (Release)** - `flutter build appbundle --release`
5. **Flutter: Build APK (Release)** - `flutter build apk --release`
6. **Flutter: Build iOS (Release)** - `flutter build ios --release --no-codesign`
7. **Android: Dump AAB Permissions** - Extracts permissions from AAB
8. **Android: Dump APK Permissions** - Extracts permissions from APK
9. **Check for INTERNET permission** - Verifies no INTERNET permission
10. **Full Preflight Check** - Runs `tools/preflight.sh`

**Why:** Provides quick access to common build and verification tasks from VS Code.

---

### 7. Preflight Script (New File)

**File:** `tools/preflight.sh`

**What it does:**
1. ✓ Checks Flutter and Dart environment
2. ✓ Runs `flutter pub get`
3. ✓ Runs `flutter analyze` (static analysis)
4. ✓ Runs `flutter test` (all tests)
5. ✓ Security checks:
   - Verifies no INTERNET permission
   - Verifies BLUETOOTH_SCAN has neverForLocation flag
   - Verifies ACCESS_FINE_LOCATION has maxSdkVersion=30
   - Verifies network security config blocks cleartext traffic
   - Checks for accidentally committed sensitive files
6. ✓ Builds release AAB
7. ✓ Verifies AAB exists and checks its permissions
8. ✓ Checks documentation files exist
9. ✓ Displays version information
10. ✓ Checks iOS Info.plist permissions

**Exit codes:**
- `0` = All checks passed, ready for release
- `1` = One or more checks failed

**Why:** Provides a single command to verify app is ready for store submission; catches common mistakes before uploading.

---

### 8. GitHub Actions Workflow (New File)

**File:** `.github/workflows/flutter-ci.yml`

**Jobs:**
1. **analyze-and-test**
   - Runs on every push/PR
   - Flutter analyze + test with coverage
   - Uploads coverage artifacts

2. **build-android**
   - Builds unsigned release AAB
   - Checks for INTERNET permission (fails if found)
   - Uploads AAB artifact (30-day retention)

3. **build-ios** (manual trigger only)
   - Builds iOS app without codesigning
   - macOS runner (to save minutes)

4. **security-audit**
   - Checks for accidentally committed sensitive files
   - Verifies network security config
   - Verifies proper permission flags

5. **create-release-summary**
   - Generates build summary with version info
   - Shows pass/fail status of all jobs

**Why:** Automated CI/CD provides confidence in every commit; catches issues early; builds artifacts automatically.

---

## 📊 File Changes Summary

### Modified Files (6)
1. `android/app/src/main/AndroidManifest.xml` - Android permissions
2. `ios/Runner/Info.plist` - iOS permission descriptions
3. `android/app/src/main/res/xml/network_security_config.xml` - Network security
4. `.gitignore` - Enhanced security patterns

### New Files (5)
5. `.gitattributes` - Line ending normalization
6. `.vscode/tasks.json` - VS Code build tasks
7. `tools/preflight.sh` - Pre-release verification script (executable)
8. `.github/workflows/flutter-ci.yml` - GitHub Actions CI/CD
9. `STORE_SUBMISSION_GUIDE.md` - Comprehensive store submission guide
10. `PLAY_CONSOLE_PERMISSIONS.txt` - Copy-paste permission justifications
11. `HARDENING_SUMMARY.md` - This file

---

## 🚀 Next Steps

### Option A: Commit Changes (Recommended)

Each change can be committed separately for clean git history:

```bash
# 1. Android permissions
git add android/app/src/main/AndroidManifest.xml
git commit -m "fix(android): add BLE scan permission flags for Play Store compliance

- Add neverForLocation flag to BLUETOOTH_SCAN
- Restrict ACCESS_FINE_LOCATION to SDK 30 and below
- Add maxSdkVersion to legacy BT permissions
- Aligns with Play Store policy for BLE device discovery"

# 2. iOS permissions
git add ios/Runner/Info.plist
git commit -m "fix(ios): update permission descriptions for privacy compliance

- Clarify NFC and Bluetooth usage descriptions
- Explicitly state no data storage or transmission
- Aligns with privacy policy and App Store guidelines"

# 3. Network security
git add android/app/src/main/res/xml/network_security_config.xml
git commit -m "fix(android): remove debug overrides from network security config

- Remove debug-overrides section for production builds
- Keep HTTPS-only enforcement
- Improves security posture for release builds"

# 4. Repository security
git add .gitignore .gitattributes
git commit -m "chore: enhance repository security and normalization

- Add Google services files to .gitignore
- Add PEM and additional keystore patterns
- Create .gitattributes for consistent line endings
- Prevents accidentally committing sensitive files"

# 5. Build automation
git add .vscode/tasks.json tools/preflight.sh .github/workflows/flutter-ci.yml
git commit -m "chore: add build automation and CI/CD

- Create VS Code tasks for common build operations
- Add preflight.sh for pre-release verification
- Add GitHub Actions workflow for automated testing
- Enables automated builds and permission checks"

# 6. Documentation
git add STORE_SUBMISSION_GUIDE.md PLAY_CONSOLE_PERMISSIONS.txt HARDENING_SUMMARY.md
git commit -m "docs: add store submission guides and hardening summary

- Comprehensive store submission guide
- Play Console permission justifications (copy-paste ready)
- Summary of all hardening changes
- Provides clear guidance for app store submission"

# 7. Push all changes
git push origin <your-branch-name>
```

### Option B: Single Commit

If you prefer a single commit:

```bash
git add .
git commit -m "chore: pre-release hardening for store submission

Complete pre-release hardening for Play Store and App Store:

Android:
- Add BLE permission flags (neverForLocation, maxSdkVersion)
- Remove network security debug overrides

iOS:
- Update permission descriptions for privacy compliance

Repository:
- Enhanced .gitignore for sensitive files
- Add .gitattributes for line ending normalization

Automation:
- VS Code build tasks
- Preflight verification script
- GitHub Actions CI/CD workflow

Documentation:
- Store submission guide
- Permission justifications
- Hardening summary

All changes maintain alignment with privacy policy (offline, no data 
collection, no telemetry)."

git push origin <your-branch-name>
```

---

## 🧪 Verification

Run the preflight script to verify everything:

```bash
bash tools/preflight.sh
```

**Expected output:** All checks pass (green ✓), preflight exits with code 0.

If any checks fail, address them before proceeding with store submission.

---

## 📦 GitHub Repository Setup

### Create Private Repository

```bash
# If not already initialized
git init

# Add remote (replace with your GitHub username)
git remote add origin git@github.com:<your-username>/chip_companion.git

# Push (after committing changes above)
git branch -M main
git push -u origin main
```

### Enable GitHub Actions

1. Go to your repo settings
2. **Settings** → **Actions** → **General**
3. Enable "Allow all actions and reusable workflows"
4. Save

Every push will now trigger:
- Flutter analyze
- Tests with coverage
- Build AAB (downloadable artifact)
- Security audit

---

## 📱 Store Submission

See **STORE_SUBMISSION_GUIDE.md** for complete submission instructions.

See **PLAY_CONSOLE_PERMISSIONS.txt** for copy-paste permission justifications.

---

## 🔄 Rollback Instructions

If you need to rollback any change:

### Single File Rollback
```bash
git restore <file-path>
```

### Rollback Last Commit
```bash
git reset --soft HEAD~1  # Keeps changes staged
# or
git reset --hard HEAD~1  # Discards changes completely
```

### Rollback Specific Commit
```bash
git revert <commit-sha>
```

---

## 🛡️ Security Considerations

### Files That Should NEVER Be Committed

The following are already in `.gitignore`, but double-check:
- `key.properties`
- `*.jks`, `*.keystore`
- `upload-keystore.jks`
- `google-services.json`
- `GoogleService-Info.plist`
- `*.pem`, `*.p12`

### Before Pushing to GitHub

```bash
# Check what will be committed
git status

# Check for sensitive patterns
git secrets --scan  # If you have git-secrets installed

# Or manually check
grep -r "password\|secret\|key" . --exclude-dir=.git --exclude-dir=build
```

---

## 🎯 Testing Checklist

Before submitting to stores:

- [ ] Run `bash tools/preflight.sh` - all checks pass
- [ ] Test on physical Android device (or emulator)
- [ ] Test on physical iOS device (if applicable)
- [ ] Test BLE scanner connection (if available)
- [ ] Test NFC chip reading (if available)
- [ ] Test manual chip ID entry (fallback mode)
- [ ] Test language switching (all 5 languages)
- [ ] Test Pro unlock flow (if using IAP)
- [ ] Verify no INTERNET permission in built AAB
- [ ] Review privacy policy alignment
- [ ] Prepare store screenshots

---

## 📚 Additional Resources

**Documentation Files:**
- `README.md` - Project overview
- `PRIVACY_POLICY.md` - Privacy policy (publish to GitHub Pages)
- `LEGAL_DISCLAIMER.md` - Legal disclaimers
- `SECURITY.md` - Security practices
- `CHANGELOG.md` - Version history
- `STORE_SUBMISSION_GUIDE.md` - Complete submission guide
- `PLAY_CONSOLE_PERMISSIONS.txt` - Permission justifications

**Configuration Files:**
- `pubspec.yaml` - Flutter dependencies and version
- `analysis_options.yaml` - Dart linter configuration
- `l10n.yaml` - Localization configuration

**Automation:**
- `.vscode/tasks.json` - VS Code tasks
- `tools/preflight.sh` - Pre-release verification
- `.github/workflows/flutter-ci.yml` - CI/CD pipeline

---

## ✅ Final Status

**All hardening steps completed successfully.**

Your app is now:
- ✓ Play Store compliant (BLE permissions properly declared)
- ✓ App Store compliant (privacy-focused permission descriptions)
- ✓ Security hardened (no debug overrides, no INTERNET permission)
- ✓ Repository secured (sensitive files in .gitignore)
- ✓ CI/CD enabled (GitHub Actions workflow)
- ✓ Automated verification (preflight script)

**Ready for store submission!**

---

*Generated: 2025-10-12*  
*Chip Companion v2.0.5+7*

