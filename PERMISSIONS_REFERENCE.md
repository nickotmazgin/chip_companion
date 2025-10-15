# Permissions Reference

- **BLUETOOTH_SCAN** (Android 12+): required for BLE scanning with external scanners.
- **ACCESS_FINE_LOCATION** (maxSdk=30): needed by Android ≤11 for BLE discovery; location hardware is marked **optional** in manifest to keep tablets eligible.
- **NFC** (optional): used for NDEF tag reads on supported phones.

**No INTERNET permission.** External links open in the browser.
