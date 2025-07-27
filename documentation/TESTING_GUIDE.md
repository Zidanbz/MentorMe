# 🧪 Testing Guide MentorMe

## 📋 Overview

Testing adalah bagian penting dari development cycle aplikasi MentorMe. Guide ini mencakup semua aspek testing mulai dari unit testing, widget testing, integration testing, hingga performance testing.

## 🎯 Testing Strategy

### Testing Pyramid

```
    /\
   /  \
  /    \  E2E Tests (Integration)
 /      \
/________\ Widget Tests
\        /
 \      /  Unit Tests
  \    /
   \  /
    \/
```

**Testing Distribution:**

- **70%** Unit Tests - Fast, isolated, focused
- **20%** Widget Tests - UI components testing
- **10%** Integration Tests - End-to-end scenarios

---

## 🔧 Test Setup

### 1. Dependencies

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.2
  build_runner: ^2.4.7
  test: ^1.24.6
  integration_test:
    sdk: flutter
  patrol: ^2.6.0
  golden_toolkit: ^0.15.0
  network_image_mock: ^2.1.1
```

### 2. Test Directory Structure

```
test/
├── unit/
│   ├── models/
│   ├── services/
│   ├── providers/
│   └── utils/
├── widget/
│   ├── pages/
│   ├── components/
│   └── shared/
├── integration/
│   ├── flows/
│   └── scenarios/
├── mocks/
│   ├── mock_api_client.dart
│   ├── mock_storage.dart
│   └── mock_providers.dart
└── helpers/
    ├── test_helpers.dart
    ├── widget_test_helpers.dart
    └── pump_app.dart
```

### 3. Test Configuration

```dart
// test/helpers/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mentorme/app/constants/app_colors.dart';

class TestHelpers {
  static Widget createTestableWidget({
    required Widget child,
    List<ChangeNotifierProvider>? providers,
  }) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'OpenSans',
      ),
      home: providers != null
          ? MultiProvider(
              providers: providers,
              child: child,
            )
          : child,
    );
  }

  static Future<void> pumpAndSettle(
    WidgetTester tester,
    Widget widget, {
    Duration? duration,
  }) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle(duration);
  }
}
```

---

## 🧪 Unit Testing

### 1. Model Testing

```dart
// test/unit/models/user_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorme/shared/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('should create UserModel from JSON correctly', () {
      // Arrange
      final json = {
        'id': '123',
        'fullName': 'John Doe',
        'email': 'john@example.com',
        'picture': 'https://example.com/image.jpg',
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.id, '123');
      expect(user.fullName, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.picture, 'https://example.com/image.jpg');
    });

    test('should convert UserModel to JSON correctly', () {
      // Arrange
      const user = UserModel(
        id: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        picture: 'https://example.com/image.jpg',
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['id'], '123');
      expect(json['fullName'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['picture'], 'https://example.com/image.jpg');
    });

    test('should handle null values correctly', () {
      // Arrange
      final json = {
        'id': '123',
        'fullName': 'John Doe',
        'email': 'john@example.com',
        'picture': null,
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.picture, null);
    });

    test('should create copy with updated values', () {
      // Arrange
      const originalUser = UserModel(
        id: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
      );

      // Act
      final updatedUser = originalUser.copyWith(
        fullName: 'Jane Doe',
        email: 'jane@example.com',
      );

      // Assert
      expect(updatedUser.id, '123');
      expect(updatedUser.fullName, 'Jane Doe');
      expect(updatedUser.email, 'jane@example.com');
    });
  });
}
```

### 2. Service Testing

```dart
// test/unit/services/auth_api_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mentorme/features/auth/services/auth_api_service.dart';
import 'package:mentorme/core/api/base_api_client.dart';

import 'auth_api_service_test.mocks.dart';

