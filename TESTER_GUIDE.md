# Chip Companion — Closed Test Guide

**Goal:** Validate microchip format checks and scanner integrations (Bluetooth/NFC) on phones & tablets.

## Join & install (1 minute)
- Opt-in: https://play.google.com/apps/testing/com.chipcompanion.app.chip_companion
- Install from Google Play (same Google account)

## Test flow
1) Try **Home → Validate microchip format**
2) If available, test **Devices & Scanners**
   - Bluetooth scanner (HID) → enter ID automatically
   - NFC (if your phone supports it) → tap a tag/card
3) Toggle **Settings → Auto-validate on scan**

## Send feedback (screens/video welcome)
- Form (preferred): https://forms.gle/dxXyizEu975v1xHd8
- Discussion/Q&A: https://groups.google.com/g/chip-companion-testers

## What makes a great bug report
- Device model + Android version
- App version & code (Settings → App information)
- Steps to reproduce
- What happened vs expected
- How often + impact (blocks/major/minor/cosmetic)
- Screenshot/video/logs if possible

## Privacy
Offline-first: no analytics; no INTERNET permission. See **PRIVACY_POLICY.md**.
