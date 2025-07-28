# 🚀 Setup Guide MentorMe

## 📋 Prerequisites

### System Requirements

**Minimum Requirements:**

- **OS**: Windows 10/11, macOS 10.14+, atau Linux (Ubuntu 18.04+)
- **RAM**: 8GB (16GB recommended)
- **Storage**: 10GB free space
- **Internet**: Stable internet connection

**Development Tools:**

- **Flutter SDK**: 3.5.2 atau lebih baru
- **Dart SDK**: 3.2.0 atau lebih baru
- **Android Studio**: 2022.3.1 atau lebih baru
- **VS Code**: 1.80.0+ (optional tapi recommended)
- **Git**: 2.30.0 atau lebih baru

### Mobile Development Requirements

**Android Development:**

- **Android SDK**: API Level 21 (Android 5.0) minimum
- **Target SDK**: API Level 34 (Android 14)
- **Java**: JDK 11 atau lebih baru
- **Android Emulator** atau **Physical Device**

**iOS Development (macOS only):**

- **Xcode**: 14.0 atau lebih baru
- **iOS Deployment Target**: 12.0 minimum
- **CocoaPods**: 1.11.0 atau lebih baru
- **iOS Simulator** atau **Physical Device**

---

## 🔧 Installation Steps

### 1. Flutter SDK Installation

#### Windows

```bash
# Download Flutter SDK
# Extract ke C:\flutter
# Tambahkan ke PATH environment variable
C:\flutter\bin

# Verify installation
flutter doctor
```

#### macOS

```bash
# Using Homebrew
brew install flutter

# Or manual installation
# Download Flutter SDK
# Extract ke ~/flutter
# Tambahkan ke PATH di ~/.zshrc atau ~/.bash_profile
export PATH="$PATH:~/flutter/bin"

# Verify installation
flutter doctor
```

#### Linux

```bash
# Download Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.5.2-stable.tar.xz

# Extract
tar xf flutter_linux_3.5.2-stable.tar.xz

# Tambahkan ke PATH di ~/.bashrc
export PATH="$PATH:`pwd`/flutter/bin"

# Reload bash
source ~/.bashrc

# Verify installation
flutter doctor
```

### 2. Android Studio Setup

1. **Download dan Install Android Studio**

   - Download dari [developer.android.com](https://developer.android.com/studio)
   - Install dengan default settings

2. **Install Android SDK**

   ```bash
   # Buka Android Studio
   # Tools > SDK Manager
   # Install Android SDK Platform 34
   # Install Android SDK Build-Tools 34.0.0
   # Install Android Emulator
   ```

3. **Install Flutter Plugin**
   ```bash
   # Android Studio > Preferences/Settings
   # Plugins > Marketplace
   # Search "Flutter" > Install
   # Restart Android Studio
   ```

### 3. VS Code Setup (Optional)

```bash
# Install VS Code extensions
code --install-extension Dart-Code.flutter
code --install-extension Dart-Code.dart-code
code --install-extension ms-vscode.vscode-json
code --install-extension bradlc.vscode-tailwindcss
```

### 4. Firebase Setup

1. **Create Firebase Project**

   - Go to [Firebase Console](https://console.firebase.google.com)
   - Create new project: "MentorMe"
   - Enable Google Analytics (optional)

2. **Enable Firebase Services**

   ```bash
   # Authentication
   # - Email/Password
   # - Google Sign-In (optional)

   # Firestore Database
   # - Start in test mode
   # - Set security rules

   # Cloud Storage
   # - Default bucket
   # - Security rules

   # Cloud Messaging
   # - Enable FCM
   ```

3. **Download Configuration Files**

   ```bash
   # Android: google-services.json
   # Place in: android/app/google-services.json

   # iOS: GoogleService-Info.plist
   # Place in: ios/Runner/GoogleService-Info.plist
   ```

---

## 📱 Project Setup

### 1. Clone Repository

```bash
# Clone project
git clone https://github.com/your-repo/mentorme-flutter.git
cd mentorme-flutter

# Check Flutter version
flutter --version
```

### 2. Install Dependencies

```bash
# Get Flutter packages
flutter pub get

# For iOS (macOS only)
cd ios
pod install
cd ..
```

### 3. Firebase Configuration

#### Install Firebase CLI

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for Flutter
flutterfire configure
```

#### Manual Configuration (Alternative)

**Android Configuration:**

```gradle
// android/build.gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}

// android/app/build.gradle
apply plugin: 'com.google.gms.google-services'

android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
        multiDexEnabled true
    }
}

dependencies {
    implementation 'com.google.firebase:firebase-bom:32.7.0'
    implementation 'com.android.support:multidex:1.0.3'
}
```

**iOS Configuration:**

```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

### 4. Environment Configuration

#### Create Environment Files

```bash
# lib/core/config/env.dart
class Environment {
  static const String apiBaseUrl = 'https://widgets22-catb7yz54a-et.a.run.app/api';
  static const String appName = 'MentorMe';
  static const String appVersion = '1.0.0';

  // Firebase Config
  static const String firebaseProjectId = 'mentorme-aaa37';
  static const String firebaseStorageBucket = 'mentorme-aaa37.firebasestorage.app';

  // API Keys (jangan commit ke git)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String oneSignalAppId = 'YOUR_ONESIGNAL_APP_ID';
}
```

#### Update .gitignore

```bash
# Add to .gitignore
lib/core/config/env.dart
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
.env
*.env
```