@GenerateMocks([BaseApiClient])
void main() {
  group('AuthApiService Tests', () {
    late MockBaseApiClient mockApiClient;

    setUp(() {
      mockApiClient = MockBaseApiClient();
    });

    test('should login successfully with valid credentials', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const fcmToken = 'fcm_token';

      final expectedResponse = ApiResponse.success(
        data: {
          'token': 'jwt_token',
          'nameUser': 'John Doe',
          'email': email,
        },
        message: 'Login successful',
      );

      when(mockApiClient.post(
        '/auth/login',
        body: anyNamed('body'),
      )).thenAnswer((_) async => expectedResponse);

      // Act
      final result = await AuthApiService.login(
        email: email,
        password: password,
        fcmToken: fcmToken,
      );

      // Assert
      expect(result.success, true);
      expect(result.data['token'], 'jwt_token');
      expect(result.data['nameUser'], 'John Doe');
      verify(mockApiClient.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
          'fcmToken': fcmToken,
        },
      )).called(1);
    });

    test('should handle login failure', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'wrong_password';

      final expectedResponse = ApiResponse.error(
        'Invalid credentials',
        statusCode: 401,
      );

      when(mockApiClient.post(
        '/auth/login',
        body: anyNamed('body'),
      )).thenAnswer((_) async => expectedResponse);

      // Act
      final result = await AuthApiService.login(
        email: email,
        password: password,
      );

      // Assert
      expect(result.success, false);
      expect(result.message, 'Invalid credentials');
      expect(result.statusCode, 401);
    });
  });
}
```

### 3. Provider Testing

```dart
// test/unit/providers/project_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mentorme/providers/project_provider.dart';
import 'package:mentorme/features/project_marketplace/services/project_marketplace_api_service.dart';

import 'project_provider_test.mocks.dart';

@GenerateMocks([ProjectMarketplaceApiService])
void main() {
  group('ProjectProvider Tests', () {
    late ProjectProvider provider;
    late MockProjectMarketplaceApiService mockApiService;

    setUp(() {
      mockApiService = MockProjectMarketplaceApiService();
      provider = ProjectProvider();
    });

    test('should fetch projects successfully', () async {
      // Arrange
      final mockProjects = [
        {
          'id': 1,
          'title': 'Flutter App',
          'description': 'Build a Flutter app',
        },
      ];

      final expectedResponse = ApiResponse.success(
        data: {'projects': mockProjects},
        message: 'Success',
      );

      when(mockApiService.getAllProjects())
          .thenAnswer((_) async => expectedResponse);

      // Act
      await provider.fetchProjects();

      // Assert
      expect(provider.projects.length, 1);
      expect(provider.projects.first['title'], 'Flutter App');
      expect(provider.isLoading, false);
    });

    test('should handle fetch projects error', () async {
      // Arrange
      final expectedResponse = ApiResponse.error('Network error');

      when(mockApiService.getAllProjects())
          .thenAnswer((_) async => expectedResponse);

      // Act
      await provider.fetchProjects();

      // Assert
      expect(provider.projects.isEmpty, true);
      expect(provider.isLoading, false);
      expect(provider.errorMessage, 'Network error');
    });

    test('should set loading state correctly', () async {
      // Arrange
      final expectedResponse = ApiResponse.success(
        data: {'projects': []},
        message: 'Success',
      );

      when(mockApiService.getAllProjects())
          .thenAnswer((_) async => expectedResponse);

      // Act & Assert
      expect(provider.isLoading, false);

      final future = provider.fetchProjects();
      expect(provider.isLoading, true);

      await future;
      expect(provider.isLoading, false);
    });
  });
}
```

---

## 🎨 Widget Testing

### 1. Page Testing

```dart
// test/widget/pages/login_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mentorme/features/auth/login/login_page.dart';
import 'package:mentorme/features/auth/services/auth_api_service.dart';

import '../../helpers/test_helpers.dart';
import '../../mocks/mock_auth_service.mocks.dart';

