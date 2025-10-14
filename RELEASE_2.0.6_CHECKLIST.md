# Chip Companion v2.0.6 (Build 8) - Release Checklist

**Release Date:** October 13, 2025  
**Previous Version:** 2.0.5+7 (already on Play Store)  
**New Version:** 2.0.6+8

---

## ✅ Pre-Release Checklist Completed

### 1. Code Quality
- [x] Flutter analyze: 0 errors (10 info suggestions only)
- [x] All tests passing: 55/55
- [x] Zero linter errors
- [x] No TODO/FIXME in production code

### 2. Security & Privacy
- [x] NO `android.permission.INTERNET` in main manifest
- [x] NO `android.permission.ACCESS_NETWORK_STATE` 
- [x] NO analytics/tracking SDKs
- [x] NO HTTP clients or network libraries
- [x] All external links guarded with `canLaunchUrl`
- [x] All links use `LaunchMode.externalApplication`
- [x] Input sanitization implemented
- [x] Security tests passing

### 3. Permissions
- [x] Android: BLE permissions with `neverForLocation` flag
- [x] Android: `ACCESS_FINE_LOCATION` limited to SDK ≤30
- [x] Android: NFC `required="false"`
- [x] iOS: NFCReaderUsageDescription present
- [x] iOS: NSBluetoothAlwaysUsageDescription present
- [x] Runtime permission gating for BLE (Android 12+ bluetoothScan, ≤11 location)

### 4. In-App Purchases
- [x] Restore Purchases button visible and centered
- [x] Debounce guards on purchase buttons
- [x] All IAP calls properly awaited
- [x] Error messages surfaced to user
- [x] iOS: PayPal donate button HIDDEN (uses IAP only)
- [x] Android/Web: PayPal donate visible with clear disclaimers

### 5. Features
- [x] BLE scanning with permission gating
- [x] NFC scanning with status codes
- [x] Microchip validator with comprehensive tests
- [x] Prefix hint widget for ISO chips
- [x] Haptic feedback on copy actions
- [x] Accessibility improvements

### 6. Localization
- [x] All 5 languages complete (EN, ES, FR, HE, RU)
- [x] Version strings updated to 2.0.6
- [x] No duplicate keys
- [x] All translations verified

### 7. Documentation
- [x] CHANGELOG.md updated
- [x] PRIVACY_POLICY.md verified
- [x] LEGAL_DISCLAIMER.md verified
- [x] SECURITY.md verified
- [x] OFFLINE_MODE_POLICY.md updated
- [x] TESTER_GUIDE.md verified
- [x] STORE_LISTING.md created
- [x] PERMISSIONS_REFERENCE.md updated
- [x] README.md badges updated
- [x] In-app links to docs working

### 8. Build
- [x] compileSdk = 36 (plugin compatibility)
- [x] targetSdk = 34
- [x] minSdk = 21
- [x] Namespace: com.nickotmazgin.chipcompanion
- [x] Proguard rules for IAP + BLE
- [x] AAB built successfully

### 9. CI/CD
- [x] GitHub Actions workflow created
- [x] Preflight script created
- [x] INTERNET permission gate in CI

---

## 📦 Build Artifacts

### Release AAB
```
Path: build/app/outputs/bundle/release/app-release.aab
Size: 45.8 MB
SHA256: (generate after final build)
```

### Version Info
```
App Version: 2.0.6
Build Number: 8
Version Code: 8
Version Name: 2.0.6
```

---

## 🎯 Google Play Console Upload Steps

### 1. Navigate to Release
1. Go to Google Play Console
2. Select "Chip Companion"
3. Navigate to: **Release → Testing → Closed testing**

### 2. Create New Release
1. Click "Create new release"
2. Upload AAB: `app-release.aab` (45.8 MB)
3. Release name: **2.0.6 (8) - Security & Compliance Hardening**

### 3. Release Notes
Copy from `CHANGELOG.md` or use:

```
What's New in 2.0.6:

🔒 Security & Compliance
• 100% offline - removed all network permissions
• Enhanced Bluetooth permission handling
• iOS Restore Purchases now prominently displayed

✨ New Features
• Prefix hints for ISO chips (Country/Manufacturer codes)
• Comprehensive microchip validator
• NFC NDEF Text/URI parsing
• Haptic feedback on copy actions

📚 Documentation
• In-app links to Privacy Policy, Legal, and Security docs
• Complete offline mode policy
• Enhanced tester guide

🌍 Languages
Complete support for English, Spanish, French, Hebrew, and Russian

For testers: See TESTER_GUIDE.md for testing scenarios
```

### 4. Rollout
- Start with: **20% rollout**
- Monitor for 24-48 hours
- Increase to 50% → 100% if stable

---

## 🧪 Testing Instructions for Testers

Share with your closed testing group:

```
Hi Testers!

Thanks for helping test Chip Companion v2.0.6!

📱 What to Test:
1. Manual chip ID entry (no hardware needed)
   - Try: 840123456789012 (should validate as ISO)
   - Try: 1234567890 (should validate as AVID)

2. Bluetooth scanning (if you have a BLE scanner)
   - Android 12+: Should ask for "Nearby devices" permission
   - Android ≤11: Should ask for "Location" permission
   - Denial should show friendly error

3. NFC scanning (if available)
   - Should ask for NFC permission (iOS)
   - Should emit clear status messages

4. iOS only: Restore Purchases
   - Go to Settings or any Pro feature
   - Tap "Restore Purchases"
   - Should show appropriate message

5. All platforms: Links
   - Go to Support screen
   - Tap Privacy Policy / Legal / Security links
   - Should open in external browser

📋 Report Issues:
- Device & OS version
- Steps to reproduce  
- Expected vs actual behavior
- Screenshots if helpful

Thank you! 🙏
```

---

## 🔍 Pre-Upload Verification

Run these commands before uploading:

```bash
# Verify no INTERNET permission
grep -i "INTERNET" android/app/src/main/AndroidManifest.xml
# Expected: Only comment "NO INTERNET"

# Check AAB exists
ls -lh build/app/outputs/bundle/release/app-release.aab
# Expected: ~46 MB file

# Verify version
grep "version:" pubspec.yaml
# Expected: version: 2.0.6+8
```

---

## 📸 Screenshots Status

**Existing screenshots from October 12, 2025 are VALID!**

Changed screens (optional updates):
- Support screen (new Legal & Privacy section)
- Validation result (new prefix hint)

Unchanged screens (use existing):
- Home screen ✅
- Devices screen ✅
- Help screen ✅
- Settings screen ✅
- Glossary screen ✅

---

## 🎊 Release Timeline

- **Oct 13, 13:30**: Version bump to 2.0.6+8
- **Oct 13, 13:43**: AAB built successfully
- **Oct 13**: Upload to Closed Testing
- **Oct 14-16**: Monitor tester feedback
- **Oct 17**: Promote to Production (if stable)

---

## ✅ Acceptance Criteria - All Met!

- [x] AAB contains NO `INTERNET` permission
- [x] BLE runtime permission requested before scanning
- [x] Permission denial handled gracefully
- [x] NFC emits visible status on all scenarios
- [x] iOS shows Restore Purchases and it works
- [x] All external links guarded and use external browser
- [x] CI builds artifact successfully
- [x] Preflight script passes locally
- [x] All 55 tests passing
- [x] Zero analyzer errors

---

**Status:** ✅ **READY FOR GOOGLE PLAY UPLOAD**

---

*Generated: October 13, 2025, 13:45 UTC+3*

