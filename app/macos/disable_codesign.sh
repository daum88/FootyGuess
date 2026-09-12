#!/bin/bash

echo "🔧 Disabling codesigning for macOS build..."

# Remove extended attributes from the app build directory
echo "🧹 Clearing extended attributes from build..."
xattr -cr build/macos/ 2>/dev/null || true

# Remove any existing app bundles
echo "🗑️ Removing old app bundles..."
rm -rf build/macos/Build/Products/Debug/*.app 2>/dev/null || true
rm -rf build/macos/Build/Products/Release/*.app 2>/dev/null || true
rm -rf build/macos/Build/Products/Profile/*.app 2>/dev/null || true

# Clean derived data
echo "🧹 Cleaning Xcode derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/footyguess-* 2>/dev/null || true

echo "✅ Codesigning disabled for macOS"
echo "Now run: flutter run -d macos"