void main() {
  group('LoginPage Widget Tests', () {
    late MockAuthApiService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthApiService();
    });

    testWidgets('should display login form elements', (tester) async {
      // Arrange & Act
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestableWidget(
          child: const LoginPage(),
        ),
      );

      // Assert
      expect(find.text('Masuk'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should show validation errors for empty fields', (tester) async {
      // Arrange
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestableWidget(
          child: const LoginPage(),
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Field is required'), findsNWidgets(2));
    });

    testWidgets('should show email validation error', (tester) async {
      // Arrange
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestableWidget(
          child: const LoginPage(),
        ),
      );

      // Act
      await tester.enterText(
        find.byType(TextFormField).first,
        'invalid-email',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Invalid email format'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      // Arrange
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestableWidget(
          child: const LoginPage(),
        ),
      );

      final passwordField = find.byType(TextFormField).last;
      final visibilityToggle = find.byIcon(Icons.visibility_off);

      // Act & Assert - Initially obscured
      expect(
        (tester.widget(passwordField) as TextFormField).obscureText,
        true,
      );

      // Act - Toggle visibility
      await tester.tap(visibilityToggle);
      await tester.pumpAndSettle();

      // Assert - Now visible
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(
        (tester.widget(passwordField) as TextFormField).obscureText,
        false,
      );
    });

    testWidgets('should navigate to register page', (tester) async {
      // Arrange
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestableWidget(
          child: const LoginPage(),
        ),
      );

      // Act
      await tester.tap(find.text('Daftar di sini'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(RegisterPage), findsOneWidget);
    });
  });
}
```

### 2. Component Testing

```dart
// test/widget/components/custom_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorme/shared/widgets/custom_button.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('should display button text correctly', (tester) async {
      // Arrange
      const buttonText = 'Test Button';

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestableWidget(
          child: CustomButton(
            text: buttonText,
            onPressed: () {},
          ),
        ),
      );

      // Assert
      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange
      bool wasPressed = false;

      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestableWidget(
          child: CustomButton(
            text: 'Test Button',
            onPressed: () => wasPressed = true,
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      // Assert
      expect(wasPressed, true);
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      // Arrange
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestableWidget(
          child: CustomButton(
            text: 'Test Button',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      // Arrange
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestableWidget(
          child: const CustomButton(
            text: 'Disabled Button',
            onPressed: null,
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      // Assert
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, null);
    });
  });
}
```

### 3. Golden Testing

```dart
// test/widget/golden/login_page_golden_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mentorme/features/auth/login/login_page.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('LoginPage Golden Tests', () {
    testGoldens('should match golden file', (tester) async {
      // Arrange
      await loadAppFonts();

      final widget = TestHelpers.createTestableWidget(
        child: const LoginPage(),
      );

      // Act
      await tester.pumpWidgetBuilder(
        widget,
        surfaceSize: const Size(375, 812), // iPhone X size
      );

      // Assert
      await screenMatchesGolden(tester, 'login_page');
    });

    testGoldens('should match golden file with validation errors', (tester) async {
      // Arrange
      await loadAppFonts();

      final widget = TestHelpers.createTestableWidget(
        child: const LoginPage(),
      );

      await tester.pumpWidgetBuilder(
        widget,
        surfaceSize: const Size(375, 812),
      );

      // Act - Trigger validation
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      await screenMatchesGolden(tester, 'login_page_with_errors');
    });
  });
}
```

---

## 🔄 Integration Testing

### 1. Authentication Flow

```dart
// integration_test/auth_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mentorme/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Tests', () {
    testWidgets('complete login flow', (tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act & Assert - Login page should be displayed
      expect(find.text('Masuk'), findsOneWidget);

      // Act - Enter credentials
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );

      // Act - Tap login button
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Should navigate to main screen
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Beranda'), findsOneWidget);
    });

    testWidgets('complete registration flow', (tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      // Act - Navigate to register
      await tester.tap(find.text('Daftar di sini'));
      await tester.pumpAndSettle();

      // Assert - Register page displayed
      expect(find.text('Daftar'), findsOneWidget);

      // Act - Fill registration form
      await tester.enterText(
        find.byKey(const Key('fullName')),
        'John Doe',
      );
      await tester.enterText(
        find.byKey(const Key('email')),
        'john@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password')),
        'password123',
      );
      await tester.enterText(
        find.byKey(const Key('confirmPassword')),
        'password123',
      );

      // Act - Accept terms and register
      await tester.tap(find.byType(Checkbox));
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Assert - Should show success or navigate to login
      expect(
        find.textContaining('berhasil').or(find.text('Masuk')),
        findsOneWidget,
      );
    });
  });
}
```

### 2. Learning Flow

```dart
// integration_test/learning_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mentorme/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Learning Flow Tests', () {
    testWidgets('browse and enroll in course', (tester) async {
      // Arrange - Login first
      app.main();
      await tester.pumpAndSettle();
      await _performLogin(tester);

      // Act - Navigate to learning tab
      await tester.tap(find.text('Kegiatan'));
      await tester.pumpAndSettle();

      // Assert - Learning page displayed
      expect(find.text('Pelajaranku'), findsOneWidget);

      // Act - Browse available courses
      if (find.text('Mulai Belajar').evaluate().isNotEmpty) {
        await tester.tap(find.text('Mulai Belajar'));
        await tester.pumpAndSettle();

        // Act - Select a course
        await tester.tap(find.byType(Card).first);
        await tester.pumpAndSettle();

        // Assert - Course detail displayed
        expect(find.text('Enroll'), findsOneWidget);

        // Act - Enroll in course
        await tester.tap(find.text('Enroll'));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Assert - Should show enrollment success
        expect(
          find.textContaining('enrolled').or(find.text('Mulai Belajar')),
          findsOneWidget,
        );
      }
    });
  });

  Future<void> _performLogin(WidgetTester tester) async {
    await tester.enterText(
      find.byType(TextFormField).first,
      'test@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).last,
      'password123',
    );
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }
}
```

---

## 📊 Performance Testing

### 1. Widget Performance

```dart
// test/performance/widget_performance_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorme/features/home/beranda_page.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Widget Performance Tests', () {
    testWidgets('BerandaPage should render within performance budget', (tester) async {
      // Arrange
      final stopwatch = Stopwatch()..start();

      // Act
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestableWidget(
          child: BerandaPage(
            categories: [],
            learningPaths: [],
            onTabChange: (_) {},
          ),
        ),
      );

      stopwatch.stop();

      // Assert - Should render within 100ms
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });

    testWidgets('should handle large lists efficiently', (tester) async {
      // Arrange
      final largeList = List.generate(1000, (index) => {
        'id': index,
        'title': 'Item $index',
        'description': 'Description for item $index',
      });

      final stopwatch = Stopwatch()..start();

      // Act
      await TestHelpers.pumpAndSettle(
        tester,
        TestHelpers.createTestableWidget(
          child: ListView.builder(
            itemCount: largeList.length,
            itemBuilder: (context, index) {
              final item = largeList[index];
              return ListTile(
                title: Text(item['title']!),
                subtitle: Text(item['description']!),
              );
            },
          ),
        ),
      );

      stopwatch.stop();

      // Assert - Should handle large lists efficiently
      expect(stopwatch.elapsedMilliseconds, lessThan(200));
    });
  });
}
```

### 2. Memory Testing

```dart
// test/performance/memory_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorme/shared/widgets/optimized_image.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('Memory Performance Tests', () {
    testWidgets('should dispose resources properly', (tester) async {
      // Arrange
      final widget = TestHelpers.createTestableWidget(
        child: const OptimizedImage(
          imageUrl: 'https://example.com/image.jpg',
          width: 100,
          height: 100,
        ),
      );

      // Act - Pump widget
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Act - Remove widget
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      // Assert - No memory leaks (this would be caught by Flutter's leak detection)
      expect(tester.binding.transientCallbackCount, 0);
    });
  });
}
```

---

## 🔧 Test Utilities

### 1. Mock Generators

```dart
// test/mocks/mock_generators.dart
import 'package:mockito/annotations.dart';
import 'package:mentorme/core/api/base_api_client.dart';
import 'package:mentorme/features/auth/services/auth_api_service.dart';
import 'package:mentorme/core/storage/storage_service.dart';

