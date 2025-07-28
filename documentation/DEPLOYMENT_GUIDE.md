# 🚀 Deployment Guide MentorMe

## 📋 Overview

Guide ini mencakup semua aspek deployment aplikasi MentorMe mulai dari persiapan build, konfigurasi environment, hingga deployment ke production untuk platform Android dan iOS.

## 🎯 Deployment Strategy

### Environment Stages

```
Development → Staging → Production
     ↓           ↓         ↓
   Debug      Profile   Release
```

**Environment Distribution:**

- **Development**: Local development dengan debug mode
- **Staging**: Testing environment dengan profile mode
- **Production**: Live environment dengan release mode

---

## 🔧 Pre-Deployment Setup

### 1. Environment Configuration

```dart
// lib/core/config/environment.dart
enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  static Environment _environment = Environment.development;

  static Environment get environment => _environment;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.development:
        return 'https://dev-api.mentorme.com/api';
      case Environment.staging:
        return 'https://staging-api.mentorme.com/api';
      case Environment.production:
        return 'https://widgets22-catb7yz54a-et.a.run.app/api';
    }
  }

  static bool get isProduction => _environment == Environment.production;
  static bool get isDevelopment => _environment == Environment.development;
  static bool get isStaging => _environment == Environment.staging;
}
```

### 2. Build Configuration

```yaml
# build_config.yaml
environments:
  development:
    app_name: "MentorMe Dev"
    bundle_id: "com.mentorme.dev"
    firebase_project: "mentorme-dev"

  staging:
    app_name: "MentorMe Staging"
    bundle_id: "com.mentorme.staging"
    firebase_project: "mentorme-staging"

  production:
    app_name: "MentorMe"
    bundle_id: "com.mentorme.app"
    firebase_project: "mentorme-aaa37"
```

### 3. Security Configuration

```dart
// lib/core/config/security_config.dart
class SecurityConfig {
  static const bool enableLogging = !bool.fromEnvironment('dart.vm.product');
  static const bool enableDebugMode = !bool.fromEnvironment('dart.vm.product');

  // API Keys (should be injected via CI/CD)
  static const String googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static const String oneSignalAppId = String.fromEnvironment('ONESIGNAL_APP_ID');

  // Certificate pinning for production
  static List<String> get certificatePins {
    if (EnvironmentConfig.isProduction) {
      return [
        'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
        'sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
      ];
    }
    return [];
  }
}
```

---

## 📱 Android Deployment

### 1. Build Configuration

```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    defaultConfig {
        applicationId "com.mentorme.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }

    signingConfigs {
        debug {
            storeFile file('debug.keystore')
            storePassword 'android'
            keyAlias 'androiddebugkey'
            keyPassword 'android'
        }
        release {
            storeFile file(MENTORME_STORE_FILE)
            storePassword MENTORME_STORE_PASSWORD
            keyAlias MENTORME_KEY_ALIAS
            keyPassword MENTORME_KEY_PASSWORD
        }
    }

    buildTypes {
        debug {
            signingConfig signingConfigs.debug
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            debuggable true
        }

        profile {
            signingConfig signingConfigs.debug
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
        }

        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

    flavorDimensions "environment"
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "MentorMe Dev"
        }

        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "MentorMe Staging"
        }

        prod {
            dimension "environment"
            resValue "string", "app_name", "MentorMe"
        }
    }
}
```

### 2. Keystore Generation

```bash
# Generate release keystore
keytool -genkey -v -keystore ~/mentorme-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias mentorme-release

# Create key.properties file
echo "storePassword=YOUR_STORE_PASSWORD" > android/key.properties
echo "keyPassword=YOUR_KEY_PASSWORD" >> android/key.properties
echo "keyAlias=mentorme-release" >> android/key.properties
echo "storeFile=../mentorme-release-key.jks" >> android/key.properties
```

### 3. ProGuard Configuration

