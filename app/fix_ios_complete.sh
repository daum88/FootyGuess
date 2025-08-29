#!/bin/bash
set -e

echo "🔧 Comprehensive iOS codesigning fix..."

# Step 1: Clean all extended attributes from project
echo "1️⃣ Cleaning project extended attributes..."
find . -exec xattr -c {} \; 2>/dev/null || true

# Step 2: Clean Flutter cache and binaries
echo "2️⃣ Cleaning Flutter cache..."
flutter clean
rm -rf build/
rm -rf ios/build/

# Step 3: Clear extended attributes from Flutter installation (if accessible)
echo "3️⃣ Attempting to clean Flutter installation..."
find /opt/homebrew/share/flutter -name "*.framework" -exec xattr -cr {} \; 2>/dev/null || true
find /opt/homebrew/share/flutter -name "Flutter.framework" -exec xattr -cr {} \; 2>/dev/null || true

# Step 4: Regenerate iOS project files
echo "4️⃣ Regenerating Flutter configuration..."
flutter pub get

# Step 5: Reinstall pods with clean cache
echo "5️⃣ Reinstalling CocoaPods..."
cd ios
rm -rf Pods/
rm -rf .symlinks/
rm -f Podfile.lock
pod install --repo-update
cd ..

echo "✅ iOS setup complete! Now trying to run..."
echo "🚀 Launching iOS app..."

# Step 6: Run with all codesigning disabled
export CODE_SIGNING_REQUIRED=NO
export CODE_SIGNING_ALLOWED=NO
export EXPANDED_CODE_SIGN_IDENTITY=""
export CODE_SIGN_IDENTITY=""

flutter run -d "iPhone 16 Pro" --debug