@GenerateMocks([
  BaseApiClient,
  AuthApiService,
  StorageService,
])
void main() {}

// Run: flutter packages pub run build_runner build
```

### 2. Test Data Factories

```dart
// test/helpers/test_data_factory.dart
import 'package:mentorme/shared/models/user_model.dart';

class TestDataFactory {
  static UserModel createUser({
    String? id,
    String? fullName,
    String? email,
    String? picture,
  }) {
    return UserModel(
      id: id ?? '123',
      fullName: fullName ?? 'John Doe',
      email: email ?? 'john@example.com',
      picture: picture ?? 'https://example.com/avatar.jpg',
    );
  }

  static Map<String, dynamic> createProject({
    int? id,
    String? title,
    String? description,
  }) {
    return {
      'id': id ?? 1,
      'title': title ?? 'Flutter App Development',
      'description': description ?? 'Learn to build Flutter apps',
      'difficulty': 'Beginner',
      'rating': 4.5,
      'price': 100,
    };
  }

  static List<Map<String, dynamic>> createProjects(int count) {
    return List.generate(count, (index) => createProject(
      id: index + 1,
      title: 'Project ${index + 1}',
    ));
  }
}
```

### 3. Custom Matchers

```dart
// test/helpers/custom_matchers.dart
import 'package:flutter_test/flutter_test.dart';

Matcher hasValidEmail() => predicate<String>(
  (email) => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email),
  'has valid email format',
);

Matcher isWithinRange(num min, num max) => predicate<num>(
  (value) => value >= min && value <= max,
  'is within range $min-$max',
);

Matcher hasLength(int expectedLength) => predicate<Iterable>(
  (iterable) => iterable.length == expectedLength,
  'has length $expectedLength',
);
```

---

## 🚀 Running Tests

### 1. Command Line

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/models/user_model_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Run tests in specific directory
flutter test test/unit/

# Run tests with specific name pattern
flutter test --name "login"

# Run tests in verbose mode
flutter test --verbose
```

