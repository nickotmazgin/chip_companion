# Chip Companion - Quick Start After Hardening

## 🎯 You are here: Pre-release hardening complete!

All security and compliance changes are done. Here's what to do next:

---

## 1️⃣ Review Changes (2 minutes)

```bash
# See what changed
git status

# Review specific files
git diff android/app/src/main/AndroidManifest.xml
git diff ios/Runner/Info.plist
```

**Key changes:**
- ✅ Android BLE permissions properly flagged
- ✅ iOS permission descriptions privacy-focused
- ✅ Network security hardened
- ✅ Repository secured
- ✅ CI/CD and automation added

---

## 2️⃣ Test Locally (5 minutes)

```bash
# Run preflight checks
bash tools/preflight.sh
```

This will:
- Analyze code
- Run tests
- Build release AAB
- Verify permissions
- Check security

**Expected:** All green checkmarks ✓

---

## 3️⃣ Commit Changes (3 minutes)

### Option A: Single commit (easiest)
```bash
git add .
git commit -m "chore: pre-release hardening for store submission"
git push origin $(git branch --show-current)
```

### Option B: Separate commits (recommended)
See `HARDENING_SUMMARY.md` for individual commit messages.

---

## 4️⃣ Push to Private GitHub (5 minutes)

```bash
# Create private repo on GitHub first, then:
git remote add origin git@github.com:<your-username>/chip_companion.git
git push -u origin main
```

Enable GitHub Actions in repo settings.

---

## 5️⃣ Build for Stores (10 minutes)

```bash
# Clean build
flutter clean && flutter pub get

# Build release AAB
flutter build appbundle --release

# Find your AAB at:
# build/app/outputs/bundle/release/app-release.aab
```

---

## 6️⃣ Submit to Play Store (20 minutes)

1. Upload AAB to Play Console
2. Use permission justifications from `PLAY_CONSOLE_PERMISSIONS.txt`
3. Fill out Data Safety form (NO data collection)
4. Submit for review

**Full guide:** `STORE_SUBMISSION_GUIDE.md`

---

## 7️⃣ Submit to App Store (20 minutes)

1. Build iOS release (on macOS)
2. Upload to App Store Connect
3. Fill out privacy details (NO data collection)
4. Submit for review

**Full guide:** `STORE_SUBMISSION_GUIDE.md`

---

## 📋 Files Created

**Documentation:**
- `STORE_SUBMISSION_GUIDE.md` - Complete submission guide
- `PLAY_CONSOLE_PERMISSIONS.txt` - Copy-paste permission text
- `HARDENING_SUMMARY.md` - What changed and why
- `QUICK_START.md` - This file

**Automation:**
- `.vscode/tasks.json` - VS Code build tasks
- `tools/preflight.sh` - Pre-release verification
- `.github/workflows/flutter-ci.yml` - CI/CD pipeline

**Configuration:**
- `.gitattributes` - Line ending normalization
- Enhanced `.gitignore` - Sensitive file protection

---

## 🚨 Important Reminders

- [ ] Never commit `key.properties` or `*.jks` files
- [ ] Run `bash tools/preflight.sh` before every release
- [ ] Bump version in `pubspec.yaml` before each submission
- [ ] Update `CHANGELOG.md` with changes
- [ ] Test on real devices before submitting

---

## 🆘 Need Help?

**Problem:** Preflight script fails
→ Check the specific failure message; fix and re-run

**Problem:** Can't build AAB
→ Run `flutter clean && flutter pub get` first

**Problem:** Play Console rejects permissions
→ Use exact text from `PLAY_CONSOLE_PERMISSIONS.txt`

**Problem:** Need to rollback
→ See rollback section in `HARDENING_SUMMARY.md`

---

## ✅ Ready to Ship!

You're all set. Your app is:
- ✓ Store compliant
- ✓ Security hardened
- ✓ Privacy aligned
- ✓ CI/CD enabled

**Go crush it! 🚀**
