# Chip Companion - Permissions Reference

Quick reference for the implemented permission structure.

---

## 🤖 Android Permissions

### Bluetooth Permissions

```xml
<!-- Legacy BT (SDK ≤30 only) -->
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />

<!-- Modern BT (SDK 31+) -->
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" 
                 android:usesPermissionFlags="neverForLocation" />
```

**Key point:** `neverForLocation` flag tells Play Store this app does **NOT** use BT for location.

### Location Permission (Legacy Android Support)

```xml
<!-- ONLY for BLE discovery on Android ≤11 -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" 
                 android:maxSdkVersion="30" />
```

**Key point:** `maxSdkVersion="30"` means this permission is **NOT** requested on Android 12+.

### NFC Permission

```xml
<uses-permission android:name="android.permission.NFC" />
<uses-feature android:name="android.hardware.nfc" android:required="false" />
```

### Network State (No INTERNET!)

```xml
<!-- NOTE: NO android.permission.INTERNET -->
<!-- NOTE: NO android.permission.ACCESS_NETWORK_STATE -->
```

**Key point:** App is 100% offline. `url_launcher` opens system browser for lookups without any network permission.

---

## 🍎 iOS Permissions

### NFC Usage Description

```xml
<key>NFCReaderUsageDescription</key>
<string>Used to read NDEF tags containing chip IDs. No data is stored or sent.</string>
```

### Bluetooth Usage Description

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Used to connect to compatible Bluetooth scanners. No data is stored or sent.</string>

<key>NSBluetoothPeripheralUsageDescription</key>
<string>Used to connect to compatible Bluetooth scanners. No data is stored or sent.</string>
```

**Key point:** Explicit "No data is stored or sent" aligns with privacy policy.

---

## 📊 Permission Matrix

| Permission | Android ≤11 | Android 12+ | iOS | Purpose |
|------------|-------------|-------------|-----|---------|
| **BLUETOOTH_CONNECT** | ✓ | ✓ | ✓ | Connect to BLE scanners |
| **BLUETOOTH_SCAN** | ✓ | ✓ (neverForLocation) | ✓ | Discover BLE scanners |
| **ACCESS_FINE_LOCATION** | ✓ (max SDK 30) | ✗ | ✗ | BLE discovery (legacy) |
| **NFC** | ✓ | ✓ | ✓ | Read NFC chip tags |
| **INTERNET** | ✗ | ✗ | ✗ | **NOT USED - 100% OFFLINE** |

---

## 🛡️ Privacy Guarantees

✓ **No INTERNET permission** → App cannot make network requests  
✓ **No location tracking** → `neverForLocation` flag + restricted to SDK ≤30  
✓ **No data collection** → Explicitly stated in permission descriptions  
✓ **No analytics/telemetry** → No tracking libraries included  
✓ **Offline processing** → All validation done locally  

---

## 📝 Play Console Justifications (Quick Copy-Paste)

### BLUETOOTH_SCAN
```
Used to discover nearby Bluetooth Low Energy (BLE) pet microchip scanners 
for pairing. The neverForLocation flag is set because this app does NOT use 
Bluetooth for location purposes. On Android 11 and lower, ACCESS_FINE_LOCATION 
is required by the Android platform for BLE discovery, but it is not used for 
location tracking. All scanned data is processed locally.
```

### ACCESS_FINE_LOCATION
```
This permission is ONLY requested on Android 11 and lower (SDK ≤30) as a 
platform requirement for Bluetooth Low Energy device discovery. On Android 12+, 
this permission is NOT requested. This app does NOT use this permission for 
location tracking. All microchip validation is performed offline and locally.
```

---

## 🎯 Runtime Permission Flow

### Android 12+ (SDK 31+)
1. User taps "Connect Scanner"
2. App requests **BLUETOOTH_SCAN** permission
3. System shows: "Allow Chip Companion to find nearby devices?"
4. ✓ No location prompt (because of `neverForLocation` flag)

### Android 11 and lower (SDK ≤30)
1. User taps "Connect Scanner"
2. App requests **ACCESS_FINE_LOCATION** permission
3. System shows: "Allow Chip Companion to access this device's location?"
4. User grants (required by Android OS for BLE discovery)
5. App uses BLE to find scanners (but does NOT access GPS/location)

### iOS
1. First NFC tap: System shows NFC usage description
2. First BLE connect: System shows Bluetooth usage description
3. User taps "Allow"

---

## 🧪 Testing Verification

### Verify no INTERNET permission:
```bash
aapt dump permissions build/app/outputs/bundle/release/app-release.aab | grep INTERNET
# Expected: No output (INTERNET not found)
```

### Verify BLE flags:
```bash
grep "neverForLocation" android/app/src/main/AndroidManifest.xml
# Expected: android:usesPermissionFlags="neverForLocation"
```

### Verify location restriction:
```bash
grep "ACCESS_FINE_LOCATION" android/app/src/main/AndroidManifest.xml
# Expected: android:maxSdkVersion="30"
```

---

## 📚 References

- **Android BLE permissions:** https://developer.android.com/guide/topics/connectivity/bluetooth/permissions
- **Android 12 Bluetooth changes:** https://developer.android.com/about/versions/12/features/bluetooth-permissions
- **Play Console data safety:** https://support.google.com/googleplay/android-developer/answer/10787469
- **iOS privacy manifest:** https://developer.apple.com/documentation/bundleresources/privacy_manifest_files

---

*Last updated: 2025-10-12*