### 2. VS Code Integration

```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Run Tests",
      "type": "dart",
      "request": "launch",
      "program": "test/",
      "args": ["--coverage"]
    },
    {
      "name": "Run Integration Tests",
      "type": "dart",
      "request": "launch",
      "program": "integration_test/",
      "flutterMode": "debug"
    }
  ]
}
```

### 3. CI/CD Integration

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.5.2"

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

---

## 📊 Test Coverage

### 1. Coverage Reports

```bash
# Generate coverage report
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open coverage report
open coverage/html/index.html
```

### 2. Coverage Analysis

```dart
// test/coverage_helper.dart
// Import all files to be included in coverage
import 'package:mentorme/main.dart';
import 'package:mentorme/features/auth/login/login_page.dart';
import 'package:mentorme/features/auth/register/register_page.dart';
import 'package:mentorme/features/home/beranda_page.dart';
import 'package:mentorme/features/profile/profile_page.dart';
import 'package:mentorme/shared/models/user_model.dart';
import 'package:mentorme/core/api/base_api_client.dart';
// ... import all other files

void main() {}
```

### 3. Coverage Configuration

```yaml
# coverage_config.yaml
coverage:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/firebase_options.dart"
    - "lib/l10n/**"
  include:
    - "lib/**"
  threshold:
    line: 80
    function: 80
    branch: 70
```

---

## 🔍 Test Best Practices

### 1. Test Organization

```dart
// Good test structure
void main() {
  group('UserModel', () {
    group('fromJson', () {
      test('should create user from valid JSON', () {
        // Test implementation
      });

      test('should handle missing fields gracefully', () {
        // Test implementation
      });
    });

    group('toJson', () {
      test('should convert user to JSON correctly', () {
        // Test implementation
      });
    });
  });
}
```

### 2. Test Naming

```dart
// Good naming conventions
test('should return user when login with valid credentials', () {});
test('should throw exception when login with invalid credentials', () {});
test('should show loading indicator when submitting form', () {});

// Bad naming
test('login test', () {});
test('test user creation', () {});
test('check validation', () {});
```

### 3. AAA Pattern

```dart
test('should calculate total price correctly', () {
  // Arrange
  final cart = ShoppingCart();
  cart.addItem(Item('Book', 10.0));
  cart.addItem(Item('Pen', 2.0));

  // Act
  final total = cart.calculateTotal();

  // Assert
  expect(total, 12.0);
});
```

### 4. Test Data Management

```dart
// Use factories for consistent test data
class TestDataFactory {
  static UserModel createUser({
    String? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? 'test-id',
      fullName: name ?? 'Test User',
      email: email ?? 'test@example.com',
    );
  }
}

// Use in tests
test('should update user profile', () {
  final user = TestDataFactory.createUser(name: 'John Doe');
  // Test implementation
});
```

---

## 🚨 Common Testing Pitfalls

### 1. Avoid Testing Implementation Details

```dart
// Bad - Testing implementation
test('should call setState when button pressed', () {
  // Don't test internal state management
});

// Good - Testing behavior
test('should show success message when form submitted', () {
  // Test user-visible behavior
});
```

### 2. Avoid Brittle Tests

```dart
// Bad - Brittle test
testWidgets('should have specific widget tree', (tester) async {
  await tester.pumpWidget(MyWidget());

  expect(find.byType(Column), findsOneWidget);
  expect(find.byType(Row), findsNWidgets(3));
  expect(find.byType(Container), findsNWidgets(5));
});

// Good - Test behavior
testWidgets('should display user information', (tester) async {
  await tester.pumpWidget(MyWidget());

  expect(find.text('John Doe'), findsOneWidget);
  expect(find.text('john@example.com'), findsOneWidget);
});
```

### 3. Proper Async Testing

```dart
// Bad - Not waiting for async operations
test('should fetch user data', () async {
  final service = UserService();
  service.fetchUser(); // Missing await

  expect(service.user, isNotNull); // Will fail
});

// Good - Proper async handling
test('should fetch user data', () async {
  final service = UserService();
  await service.fetchUser();

  expect(service.user, isNotNull);
});
```

---

## 🔧 Advanced Testing Techniques

### 1. Custom Test Matchers

