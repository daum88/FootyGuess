#!/bin/bash

# Fix codesigning issues for iOS simulator
echo "Fixing codesigning issues..."

# Clear extended attributes from all relevant directories
echo "Clearing extended attributes..."
xattr -cr ios/ 2>/dev/null || true
xattr -cr build/ 2>/dev/null || true
find ~/.pub-cache -name "*.framework" -exec xattr -cr {} \; 2>/dev/null || true

# Clean and reinstall pods
echo "Cleaning and reinstalling pods..."
cd ios
rm -rf Pods Podfile.lock
cd ..
flutter pub get
cd ios
pod install
cd ..

# Clear attributes again after pod install
echo "Clearing attributes from fresh pods..."
xattr -cr ios/Pods/ 2>/dev/null || true

echo "Done! Try running flutter run -d \"iPhone 16 Pro\" now"
