# Chip Companion - Tester Guide

Quick reference for testing BLE, NFC, and manual entry flows.

---

## Test Environment Setup

### What You Need
- **Android:** Physical device with NFC and/or Bluetooth (Android 10+)
- **iOS:** Physical device with NFC and/or Bluetooth (iOS 13+)
- **Optional:** BLE pet microchip scanner (for full BLE testing)
- **Optional:** NFC pet microchip tag (for full NFC testing)

### Without Hardware
You can still test the app using **manual entry mode**:
- Open app → Home screen
- Enter test chip IDs in the text field
- Tap "Validate"

---

## Test Chip IDs

Use these sample IDs to test format validation:

### ✅ Valid IDs

| Format | Test ID | Expected Result |
|--------|---------|----------------|
| **15-digit ISO** | `982000123456789` | ISO 11784/11785, shows registries |
| **10-digit AVID** | `1234567890` | AVID 10-digit, shows AVID registry |
| **9-digit Legacy** | `123456789` | Legacy 9-digit, shows multiple registries |
| **15-char Hex** | `3039F2A456789BC` | ISO-like (Hex), offers decimal conversion |

### ❌ Invalid IDs

| Test Input | Expected Result |
|------------|----------------|
| `12345` | "Invalid format" message |
| `abcdefghij` | "Invalid format" message |
| `982-000-12345` | "Invalid format" (hyphens not supported) |

---

## Test Scenarios

### 1. Manual Entry (No Hardware Required)

**Steps:**
1. Open app
2. Go to Home tab
3. Enter `982000123456789` in text field
4. Tap "Validate"

**Expected:**
- ✅ Shows "ISO 11784/11785" chip type
- ✅ Displays format description
- ✅ Lists suggested registries (AAHA, PetMaxx, HomeAgain, etc.)
- ✅ Can tap registry links → opens browser

---

### 2. NFC Scanning (Requires NFC Tag)

**Steps:**
1. Open app
2. Go to Devices tab
3. Tap "Scan with NFC"
4. Hold NFC tag near phone's NFC antenna

**Expected (Tag Available):**
- ✅ Reads chip ID from tag
- ✅ Auto-navigates to Home tab
- ✅ Shows validation results

**Expected (NFC Disabled):**
- ✅ Shows "NFC not available" message
- ✅ Does NOT crash

**Expected (NFC Permission Denied - iOS):**
- ✅ Shows iOS permission prompt first time
- ✅ If denied, shows clear error message

---

### 3. Bluetooth Scanning (Requires BLE Scanner)

**Steps:**
1. Open app
2. Go to Devices tab
3. Tap "Scan for Bluetooth Devices"

**Expected (BT On, Android 12+):**
- ✅ Prompts for "Nearby devices" permission
- ✅ If granted: Scans for BLE devices
- ✅ If denied: Shows error, does NOT scan

**Expected (BT On, Android 10-11):**
- ✅ Prompts for "Location" permission (required for BLE discovery on older Android)
- ✅ If granted: Scans for BLE devices
- ✅ If denied: Shows error, does NOT scan

**Expected (BT Off):**
- ✅ Shows "Bluetooth not enabled" message
- ✅ Does NOT crash

**Expected (iOS):**
- ✅ Shows Bluetooth permission prompt first time
- ✅ If granted: Scans for BLE devices
- ✅ If denied: Shows error

---

### 4. IAP - Pro Unlock (iOS Only)

**Steps:**
1. Open app
2. Go to Devices tab or any Pro feature
3. Tap "Unlock Pro" button

**Expected:**
- ✅ Shows Pro unlock dialog
- ✅ Displays price (loaded from store)
- ✅ Has "Unlock Pro" button
- ✅ Has "Restore Purchases" button (visible and centered)
- ✅ Tapping "Restore Purchases" triggers restore flow

**Test Restore:**
- If previously purchased: Should unlock Pro
- If not purchased: Should show message

---

### 5. Language Switching

**Steps:**
1. Open app
2. Navigate to Settings (or Support → Settings)
3. Change language

