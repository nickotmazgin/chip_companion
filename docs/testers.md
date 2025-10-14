# 🧪 Chip Companion Closed Test – Tester Guide

Thank you for helping test Chip Companion! This guide will help you get started and provide valuable feedback.

## 📱 How to Join the Closed Test

### Step 1: Opt-In to the Test
1. Click the opt-in link: **[Google Play Testing Program](https://play.google.com/apps/testing/com.chipcompanion.app.chip_companion)**
2. Sign in with your Google account
3. Click **"Become a tester"**
4. Wait a few minutes for the system to update

### Step 2: Install the App
1. Visit the Play Store listing: [Chip Companion](https://play.google.com/store/apps/details?id=com.chipcompanion.app.chip_companion)
2. Tap **Install** (or **Update** if you already have it)
3. Open the app and explore!

### Step 3: Join the Tester Community
- **[Tester discussion group](https://groups.google.com/g/chip-companion-testers)** – Q&A, announcements, and sharing tips
- **[Send feedback (form)](https://forms.gle/dxXyizEu975v1xHd8)** – Report bugs, suggest features (supports screenshots/video)

---

## ✅ What to Test

### Quick Testing Checklist

Use this checklist for quick testing sessions:

- [ ] **Validate 15-digit ID** (e.g., `985112345678901`) → Should detect country/manufacturer
- [ ] **Validate 10-digit ID** (e.g., `1234567890`) → Should detect AVID format
- [ ] **Validate 9-digit ID** (e.g., `123456789`) → Should detect Legacy format
- [ ] **NFC scanning** (if available) → Tap "Scan with NFC" from Devices screen
- [ ] **Bluetooth scanner** (if available) → Pair and scan from Devices screen
- [ ] **Language switch** → Go to Settings → Change language → Verify UI updates
- [ ] **Screenshots for bugs** → Use the [feedback form](https://forms.gle/dxXyizEu975v1xHd8) to upload images/videos

### 🎯 Core Functionality (Free Features)

#### Microchip ID Validation
- [ ] Enter a 9-digit ID (e.g., `123456789`) → Should validate as Legacy/AVID format
- [ ] Enter a 10-digit ID (e.g., `1234567890`) → Should validate as AVID format
- [ ] Enter a 15-digit ID starting with 985 (e.g., `985112345678901`) → Should validate as ISO format with country/manufacturer hint
- [ ] Enter a 15-character hex ID (e.g., `3DD7C2E4F5A6B7C`) → Should convert and validate
- [ ] Try invalid IDs (letters, special chars, wrong length) → Should show clear error messages

#### Language Switching
- [ ] Go to **Settings** → Change language
- [ ] Test: English, Spanish (Español), French (Français), Hebrew (עברית), Russian (Русский)
- [ ] Check that all screens update correctly (Home, Devices, Settings, Help, Glossary)
- [ ] Verify version string displays as "Version 2.0.7 (11)" in all languages

#### Registry Directory
- [ ] Go to **Help** → Browse registries
- [ ] Tap on a registry → Verify contact details display
- [ ] Tap **Website** / **Lookup** links → Should open in your browser
- [ ] Tap **Phone** / **Email** links → Should open phone dialer / email app

#### External Links
- [ ] Footer links (Privacy Policy, Legal Disclaimer, Security) → Should open GitHub in browser
- [ ] **Support** screen → Tap "Contact Developer" → Should open email app with pre-filled address

### 💎 Pro Features (In-App Purchase)

#### Purchase Flow
- [ ] Tap **Devices** or **Scan** → Should prompt for Pro unlock
- [ ] Tap **Unlock Pro** → Should show purchase dialog
- [ ] **Complete purchase** (if you want to support development!)
- [ ] **Restore Purchases** button → Should work if you already purchased

#### NFC Scanning (Pro + NFC-enabled device)
- [ ] Go to **Devices** → Tap **Scan with NFC**
- [ ] Hold an NFC-enabled microchip tag near your phone
- [ ] Check that the ID is scanned and auto-filled in the Home screen
- [ ] **Note**: Implanted microchips (134.2 kHz) require dedicated RFID readers; this tests NDEF tags only

#### Bluetooth Scanner Pairing (Pro + HID scanner)
- [ ] Go to **Devices** → Pair a Bluetooth HID microchip scanner
- [ ] Scan a chip with the external scanner
- [ ] Verify the ID appears in the app

---

## 🐛 Troubleshooting

### "App not available in your country"
The closed test may be region-locked. Email the developer to request access for your region.

### "Your device isn't compatible with this version"
- **Current build**: Targets Android 5.0+ (API 21), SDK 35
- **Tablet support**: BLE/NFC/Location features are optional; tablets without these can still install
- If you see this error, please share your device model and Android version in feedback

### "Restore Purchases" doesn't work
- Ensure you're signed in with the same Google account used for the original purchase
- Wait a few seconds; it may take time to verify
- If it still fails, file a bug report with your device model and Android version

### White screen / App won't load
- Clear app data: **Settings → Apps → Chip Companion → Storage → Clear data**
- Reinstall the app
- If the issue persists, file a bug report

---

## 💬 How to Give Feedback

### 📝 Testing Feedback Form (Recommended)
👉 **[Google Form - Send Feedback](https://forms.gle/dxXyizEu975v1xHd8)**

Use the form for:
- Bug reports with screenshots/videos
- Feature suggestions
- Testing experience feedback
- Any questions or comments

**Benefits**: Supports file uploads (screenshots, videos), anonymous submissions, easy to fill out

### 💬 Tester Discussion Group
👉 **[Google Group - Chip Companion Testers](https://groups.google.com/g/chip-companion-testers)**

Use the group for:
- Q&A and troubleshooting
- Announcements and updates
- Sharing testing tips
- Connecting with other testers

### 🐛 GitHub Issues (Alternative)

**For Bug Reports:**
👉 [File a Bug Report](https://github.com/nickotmazgin/chip_companion/issues/new?template=bug_report.yml)

**Please include:**
- Device model (e.g., "Samsung Galaxy S23")
- Android version (e.g., "Android 14")
- Steps to reproduce the bug
- Expected result vs. actual result
- Screenshots or screen recordings (if possible)

**For Feature Requests:**
👉 [Request a Feature](https://github.com/nickotmazgin/chip_companion/issues/new?template=feature_request.yml)

---

## 🔒 Privacy & Offline Operation

- **100% Offline**: Chip Companion does **not** have the `INTERNET` permission. All validation and processing happens on your device.
- **No Analytics**: No tracking, no data collection, no third-party SDKs.
- **External Links Only**: Links to registries, privacy policies, and support open in your browser via secure hand-off.

Read more: [Privacy Policy](https://github.com/nickotmazgin/chip_companion/blob/main/PRIVACY_POLICY.md) | [Security](https://github.com/nickotmazgin/chip_companion/blob/main/SECURITY.md)

---

## ❤️ Thank You!

Your feedback helps make Chip Companion better for pet owners worldwide. Every bug report, feature request, and piece of feedback is valuable.

**Questions?** Email `NickOtmazgin.Dev@gmail.com` or ask in [Discussions](https://github.com/nickotmazgin/chip_companion/discussions).

---

_Developed by Nick Otmazgin • [GitHub](https://github.com/nickotmazgin/chip_companion) • [Support the Project](https://www.paypal.com/paypalme/nickotmazgin)_

