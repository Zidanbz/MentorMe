# 🏗️ Arsitektur Aplikasi MentorMe

## 📋 Gambaran Umum

MentorMe menggunakan arsitektur **Feature-First** dengan **Clean Architecture** principles. Setiap fitur memiliki struktur yang konsisten dan terpisah untuk maintainability yang lebih baik.

## 🎯 Design Patterns

### 1. Feature-First Architecture

```
lib/features/
├── auth/                 # Authentication feature
│   ├── login/           # Login sub-feature
│   ├── register/        # Register sub-feature
│   └── services/        # Auth-related services
├── home/                # Home dashboard feature
├── profile/             # User profile feature
├── consultation/        # Mentor consultation feature
├── learning/            # Learning management feature
├── project_marketplace/ # Project marketplace feature
├── payment/             # Payment system feature
├── topup/               # Coin top-up feature
└── notifications/       # Notifications feature
```

### 2. Layered Architecture

#### Presentation Layer

- **Pages**: UI screens dan user interactions
- **Widgets**: Reusable UI components
- **Controllers**: State management dan business logic

#### Domain Layer

- **Models**: Data entities dan business objects
- **Services**: Business logic dan use cases
- **Providers**: State management dengan Provider pattern

#### Data Layer

- **API Services**: External API communications
- **Storage Services**: Local data persistence
- **Network Layer**: HTTP client configurations

## 🔧 Core Components

### 1. API Architecture

```dart
// Base API Client
class BaseApiClient {
  static const String baseUrl = 'https://widgets22-catb7yz54a-et.a.run.app/api';

  // Generic HTTP methods
  static Future<ApiResponse<T>> get<T>(String endpoint);
  static Future<ApiResponse<T>> post<T>(String endpoint);
  static Future<ApiResponse<T>> put<T>(String endpoint);
  static Future<ApiResponse<T>> delete<T>(String endpoint);
}

// Feature-specific API Services
class AuthApiService extends BaseApiClient {
  static Future<ApiResponse> login({required String email, required String password});
  static Future<ApiResponse> register({required Map<String, dynamic> userData});
}
```

### 2. State Management

```dart
// Provider Pattern untuk state management
class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  bool _isLoading = false;

  // Getters
  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;

  // Methods
  Future<void> fetchProjects() async {
    _isLoading = true;
    notifyListeners();
    // Fetch logic
    _isLoading = false;
    notifyListeners();
  }
}
```

### 3. Storage Architecture

```dart
// Abstraction untuk storage
abstract class StorageService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
}

// Implementation dengan SharedPreferences
class SharedPreferencesService implements StorageService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }
}
```

## 🎨 UI Architecture

### 1. Widget Hierarchy

```
MaterialApp
├── Theme Configuration
├── Navigation Routes
└── Feature Pages
    ├── Scaffold
    ├── AppBar (optional)
    ├── Body
    │   ├── Background Widget
    │   ├── Content Widgets
    │   └── Floating Elements
    └── Bottom Navigation (MainScreen)
```

### 2. Custom Widget System

```dart
// Base widget untuk konsistensi
abstract class OptimizedWidget extends StatelessWidget {
  const OptimizedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);
}

// Implementasi custom widgets
class OptimizedImage extends OptimizedWidget {
  final String imageUrl;
  final double? width, height;
  final BoxFit fit;

  const OptimizedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);
}
```

### 3. Animation System

```dart
// Animation controller management
class AnimationManager {
  late AnimationController _controller;
  late Animation<double> _animation;

  void initAnimation(TickerProvider vsync) {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
}
```

## 🔐 Security Architecture

### 1. Authentication Flow

```
User Input → Validation → Firebase Auth → API Token → Local Storage → App State
```

### 2. API Security

```dart
class SecurityManager {
  static Map<String, String> getSecureHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token ?? currentUserToken}',
    };
  }

  static bool validateToken(String token) {
    // Token validation logic
    return token.isNotEmpty && token.length > 10;
  }
}
```

## 📊 Data Flow Architecture

### 1. Unidirectional Data Flow

```
UI Event → Provider → Service → API → Response → Provider → UI Update
```

### 2. Error Handling Flow

```
API Error → ApiResponse.error → Service Layer → Provider → UI Error State
```

### 3. Loading State Management

```dart
enum LoadingState {
  initial,
  loading,
  loaded,
  error,
}

class BaseProvider extends ChangeNotifier {
  LoadingState _state = LoadingState.initial;
  String? _errorMessage;

  LoadingState get state => _state;
  String? get errorMessage => _errorMessage;

  void setLoading() {
    _state = LoadingState.loading;
    notifyListeners();
  }

  void setLoaded() {
    _state = LoadingState.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String message) {
    _state = LoadingState.error;
    _errorMessage = message;
    notifyListeners();
  }
}
```

## 🚀 Performance Architecture

### 1. Widget Optimization

```dart
// Menggunakan const constructors
const OptimizedWidget({Key? key}) : super(key: key);

// IndexedStack untuk tab navigation
IndexedStack(
  index: selectedIndex,
  children: pages,
)

// Lazy loading untuk lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### 2. Memory Management

```dart
class MemoryOptimizedPage extends StatefulWidget {
  @override
  _MemoryOptimizedPageState createState() => _MemoryOptimizedPageState();
}

class _MemoryOptimizedPageState extends State<MemoryOptimizedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose(); // Proper cleanup
    super.dispose();
  }
}
```

### 3. Image Optimization

```dart
class OptimizedImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => ShimmerWidget(),
      errorWidget: (context, url, error) => ErrorWidget(),
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
    );
  }
}
```

## 🔄 Navigation Architecture

### 1. Route Management

```dart
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      default:
        return MaterialPageRoute(builder: (_) => NotFoundPage());
    }
  }
}
```

### 2. Navigation Patterns

```dart
// Push navigation
Navigator.push(
  context,
  OptimizedPageRoute(
    child: TargetPage(),
    transitionType: PageTransitionType.slideLeft,
  ),
);

// Replace navigation
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => NewPage()),
);

// Pop navigation
Navigator.pop(context, result);
```

## 📱 Platform-Specific Architecture

### 1. Android Configuration

```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### 2. iOS Configuration

```xml
<!-- ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for profile pictures</string>
```

## 🧪 Testing Architecture

### 1. Test Structure

```
test/
├── unit/
│   ├── models/
│   ├── services/
│   └── providers/
├── widget/
│   ├── pages/
│   └── components/
└── integration/
    └── flows/
```

### 2. Test Patterns

```dart
// Unit test example
group('AuthService Tests', () {
  test('should login successfully with valid credentials', () async {
    // Arrange
    final authService = AuthService();

    // Act
    final result = await authService.login('test@email.com', 'password');

    // Assert
    expect(result.success, true);
  });
});

// Widget test example
testWidgets('LoginPage should display login form', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginPage()));

  expect(find.byType(TextFormField), findsNWidgets(2));
  expect(find.text('Masuk'), findsOneWidget);
});
```

## 📈 Scalability Considerations

### 1. Modular Architecture

- Setiap fitur dapat dikembangkan secara independen
- Easy to add new features
- Maintainable codebase

### 2. Performance Scalability

- Lazy loading untuk data besar
- Pagination untuk lists
- Image caching dan optimization

### 3. Team Scalability

- Clear separation of concerns
- Consistent coding standards
- Comprehensive documentation

---

**Arsitektur ini dirancang untuk mendukung pengembangan aplikasi yang scalable, maintainable, dan performant.**
