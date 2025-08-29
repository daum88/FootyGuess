#!/bin/bash

# Script to run Flutter app on iOS simulator with codesigning workarounds

echo "🚀 Starting iOS simulator launch script..."

# Clean build artifacts
echo "🧹 Cleaning build artifacts..."
flutter clean > /dev/null 2>&1

# Remove problematic files
echo "🗑️ Removing problematic cache files..."
rm -rf build/
rm -rf ios/Pods/
rm -rf ios/.symlinks/
rm -rf ~/.pub-cache/hosted/pub.dartlang.org/*/

# Clear extended attributes from Flutter installation
echo "🧽 Clearing extended attributes..."
find /opt/homebrew/share/flutter -type f -exec xattr -c {} \; 2>/dev/null || true

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Install pods with clean install
echo "🍎 Installing CocoaPods dependencies..."
cd ios
pod install --clean-install --verbose
cd ..

# Set environment variables to disable codesigning
export CODE_SIGNING_REQUIRED=NO
export CODE_SIGNING_ALLOWED=NO
export EXPANDED_CODE_SIGN_IDENTITY=""
export EXPANDED_CODE_SIGN_IDENTITY_NAME=""
export FLUTTER_XCODE_CODE_SIGN_STYLE=Manual

echo "📱 Launching app on iOS simulator..."

# Try to run with specific device
flutter run -d "iPhone 16 Pro" --no-pub
