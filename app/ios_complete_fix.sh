#!/bin/bash
set -e

echo "🍎 Starting comprehensive iOS fix for App Store development..."

# Navigate to project directory
cd /Users/mattiasdaum/Desktop/FootyGuess/app

echo "🧹 Step 1: Complete cleanup..."
flutter clean
rm -rf build/ ios/build/ ios/.symlinks/ ios/Pods/ ios/Podfile.lock
find . -exec xattr -c {} \; 2>/dev/null || true

echo "📦 Step 2: Update pubspec.yaml for iOS compatibility..."
# Ensure proper iOS configuration in pubspec.yaml
if ! grep -q "ios:" pubspec.yaml; then
    echo "Adding iOS configuration to pubspec.yaml..."
    cat >> pubspec.yaml << 'EOF'

# iOS specific configuration
flutter:
  uses-material-design: true
  
# Platform specific dependencies
dependency_overrides:
  # Force compatible versions for iOS
EOF
fi

echo "🔧 Step 3: Configure iOS deployment target..."
# Update iOS deployment target in Podfile
cd ios
if [ -f "Podfile" ]; then
    # Backup original Podfile
    cp Podfile Podfile.backup
    
    # Update Podfile with proper iOS deployment target
    cat > Podfile << 'EOF'
# Uncomment this line to define a global platform for your project
platform :ios, '13.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      # Disable codesigning for all pods
      config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      config.build_settings['CODE_SIGN_IDENTITY'] = ''
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ''
      config.build_settings['CODE_SIGN_ENTITLEMENTS'] = ''
      config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
      config.build_settings['DEVELOPMENT_TEAM'] = ''
      
      # iOS 13.0 minimum deployment target
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      
      # Disable bitcode
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      
      # Exclude arm64 for simulator if needed
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
EOF
fi

echo "🎯 Step 4: Update all Xcode configuration files..."
cd ..

# Update Debug.xcconfig
cat > ios/Flutter/Debug.xcconfig << 'EOF'
#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"
#include "Generated.xcconfig"

// Comprehensive codesigning disable
CODE_SIGN_IDENTITY = 
CODE_SIGNING_REQUIRED = NO
CODE_SIGNING_ALLOWED = NO
DEVELOPMENT_TEAM = 
PROVISIONING_PROFILE_SPECIFIER = 
ENABLE_BITCODE = NO
VALIDATE_PRODUCT = NO
SKIP_INSTALL = YES
COPY_PHASE_STRIP = NO

// Additional iOS simulator settings
EXCLUDED_ARCHS[sdk=iphonesimulator*] = arm64
ONLY_ACTIVE_ARCH = YES
EOF

# Update Release.xcconfig
cat > ios/Flutter/Release.xcconfig << 'EOF'
#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
#include "Generated.xcconfig"

// Disable codesigning for release builds too
CODE_SIGN_IDENTITY = 
CODE_SIGNING_REQUIRED = NO
CODE_SIGNING_ALLOWED = NO
DEVELOPMENT_TEAM = 
PROVISIONING_PROFILE_SPECIFIER = 
ENABLE_BITCODE = NO
VALIDATE_PRODUCT = NO
EOF

echo "📱 Step 5: Get dependencies and install pods..."
flutter pub get
cd ios
pod deintegrate 2>/dev/null || true
pod install --repo-update
cd ..

echo "🧽 Step 6: Final cleanup of extended attributes..."
find . -exec xattr -c {} \; 2>/dev/null || true

echo "🚀 Step 7: Attempting iOS build..."
echo "Trying flutter build ios --simulator first..."
if flutter build ios --simulator --debug; then
    echo "✅ iOS simulator build successful!"
    echo "Now attempting to run on simulator..."
    flutter run -d "iPhone 16 Pro" --debug
else
    echo "❌ Build failed. Let's try alternative approach..."
    echo "Opening Xcode workspace for manual build..."
    open ios/Runner.xcworkspace
    echo "Please try building directly from Xcode:"
    echo "1. Select 'Runner' scheme"
    echo "2. Select iPhone 16 Pro Simulator"
    echo "3. Press Cmd+R to build and run"
fi

echo "🎉 iOS fix script completed!"