```pro
# android/app/proguard-rules.pro
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# MentorMe specific
-keep class com.mentorme.** { *; }

# Prevent obfuscation of model classes
-keep class * extends java.lang.Enum { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
```

### 4. Build Commands

```bash
# Development build
flutter build apk --flavor dev --debug

# Staging build
flutter build apk --flavor staging --profile

# Production build
flutter build apk --flavor prod --release

# App Bundle for Play Store
flutter build appbundle --flavor prod --release

# Install specific flavor
flutter install --flavor dev
```

---

## 🍎 iOS Deployment

### 1. Xcode Configuration

```xml
<!-- ios/Runner/Info.plist -->
<dict>
    <key>CFBundleDisplayName</key>
    <string>$(APP_DISPLAY_NAME)</string>

    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>

    <key>CFBundleVersion</key>
    <string>$(FLUTTER_BUILD_NUMBER)</string>

    <key>CFBundleShortVersionString</key>
    <string>$(FLUTTER_BUILD_NAME)</string>

    <!-- App Transport Security -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <false/>
        <key>NSExceptionDomains</key>
        <dict>
            <key>widgets22-catb7yz54a-et.a.run.app</key>
            <dict>
                <key>NSExceptionAllowsInsecureHTTPLoads</key>
                <false/>
                <key>NSExceptionMinimumTLSVersion</key>
                <string>TLSv1.2</string>
            </dict>
        </dict>
    </dict>

    <!-- Permissions -->
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to take profile pictures</string>

    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs photo library access to select profile pictures</string>

    <key>NSMicrophoneUsageDescription</key>
    <string>This app needs microphone access for voice messages</string>
</dict>
```

### 2. Build Schemes

```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Build Development"
  lane :dev do
    build_app(
      scheme: "dev",
      configuration: "Debug",
      export_method: "development"
    )
  end

  desc "Build Staging"
  lane :staging do
    build_app(
      scheme: "staging",
      configuration: "Profile",
      export_method: "ad-hoc"
    )
  end

  desc "Build Production"
  lane :production do
    build_app(
      scheme: "Runner",
      configuration: "Release",
      export_method: "app-store"
    )
  end

  desc "Upload to TestFlight"
  lane :beta do
    production
    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )
  end

  desc "Upload to App Store"
  lane :release do
    production
    upload_to_app_store(
      force: true,
      submit_for_review: false
    )
  end
end
```

### 3. Build Commands

```bash
# Development build
flutter build ios --flavor dev --debug

# Staging build
flutter build ios --flavor staging --profile

# Production build
flutter build ios --flavor prod --release

# Build IPA for distribution
flutter build ipa --flavor prod --release

# Using Fastlane
cd ios
fastlane dev
fastlane staging
fastlane production
```

---

## 🔄 CI/CD Pipeline

