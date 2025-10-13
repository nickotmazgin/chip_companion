#!/bin/bash
set -e

# Chip Companion Preflight Script
# Runs all safety checks before release

echo "🚀 Chip Companion Preflight Checks"
echo "=================================="
echo ""

# Check Flutter version
echo "📱 Checking Flutter version..."
flutter --version | head -1
echo ""

# Clean and get dependencies
echo "🧹 Cleaning build artifacts..."
flutter clean
echo ""

echo "📦 Getting dependencies..."
flutter pub get
echo ""

# Run analyzer
echo "🔍 Running analyzer..."
flutter analyze
if [ $? -ne 0 ]; then
  echo "❌ Analyzer found issues!"
  exit 1
fi
echo "✅ Analyzer passed"
echo ""

# Run tests
echo "🧪 Running tests..."
flutter test --reporter expanded
if [ $? -ne 0 ]; then
  echo "❌ Tests failed!"
  exit 1
fi
echo "✅ Tests passed"
echo ""

# Build release AAB
echo "🏗️  Building release AAB..."
flutter build appbundle --release
if [ $? -ne 0 ]; then
  echo "❌ Build failed!"
  exit 1
fi
echo "✅ Build succeeded"
echo ""

# Check for INTERNET permission
echo "🔒 Checking for INTERNET permission..."
AAB_PATH="build/app/outputs/bundle/release/app-release.aab"

if [ ! -f "$AAB_PATH" ]; then
  echo "❌ AAB not found at $AAB_PATH"
  exit 1
fi

# Check main manifest
INTERNET_CHECK=$(grep -i 'permission.*INTERNET' android/app/src/main/AndroidManifest.xml || true)
if [ ! -z "$INTERNET_CHECK" ]; then
  echo "❌ INTERNET permission found in main manifest!"
  echo "$INTERNET_CHECK"
  exit 1
fi

echo "✅ No INTERNET permission found in main manifest"
echo ""

# Optional: Use aapt2 if available to check AAB
if command -v aapt2 &> /dev/null; then
  echo "🔍 Checking AAB with aapt2..."
  # Note: This requires extracting the AAB first
  echo "⚠️  Manual AAB inspection recommended with: aapt2 dump permissions $AAB_PATH"
else
  echo "ℹ️  aapt2 not available - skipping AAB permission check"
  echo "   Install Android SDK build-tools for full verification"
fi

echo ""
echo "=================================="
echo "✅ All preflight checks passed!"
echo "=================================="
echo ""
echo "AAB location: $AAB_PATH"
echo "Size: $(du -h $AAB_PATH | cut -f1)"
echo ""
echo "Ready for closed testing!"