```dart
// Custom matcher for API responses
Matcher isSuccessfulApiResponse() => predicate<ApiResponse>(
  (response) => response.success && response.data != null,
  'is successful API response',
);

// Usage
test('should return successful response', () async {
  final response = await apiService.login('email', 'password');
  expect(response, isSuccessfulApiResponse());
});
```

### 2. Test Fixtures

```dart
// test/fixtures/user_fixture.json
{
  "id": "123",
  "fullName": "John Doe",
  "email": "john@example.com",
  "picture": "https://example.com/avatar.jpg"
}

// Loading fixtures in tests
String loadFixture(String name) {
  return File('test/fixtures/$name').readAsStringSync();
}

test('should parse user from JSON fixture', () {
  final jsonString = loadFixture('user_fixture.json');
  final json = jsonDecode(jsonString);
  final user = UserModel.fromJson(json);

  expect(user.fullName, 'John Doe');
});
```

### 3. Parameterized Tests

```dart
// Testing multiple scenarios
void main() {
  group('Email Validation', () {
    final testCases = [
      {'email': 'valid@example.com', 'expected': true},
      {'email': 'invalid-email', 'expected': false},
      {'email': '', 'expected': false},
      {'email': 'test@', 'expected': false},
    ];

    for (final testCase in testCases) {
      test('should validate ${testCase['email']}', () {
        final result = EmailValidator.isValid(testCase['email'] as String);
        expect(result, testCase['expected']);
      });
    }
  });
}
```

---

## 📱 Device-Specific Testing

### 1. Screen Size Testing

```dart
testWidgets('should adapt to different screen sizes', (tester) async {
  // Test on small screen
  tester.binding.window.physicalSizeTestValue = const Size(320, 568);
  tester.binding.window.devicePixelRatioTestValue = 2.0;

  await tester.pumpWidget(MyResponsiveWidget());
  expect(find.text('Mobile Layout'), findsOneWidget);

  // Test on large screen
  tester.binding.window.physicalSizeTestValue = const Size(768, 1024);
  await tester.pumpWidget(MyResponsiveWidget());
  expect(find.text('Tablet Layout'), findsOneWidget);

  // Reset
  addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);
});
```

### 2. Platform-Specific Testing

```dart
testWidgets('should show platform-specific UI', (tester) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

  await tester.pumpWidget(MyPlatformWidget());
  expect(find.byType(CupertinoButton), findsOneWidget);

  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  await tester.pumpWidget(MyPlatformWidget());
  expect(find.byType(ElevatedButton), findsOneWidget);

  debugDefaultTargetPlatformOverride = null;
});
```

---

## 🎯 Test Automation

### 1. Pre-commit Hooks

```bash
# .git/hooks/pre-commit
#!/bin/sh
echo "Running tests before commit..."

# Run tests
flutter test

if [ $? -ne 0 ]; then
  echo "Tests failed. Commit aborted."
  exit 1
fi

echo "All tests passed. Proceeding with commit."
```

### 2. GitHub Actions Workflow

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.5.2"
          channel: "stable"

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze code
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
          fail_ci_if_error: true

      - name: Run integration tests
        uses: reactivecircus/android-emulator-runner@v2
        with:
          api-level: 29
          script: flutter test integration_test/
```

### 3. Test Reports

```dart
// test/test_reporter.dart
import 'dart:io';
import 'package:test/test.dart';

void main() {
  setUp(() {
    // Setup for each test
  });

  tearDown(() {
    // Cleanup after each test
  });

  setUpAll(() {
    // One-time setup
    print('Starting test suite...');
  });

  tearDownAll(() {
    // One-time cleanup
    print('Test suite completed.');
    _generateTestReport();
  });
}

void _generateTestReport() {
  final report = {
    'timestamp': DateTime.now().toIso8601String(),
    'total_tests': 0, // Would be populated by test runner
    'passed': 0,
    'failed': 0,
    'coverage': '85%',
  };

  File('test_report.json').writeAsStringSync(
    jsonEncode(report),
  );
}
```

---

## 📚 Testing Resources

### Documentation

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Tools

- [Flutter Test Utils](https://pub.dev/packages/flutter_test)
- [Golden Toolkit](https://pub.dev/packages/golden_toolkit)
- [Patrol Testing](https://pub.dev/packages/patrol)

### Best Practices

- Test early and often
- Keep tests simple and focused
- Use descriptive test names
- Mock external dependencies
- Test edge cases and error scenarios

---

**Testing guide ini memberikan foundation yang solid untuk memastikan kualitas aplikasi MentorMe melalui comprehensive testing strategy.**