**Expected:**
- ✅ Supports: English, Hebrew, Russian, Spanish, French
- ✅ UI updates immediately
- ✅ All text translates (except registry names/URLs)

---

### 6. Permission Denial Handling

**Android 12+ BLE Test:**
1. Open app → Devices → Scan for Bluetooth
2. **DENY** the "Nearby devices" permission prompt
3. **Expected:** Clear error message, scan does NOT start

**Android 10-11 BLE Test:**
1. Open app → Devices → Scan for Bluetooth
2. **DENY** the "Location" permission prompt
3. **Expected:** Clear error message explaining why location is needed

**iOS NFC Test:**
1. First time tapping NFC scan
2. **DENY** the NFC permission
3. **Expected:** Clear error, does not crash

---

## Expected User Messages

| Scenario | Expected Message |
|----------|-----------------|
| **BT scan denied (Android 12+)** | "Bluetooth permission denied" or similar |
| **BT scan denied (Android ≤11)** | "Location permission denied (required for BLE discovery)" |
| **BT disabled** | "Bluetooth not enabled" |
| **NFC unavailable** | "NFC not available" or "NFC not supported on this device" |
| **NFC disabled** | "NFC not enabled" |
| **Invalid chip ID** | "Input does not match supported chip format rules" |
| **Network unavailable (when tapping link)** | Browser may show "No internet connection" |

---

## Common Issues & Troubleshooting

### "NFC not working"
- ✅ Check Settings → NFC → Enable
- ✅ Remove phone case (may block NFC)
- ✅ Hold tag closer (1-2cm from phone back)

### "Bluetooth scan not finding devices"
- ✅ Check Settings → Bluetooth → Enable
- ✅ Ensure scanner is powered on and in pairing mode
- ✅ Check permission was granted (Settings → Apps → Chip Companion → Permissions)

### "Pro unlock not working"
- ✅ Check internet connection (IAP requires network)
- ✅ Try "Restore Purchases"
- ✅ Check App Store / Play Store account is logged in

### "App crashes on scan"
- ✅ Report crash with steps to reproduce
- ✅ Include Android/iOS version
- ✅ Include device model

---

## Reporting Issues

When reporting bugs, please include:

1. **Device:** Make/model (e.g., "Samsung Galaxy S23", "iPhone 14")
2. **OS:** Version (e.g., "Android 14", "iOS 17.2")
3. **Steps:** Exact steps to reproduce
4. **Expected:** What you expected to happen
5. **Actual:** What actually happened
6. **Screenshots:** If applicable

**Send to:** [Your feedback email/form here]

---

## Testing Checklist

Use this for systematic testing before release:

### Core Functionality
- [ ] Manual chip ID entry works (test all valid formats)
- [ ] Invalid IDs show proper error messages
- [ ] Registry links open in browser
- [ ] Language switching works for all 5 languages

### NFC (if available)
- [ ] NFC scan reads chip ID
- [ ] Permission prompt shows (iOS first time)
- [ ] Denial handled gracefully
- [ ] NFC disabled shows clear message

### Bluetooth (if available)
- [ ] BLE scan requests correct permission (SDK-specific)
- [ ] Permission denial shows clear message
- [ ] BT disabled shows clear message
- [ ] Scanner connection works (if hardware available)

### IAP (iOS)
- [ ] "Restore Purchases" button visible
- [ ] Restore works for existing purchases
- [ ] Purchase flow completes successfully

### Edge Cases
- [ ] App works in airplane mode (offline validation)
- [ ] App works with all permissions denied (manual entry only)
- [ ] App doesn't crash when backgrounded during scan
- [ ] Multiple rapid scans don't cause issues

---

## Performance Expectations

- App launch: < 2 seconds
- Validation: < 100ms (offline, instant)
- BLE scan: 4-10 seconds timeout
- NFC scan: 1-3 seconds after tag tap

---

**Happy Testing! 🧪**

*For developer documentation, see README.md and HARDENING_SUMMARY.md*  
*Last updated: 2025-10-12*