### 1. GitHub Actions Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  FLUTTER_VERSION: "3.5.2"
  JAVA_VERSION: "11"

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: "zulu"
          java-version: ${{ env.JAVA_VERSION }}

      - name: Install dependencies
        run: flutter pub get

      - name: Decode keystore
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/app/mentorme-release-key.jks

      - name: Create key.properties
        run: |
          echo "storePassword=${{ secrets.STORE_PASSWORD }}" > android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=mentorme-release-key.jks" >> android/key.properties

      - name: Build APK
        run: flutter build apk --flavor prod --release

      - name: Build App Bundle
        run: flutter build appbundle --flavor prod --release

      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: android-builds
          path: |
            build/app/outputs/flutter-apk/app-prod-release.apk
            build/app/outputs/bundle/prodRelease/app-prod-release.aab

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}

      - name: Install dependencies
        run: flutter pub get

      - name: Setup Xcode
        uses: maxim-lobanov/setup-xcode@v1
        with:
          xcode-version: latest-stable

      - name: Install CocoaPods
        run: |
          cd ios
          pod install

      - name: Build iOS
        run: flutter build ios --flavor prod --release --no-codesign

      - name: Build IPA
        run: flutter build ipa --flavor prod --release

      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: ios-builds
          path: build/ios/ipa/*.ipa

  deploy-staging:
    needs: [build-android, build-ios]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    steps:
      - name: Deploy to Firebase App Distribution
        uses: wzieba/Firebase-Distribution-Github-Action@v1
        with:
          appId: ${{ secrets.FIREBASE_APP_ID_ANDROID }}
          token: ${{ secrets.FIREBASE_TOKEN }}
          groups: testers
          file: build/app/outputs/flutter-apk/app-prod-release.apk

  deploy-production:
    needs: [build-android, build-ios]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Deploy to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.mentorme.app
          releaseFiles: build/app/outputs/bundle/prodRelease/app-prod-release.aab
          track: internal

      - name: Deploy to TestFlight
        uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: build/ios/ipa/mentorme.ipa
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPSTORE_API_KEY_ID }}
          api-private-key: ${{ secrets.APPSTORE_API_PRIVATE_KEY }}
```

### 2. Fastlane Configuration

```ruby
# ios/fastlane/Appfile
app_identifier("com.mentorme.app")
apple_id("developer@mentorme.com")
itc_team_id("123456789")
team_id("ABCD123456")

# android/fastlane/Appfile
json_key_file("service-account.json")
package_name("com.mentorme.app")
```

### 3. Environment Variables

```bash
# Required secrets for CI/CD
KEYSTORE_BASE64=<base64_encoded_keystore>
STORE_PASSWORD=<keystore_password>
KEY_PASSWORD=<key_password>
KEY_ALIAS=<key_alias>

GOOGLE_PLAY_SERVICE_ACCOUNT=<service_account_json>
FIREBASE_TOKEN=<firebase_token>
FIREBASE_APP_ID_ANDROID=<firebase_app_id>

APPSTORE_ISSUER_ID=<app_store_issuer_id>
APPSTORE_API_KEY_ID=<api_key_id>
APPSTORE_API_PRIVATE_KEY=<api_private_key>
```

---

## 🌐 Firebase Deployment

### 1. Firebase Configuration

```json
// firebase.json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  },
  "functions": {
    "source": "functions",
    "runtime": "nodejs18"
  },
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "storage": {
    "rules": "storage.rules"
  }
}
```

### 2. Firestore Security Rules

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Public read access for categories and learning paths
    match /categories/{document} {
      allow read: if true;
      allow write: if request.auth != null &&
        request.auth.token.admin == true;
    }

    match /learningPaths/{document} {
      allow read: if true;
      allow write: if request.auth != null &&
        request.auth.token.admin == true;
    }

    // Projects access
    match /projects/{projectId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null &&
        (request.auth.uid == resource.data.authorId ||
         request.auth.token.admin == true);
    }
  }
}
```

### 3. Cloud Storage Rules

```javascript
// storage.rules
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // User profile pictures
    match /profiles/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null &&
        request.auth.uid == userId &&
        request.resource.size < 5 * 1024 * 1024 &&
        request.resource.contentType.matches('image/.*');
    }

    // Project images
    match /projects/{projectId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null &&
        request.resource.size < 10 * 1024 * 1024 &&
        request.resource.contentType.matches('image/.*');
    }
  }
}
```

---

## 📊 Monitoring & Analytics

### 1. Firebase Analytics

```dart
// lib/core/analytics/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    if (EnvironmentConfig.isProduction) {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    }
  }

  static Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  static Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  // Custom events
  static Future<void> logLogin(String method) async {
    await logEvent('login', {'login_method': method});
  }

  static Future<void> logSignUp(String method) async {
    await logEvent('sign_up', {'sign_up_method': method});
  }

  static Future<void> logCourseEnroll(String courseId) async {
    await logEvent('course_enroll', {'course_id': courseId});
  }
}
```

### 2. Crashlytics Integration

```dart
// lib/core/crashlytics/crashlytics_service.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  static Future<void> initialize() async {
    if (EnvironmentConfig.isProduction) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
  }

  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,
  }) async {
    if (EnvironmentConfig.isProduction) {
      await FirebaseCrashlytics.instance.recordError(
        exception,
        stack,
        fatal: fatal,
      );
    }
  }

  static Future<void> log(String message) async {
    if (EnvironmentConfig.isProduction) {
      await FirebaseCrashlytics.instance.log(message);
    }
  }

  static Future<void> setUserId(String userId) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }
}
```

### 3. Performance Monitoring

```dart
// lib/core/performance/performance_service.dart
import 'package:firebase_performance/firebase_performance.dart';

class PerformanceService {
  static Future<void> startTrace(String traceName) async {
    if (EnvironmentConfig.isProduction) {
      final trace = FirebasePerformance.instance.newTrace(traceName);
      await trace.start();
    }
  }

  static Future<void> stopTrace(String traceName) async {
    if (EnvironmentConfig.isProduction) {
      final trace = FirebasePerformance.instance.newTrace(traceName);
      await trace.stop();
    }
  }

  static Future<void> recordHttpMetric({
    required String url,
    required String method,
    required int responseCode,
    required int responseTime,
  }) async {
    if (EnvironmentConfig.isProduction) {
      final metric = FirebasePerformance.instance.newHttpMetric(url, method);
      metric.responseCode = responseCode;
      metric.responsePayloadSize = responseTime;
      await metric.stop();
    }
  }
}
```

---

## 🔐 Security Considerations

### 1. Code Obfuscation

```bash
# Build with obfuscation
flutter build apk --obfuscate --split-debug-info=build/debug-info/

flutter build ios --obfuscate --split-debug-info=build/debug-info/
```

### 2. Certificate Pinning

```dart
// lib/core/network/certificate_pinning.dart
import 'package:dio_certificate_pinning/dio_certificate_pinning.dart';

class CertificatePinningService {
  static Dio createDioWithPinning() {
    final dio = Dio();

    if (EnvironmentConfig.isProduction) {
      dio.interceptors.add(
        CertificatePinningInterceptor(
          allowedSHAFingerprints: SecurityConfig.certificatePins,
        ),
      );
    }

    return dio;
  }
}
```

### 3. API Key Protection

```dart
// lib/core/config/api_keys.dart
class ApiKeys {
  // Never hardcode API keys in production
  static String get googleMapsApiKey {
    const key = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
    if (key.isEmpty && EnvironmentConfig.isProduction) {
      throw Exception('Google Maps API key not configured');
    }
    return key;
  }

  static String get oneSignalAppId {
    const key = String.fromEnvironment('ONESIGNAL_APP_ID');
    if (key.isEmpty && EnvironmentConfig.isProduction) {
      throw Exception('OneSignal App ID not configured');
    }
    return key;
  }
}
```

---

## 📱 App Store Deployment

### 1. Google Play Store

```bash
# Upload to Play Console using Fastlane
cd android
fastlane supply --aab build/app/outputs/bundle/prodRelease/app-prod-release.aab

# Or using Play Console API
curl -X POST \
  "https://androidpublisher.googleapis.com/androidpublisher/v3/applications/com.mentorme.app/edits" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json"
```

### 2. Apple App Store

```bash
# Upload to App Store Connect using Fastlane
cd ios
fastlane deliver --ipa build/ios/ipa/mentorme.ipa

# Or using Xcode
xcodebuild -exportArchive \
  -archivePath build/ios/archive/Runner.xcarchive \
  -exportPath build/ios/ipa \
  -exportOptionsPlist ios/ExportOptions.plist
```

### 3. Store Metadata

```yaml
# fastlane/metadata/android/en-US/
title: "MentorMe - Learning Platform"
short_description: "Learn programming with expert mentors"
full_description: |
  MentorMe is a comprehensive learning platform that connects students with expert mentors.

  Features:
  • Interactive courses and projects
  • One-on-one mentorship sessions
  • Progress tracking and certificates
  • Community support and discussions

keywords: "learning, programming, mentorship, education, courses"

# fastlane/metadata/ios/en-US/
name.txt: "MentorMe"
subtitle.txt: "Learning Platform"
description.txt: |
  MentorMe is your gateway to mastering new skills with expert guidance.

  KEY FEATURES:
  • Personalized Learning Paths
  • Expert Mentor Sessions
  • Interactive Projects
  • Progress Tracking
  • Community Support

keywords.txt: "learning,programming,mentorship,education,courses"
```

---

## 🔄 Rollback Strategy

### 1. Version Management

```dart
// lib/core/version/version_manager.dart
class VersionManager {
  static const String currentVersion = '1.0.0';
  static const int currentBuildNumber = 1;

  static bool isVersionSupported(String version) {
    final current = Version.parse(currentVersion);
    final check = Version.parse(version);

    // Support versions within 2 major versions
    return check.major >= (current.major - 2);
  }

  static bool requiresUpdate(String version) {
    final current = Version.parse(currentVersion);
    final check = Version.parse(version);

    // Force update if more than 3 versions behind
    return check.major < (current.major - 3);
  }
}
```

### 2. Feature Flags

```dart
// lib/core/feature_flags/feature_flags.dart
class FeatureFlags {
  static const Map<String, bool> _flags = {
    'new_ui_enabled': true,
    'payment_v2_enabled': false,
    'chat_feature_enabled': true,
  };

  static bool isEnabled(String flag) {
    return _flags[flag] ?? false;
  }

  static Future<Map<String, bool>> fetchRemoteFlags() async {
    // Fetch from Firebase Remote Config
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    return {
      'new_ui_enabled': remoteConfig.getBool('new_ui_enabled'),
      'payment_v2_enabled': remoteConfig.getBool('payment_v2_enabled'),
      'chat_feature_enabled': remoteConfig.getBool('chat_feature_enabled'),
    };
  }
}
```

### 3. Gradual Rollout

```yaml
# Play Console gradual rollout configuration
rollout_percentage: 10 # Start with 10% of users
staged_rollout:
  - percentage: 10
    duration: 24h
  - percentage: 25
    duration: 48h
  - percentage: 50
    duration: 72h
  - percentage: 100
    duration: 168h
```

---

## 📊 Post-Deployment Monitoring

### 1. Health Checks

```dart
// lib/core/health/health_check.dart
class HealthCheckService {
  static Future<Map<String, dynamic>> performHealthCheck() async {
    final results = <String, dynamic>{};

    // API connectivity
    try {
      final response = await ApiClient.get('/health');
      results['api_status'] = response.success ? 'healthy' : 'unhealthy';
    } catch (e) {
      results['api_status'] = 'error';
      results['api_error'] = e.toString();
    }

    // Firebase connectivity
    try {
      await FirebaseFirestore.instance.doc('health/check').get();
      results['firebase_status'] = 'healthy';
    } catch (e) {
      results['firebase_status'] = 'error';
      results['firebase_error'] = e.toString();
    }

    // Local storage
    try {
      final storage = await SharedPreferencesService.getInstance();
      await storage.setString('health_check', DateTime.now().toIso8601String());
      results['storage_status'] = 'healthy';
    } catch (e) {
      results['storage_status'] = 'error';
      results['storage_error'] = e.toString();
    }

    return results;
  }
}
```

### 2. Error Tracking

```dart
// lib/core/error/error_tracker.dart
class ErrorTracker {
  static Future<void> trackError(
    dynamic error,
    StackTrace? stackTrace, {
    Map<String, dynamic>? context,
  }) async {
    // Log to Crashlytics
    await CrashlyticsService.recordError(error, stackTrace);

    // Log to analytics
    await AnalyticsService.logEvent('error_occurred', {
      'error_type': error.runtimeType.toString(),
      'error_message': error.toString(),
      ...?context,
    });

    // Log locally
    if (EnvironmentConfig.isDevelopment) {
      print('Error: $error');
      print('StackTrace: $stackTrace');
      print('Context: $context');
    }
  }
}
```

### 3. Performance Monitoring

```dart
// lib/core/monitoring/performance_monitor.dart
class PerformanceMonitor {
  static final Map<String, Stopwatch> _timers = {};

  static void startTimer(String name) {
    _timers[name] = Stopwatch()..start();
  }

  static void stopTimer(String name) {
    final timer = _timers[name];
    if (timer != null) {
      timer.stop();

      // Log performance metrics
      AnalyticsService.logEvent('performance_metric', {
        'metric_name': name,
        'duration_ms': timer.elapsedMilliseconds,
      });

      _timers.remove(name);
    }
  }

  static Future<void> measureAsync<T>(
    String name,
    Future<T> Function() operation,
  ) async {
    startTimer(name);
    try {
      return await operation();
    } finally {
      stopTimer(name);
    }
  }
}
```

---

## 🔧 Troubleshooting

### 1. Common Build Issues

```bash
# Clean build cache
flutter clean
flutter pub get

# Reset iOS pods
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..

# Clear Gradle cache (Android)
cd android
./gradlew clean
cd ..

# Reset Flutter
flutter doctor
flutter channel stable
flutter upgrade
```

### 2. Signing Issues

```bash
# Android signing issues
keytool -list -v -keystore ~/mentorme-release-key.jks
keytool -list -v -keystore ~/.android/debug.keystore

# iOS signing issues
security find-identity -v -p codesigning
xcrun security find-identity -v -p codesigning
```

### 3. Firebase Issues

```bash
# Reinstall Firebase CLI
npm uninstall -g firebase-tools
npm install -g firebase-tools

# Re-login to Firebase
firebase logout
firebase login

# Reconfigure Firebase
flutterfire configure
```

---

## 📋 Deployment Checklist

### Pre-Deployment

- [ ] All tests passing
- [ ] Code review completed
- [ ] Version number updated
- [ ] Changelog updated
- [ ] Environment variables configured
- [ ] API keys secured
- [ ] Firebase configuration updated
- [ ] Store metadata prepared

### Android Deployment

- [ ] Keystore configured
- [ ] ProGuard rules updated
- [ ] App Bundle built successfully
- [ ] Play Console access verified
- [ ] Release notes prepared
- [ ] Screenshots updated

### iOS Deployment

- [ ] Certificates and profiles updated
- [ ] App Store Connect access verified
- [ ] TestFlight build uploaded
- [ ] App Store metadata updated
- [ ] Screenshots updated
- [ ] Privacy policy updated

### Post-Deployment

- [ ] Health checks passing
- [ ] Analytics tracking working
- [ ] Crash reporting configured
- [ ] Performance monitoring active
- [ ] User feedback monitoring
- [ ] Rollback plan ready

---

## 📚 Resources

### Documentation

- [Flutter Deployment Guide](https://docs.flutter.dev/deployment)
- [Android App Bundle](https://developer.android.com/guide/app-bundle)
- [iOS App Store Guidelines](https://developer.apple.com/app-store/guidelines/)

### Tools

- [Fastlane](https://fastlane.tools/) - Automation tool
- [Firebase Console](https://console.firebase.google.com/) - Backend services
- [Play Console](https://play.google.com/console/) - Android distribution
- [App Store Connect](https://appstoreconnect.apple.com/) - iOS distribution

### Best Practices

- Use semantic versioning
- Implement gradual rollouts
- Monitor post-deployment metrics
- Maintain rollback capabilities
- Document deployment processes

---

**Deployment guide ini memberikan panduan lengkap untuk men-deploy aplikasi MentorMe ke production dengan aman dan efisien.**
