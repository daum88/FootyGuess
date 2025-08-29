#!/bin/bash

echo "🍎 Quick iOS Fix for App Store Development"
echo "========================================"

# Navigate to app directory
cd /Users/mattiasdaum/Desktop/FootyGuess/app

# 1. Flutter clean
echo "1. Cleaning Flutter project..."
flutter clean

# 2. Clear extended attributes
echo "2. Clearing extended attributes..."
find . -exec xattr -c {} \; 2>/dev/null || true

# 3. Get dependencies
echo "3. Getting Flutter dependencies..."
flutter pub get

# 4. Install CocoaPods
echo "4. Installing CocoaPods..."
cd ios
pod install --repo-update
cd ..

# 5. Try iOS simulator build
echo "5. Building for iOS simulator..."
flutter build ios --simulator --debug

echo "✅ Build complete! If successful, you can now:"
echo "   - Open ios/Runner.xcworkspace in Xcode"
echo "   - Select iPhone simulator"
echo "   - Build and run (Cmd+R)"
echo ""
echo "For App Store deployment:"
echo "   - Change CODE_SIGNING_REQUIRED to YES in ios/Flutter/Release.xcconfig" 
echo "   - Add your Apple Developer Team ID"
echo "   - Configure proper provisioning profiles"
