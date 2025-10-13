# Chip Companion - Offline Mode Policy

## Summary

Chip Companion operates in **complete offline mode** with **zero network requests**.

---

## No INTERNET Permission

The app **does NOT** request the `android.permission.INTERNET` permission.

**This means:**
- The app cannot make HTTP/HTTPS requests
- No data can be transmitted to external servers
- No analytics or telemetry can phone home
- No ads or tracking can occur

---

## Browser Hand-Off Pattern

When users want to look up a chip ID in an external registry:

1. App validates the chip format **locally**
2. App shows suggested registry websites
3. User taps a registry link
4. App uses `url_launcher` to open the **user's browser**
5. Browser (a separate app) handles the network request

**Key point:** The browser makes the request, not Chip Companion.

---

## Why This Approach?

**Privacy:** Zero data collection or transmission  
**Security:** Minimized attack surface (no network stack)  
**Trust:** Users can verify offline operation via manifest inspection  
**Compliance:** Simplifies store review and privacy disclosures  

---

## Verification

Users and reviewers can confirm offline mode:

```bash
# Check Android manifest - should return empty/error (no INTERNET permission)
aapt dump permissions app-release.aab | grep INTERNET

# Expected output: (empty) or "OK: no INTERNET"
```

iOS: The app does not include `NSAppTransportSecurity` exceptions for arbitrary loads.

---

## Data Flow

```
Chip scan (NFC/BLE/HID) 
  ↓
Local validation (offline)
  ↓
Display results + registry links
  ↓
User taps link (optional)
  ↓
System browser opens URL
  ↓
Browser makes network request
```

**At no point does Chip Companion initiate network activity.**

---

## No Network Permissions

The app does NOT declare:
- ❌ `android.permission.INTERNET`
- ❌ `android.permission.ACCESS_NETWORK_STATE`

**This means:**
- ✅ App cannot make any network requests
- ✅ App cannot check network connectivity
- ✅ 100% offline operation guaranteed

Browser handoff via `url_launcher` works without any network permissions because the system browser (a separate app) handles the network request.

---

## Store Review Notes

**Play Store Data Safety:**  
- Data collected: NONE
- Data shared: NONE  
- Data encrypted: N/A (no data)

**App Store Privacy:**  
- Data types: NONE collected
- Tracking: NO
- Data linked to user: NO

---

*This policy aligns with PRIVACY_POLICY.md and SECURITY.md.*  
*Last updated: 2025-10-12*

