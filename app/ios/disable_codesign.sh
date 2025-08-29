#!/bin/bash

# Script to disable codesigning for Flutter simulator builds
# This works around the "resource fork, Finder information, or similar detritus not allowed" error

set -e

echo "🔧 Disabling codesigning for simulator build..."

# Set environment variables to disable codesigning
export CODE_SIGNING_REQUIRED=NO
export CODE_SIGNING_ALLOWED=NO
export EXPANDED_CODE_SIGN_IDENTITY=""
export CODE_SIGN_IDENTITY=""
export PROVISIONING_PROFILE=""
export CODE_SIGN_ENTITLEMENTS=""

# Clear extended attributes from all relevant files
echo "🧹 Clearing extended attributes..."

# Clear from project directory
find . -name "*.framework" -exec xattr -cr {} \; 2>/dev/null || true
find . -name "*.dylib" -exec xattr -cr {} \; 2>/dev/null || true
find . -name "*.a" -exec xattr -cr {} \; 2>/dev/null || true

# Clear from build directory if it exists
if [ -d "build" ]; then
    find build -exec xattr -c {} \; 2>/dev/null || true
fi

# Clear from Pods if it exists
if [ -d "ios/Pods" ]; then
    find ios/Pods -name "*.framework" -exec xattr -cr {} \; 2>/dev/null || true
fi

echo "✅ Codesigning disabled and extended attributes cleared"
echo "Now run: flutter run -d \"iPhone 16 Pro\""