---

## 🔐 Security Setup

### 1. API Security

```dart
// lib/core/api/api_config.dart
class ApiConfig {
  static const String baseUrl = Environment.apiBaseUrl;
  static const Duration timeout = Duration(seconds: 30);

  static Map<String, String> getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
      'X-API-Version': '1.0',
      'X-Client-Platform': 'flutter',
    };
  }
}
```

### 2. Local Storage Security

```dart
// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );

  static Future<void> setToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
```

---

## 🧪 Testing Setup

### 1. Unit Testing

```bash
# Create test files
mkdir -p test/unit/services
mkdir -p test/unit/models
mkdir -p test/unit/providers

# Run unit tests
flutter test test/unit/
```

### 2. Widget Testing

```bash
# Create widget test files
mkdir -p test/widget/pages
mkdir -p test/widget/components

# Run widget tests
flutter test test/widget/
```

### 3. Integration Testing

```bash
# Create integration test files
mkdir -p integration_test

# Run integration tests
flutter test integration_test/
```

### 4. Test Configuration

```yaml
# test/test_config.yaml
test_timeout: 30s
coverage_threshold: 80
mock_api_responses: true
test_database: sqlite_memory
```

---

## 🚀 Build & Deployment

### 1. Development Build

```bash
# Debug build
flutter run --debug

# Profile build (for performance testing)
flutter run --profile

# Release build (for testing)
flutter run --release
```

### 2. Android Build

```bash
# Generate keystore (production only)
keytool -genkey -v -keystore ~/mentorme-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias mentorme

# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Install on device
flutter install --release
```

### 3. iOS Build

```bash
# Build iOS (macOS only)
flutter build ios --release

# Build IPA for distribution
flutter build ipa --release

# Open in Xcode for further configuration
open ios/Runner.xcworkspace
```

---

## 📊 Performance Optimization

### 1. Build Optimization

```yaml
# android/app/build.gradle
android {
buildTypes {
release {
shrinkResources true
minifyEnabled true
proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
}
}
}
```

### 2. Asset Optimization

```bash
# Optimize images
flutter packages pub run flutter_launcher_icons:main

# Optimize app size
flutter build apk --split-per-abi
```

### 3. Code Optimization

```dart
// Use const constructors
const MyWidget({Key? key}) : super(key: key);

// Lazy loading
late final MyExpensiveObject _object = MyExpensiveObject();

// Efficient list building
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

---

## 🔧 Development Tools

### 1. Debugging Tools

```bash
# Flutter Inspector
flutter inspector

# Performance overlay
flutter run --enable-software-rendering

# Debug console
flutter logs
```

### 2. Code Quality Tools

```bash
# Linting
flutter analyze

# Code formatting
dart format .

# Import sorting
flutter packages pub run import_sorter:main
```

### 3. Useful VS Code Extensions

```json
{
  "recommendations": [
    "Dart-Code.flutter",
    "Dart-Code.dart-code",
    "alexisvt.flutter-snippets",
    "Nash.awesome-flutter-snippets",
    "robert-brunhage.flutter-riverpod-snippets"
  ]
}
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. Flutter Doctor Issues

```bash
# Android license issues
flutter doctor --android-licenses

# iOS development setup
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

#### 2. Build Issues

```bash
# Clean build
flutter clean
flutter pub get

# Reset iOS pods
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
```

#### 3. Firebase Issues

```bash
# Regenerate Firebase config
flutterfire configure

# Check Firebase project settings
firebase projects:list
```

#### 4. Dependency Issues

```bash
# Update dependencies
flutter pub upgrade

# Check for conflicts
flutter pub deps
```

### Performance Issues

#### 1. Memory Leaks

```dart
// Proper disposal
@override
void dispose() {
  _controller.dispose();
  _subscription.cancel();
  super.dispose();
}
```

#### 2. Build Performance

```bash
# Enable build cache
flutter config --enable-web
flutter config --enable-linux-desktop
flutter config --enable-macos-desktop
flutter config --enable-windows-desktop
```

---

## 📚 Additional Resources

### Documentation

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Documentation](https://dart.dev/guides)

### Community

- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Reddit r/FlutterDev](https://www.reddit.com/r/FlutterDev/)

### Tools

- [Pub.dev](https://pub.dev/) - Package repository
- [Flutter Gems](https://fluttergems.dev/) - Curated packages
- [Flutter Awesome](https://flutterawesome.com/) - Resources

---

## ✅ Verification Checklist

### Pre-Development

- [ ] Flutter SDK installed and configured
- [ ] IDE setup with Flutter plugins
- [ ] Android/iOS development environment ready
- [ ] Firebase project created and configured
- [ ] Repository cloned and dependencies installed

### Development Environment

- [ ] App runs successfully in debug mode
- [ ] Hot reload working properly
- [ ] Firebase services connected
- [ ] API endpoints accessible
- [ ] Local storage working

### Testing Environment

- [ ] Unit tests passing
- [ ] Widget tests configured
- [ ] Integration tests setup
- [ ] Code coverage reports generated
- [ ] Performance profiling enabled

### Production Ready

- [ ] Release builds successful
- [ ] App signing configured
- [ ] Firebase production setup
- [ ] API production endpoints
- [ ] Performance optimized
- [ ] Security measures implemented

---

**Setup guide ini akan membantu developer baru untuk memulai development aplikasi MentorMe dengan konfigurasi yang tepat dan best practices.**
