#!/bin/bash
set -e

echo "🧹 Starting clean iOS build process..."

# Navigate to project directory
cd /Users/mattiasdaum/Desktop/FootyGuess/app

echo "📱 Cleaning Flutter build cache..."
flutter clean

echo "🗑️ Removing all build directories..."
rm -rf build/
rm -rf ios/build/
rm -rf ios/.symlinks/
rm -rf ios/Pods/
rm -rf ios/Podfile.lock

echo "🧽 Clearing extended attributes from entire project..."
find . -exec xattr -c {} \; 2>/dev/null || true

echo "📦 Getting Flutter dependencies..."
flutter pub get

echo "🍎 Installing CocoaPods..."
cd ios
pod install --repo-update

echo "🔧 Clearing extended attributes after pod install..."
find . -exec xattr -c {} \; 2>/dev/null || true
cd ..
find . -exec xattr -c {} \; 2>/dev/null || true

echo "🚀 Starting iOS build..."
export CODE_SIGNING_REQUIRED=NO
export CODE_SIGN_IDENTITY=""
export DEVELOPMENT_TEAM=""
export PROVISIONING_PROFILE_SPECIFIER=""

# Try to build and if it fails due to extended attributes, clean and retry
flutter run -d "iPhone 16 Pro" --no-codesign || {
    echo "⚠️ Build failed, cleaning extended attributes and retrying..."
    find . -exec xattr -c {} \; 2>/dev/null || true
    flutter run -d "iPhone 16 Pro" --no-codesign
}
