# 🌐 API Documentation MentorMe

## 📋 Base Configuration

### Base URL

```
https://widgets22-catb7yz54a-et.a.run.app/api
```

### Authentication

Semua API request (kecuali login/register) memerlukan Bearer Token:

```
Authorization: Bearer {token}
```

### Response Format

```json
{
  "success": true/false,
  "data": {...},
  "message": "Success message",
  "statusCode": 200
}
```

---

## 🔐 Authentication APIs

### 1. Login

**Endpoint**: `POST /auth/login`

**Request Body**:

```json
{
  "email": "user@example.com",
  "password": "password123",
  "fcmToken": "firebase_fcm_token"
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "token": "jwt_token_here",
    "nameUser": "John Doe",
    "email": "user@example.com",
    "categories": [
      {
        "id": 1,
        "name": "Programming",
        "description": "Learn programming"
      }
    ],
    "learningPath": [
      {
        "ID": 1,
        "name": "Flutter Development",
        "picture": "image_url",
        "description": "Complete Flutter course"
      }
    ]
  },
  "message": "Login successful"
}
```

**Implementation**:

```dart
// lib/features/auth/services/auth_api_service.dart
class AuthApiService {
  static Future<ApiResponse> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    return await BaseApiClient.post('/auth/login', body: {
      'email': email,
      'password': password,
      'fcmToken': fcmToken,
    });
  }
}
```

### 2. Register

**Endpoint**: `POST /auth/register`

**Request Body**:

```json
{
  "fullName": "John Doe",
  "email": "user@example.com",
  "password": "password123",
  "confirmPassword": "password123",
  "fcmToken": "firebase_fcm_token",
  "termsAccepted": true,
  "privacyAccepted": true
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "userId": "user_id",
    "message": "Registration successful"
  },
  "message": "User registered successfully"
}
```

---

## 🏠 Home APIs

### 1. Get Dashboard Data

**Endpoint**: `GET /home/dashboard`

**Headers**: `Authorization: Bearer {token}`

**Response**:

```json
{
  "success": true,
  "data": {
    "user": {
      "fullName": "John Doe",
      "picture": "profile_image_url",
      "coins": 150
    },
    "categories": [
      {
        "id": 1,
        "name": "Programming",
        "icon": "icon_url"
      }
    ],
    "learningPaths": [
      {
        "ID": 1,
        "name": "Flutter Development",
        "picture": "image_url",
        "progress": 45,
        "totalProjects": 10
      }
    ],
    "featuredProjects": [
      {
        "id": 1,
        "title": "Todo App",
        "description": "Build a todo application",
        "difficulty": "Beginner",
        "rating": 4.5
      }
    ]
  }
}
```

**Implementation**:

```dart
// lib/features/home/services/home_api_service.dart
class HomeApiService {
  static Future<ApiResponse> getDashboardData() async {
    return await BaseApiClient.get('/home/dashboard');
  }
}
```

---

## 📚 Project Marketplace APIs

### 1. Get All Projects

**Endpoint**: `GET /projects`

**Query Parameters**:

- `page`: Page number (default: 1)
- `limit`: Items per page (default: 10)
- `category`: Filter by category ID
- `search`: Search query
- `difficulty`: Filter by difficulty (Beginner, Intermediate, Advanced)

**Example**: `GET /projects?page=1&limit=10&category=1&search=flutter`

**Response**:

```json
{
  "success": true,
  "data": {
    "projects": [
      {
        "id": 1,
        "title": "Flutter Todo App",
        "description": "Build a complete todo application",
        "picture": "project_image_url",
        "difficulty": "Beginner",
        "rating": 4.5,
        "totalRatings": 120,
        "duration": "2 weeks",
        "price": 50,
        "category": {
          "id": 1,
          "name": "Mobile Development"
        },
        "mentor": {
          "id": 1,
          "name": "John Smith",
          "picture": "mentor_image_url"
        }
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 5,
      "totalItems": 50,
      "hasNext": true,
      "hasPrev": false
    }
  }
}
```

### 2. Get Project Detail

**Endpoint**: `GET /projects/{id}`

**Response**:

```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Flutter Todo App",
    "description": "Complete description...",
    "longDescription": "Detailed description...",
    "picture": "project_image_url",
    "gallery": ["image1.jpg", "image2.jpg"],
    "difficulty": "Beginner",
    "rating": 4.5,
    "totalRatings": 120,
    "duration": "2 weeks",
    "price": 50,
    "requirements": ["Flutter basics", "Dart knowledge"],
    "learningOutcomes": ["Build mobile apps", "State management"],
    "syllabus": [
      {
        "week": 1,
        "title": "Introduction",
        "topics": ["Setup", "Basic widgets"]
      }
    ],
    "mentor": {
      "id": 1,
      "name": "John Smith",
      "picture": "mentor_image_url",
      "bio": "Expert Flutter developer",
      "rating": 4.8,
      "totalStudents": 500
    },
    "reviews": [
      {
        "id": 1,
        "user": "Jane Doe",
        "rating": 5,
        "comment": "Excellent course!",
        "date": "2024-01-15"
      }
    ]
  }
}
```

**Implementation**:

```dart
// lib/features/project_marketplace/services/project_marketplace_api_service.dart
class ProjectMarketplaceApiService {
  static Future<ApiResponse> getAllProjects({
    int page = 1,
    int limit = 10,
    String? category,
    String? search,
    String? difficulty,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;
    if (difficulty != null) queryParams['difficulty'] = difficulty;

    return await BaseApiClient.get('/projects', queryParams: queryParams);
  }

  static Future<ApiResponse> getProjectDetail(String projectId) async {
    return await BaseApiClient.get('/projects/$projectId');
  }
}
```

---

## 📖 Learning APIs

### 1. Get My Learning

**Endpoint**: `GET /learning/my-courses`

**Response**:

```json
{
  "success": true,
  "data": {
    "enrolledCourses": [
      {
        "id": 1,
        "title": "Flutter Development",
        "picture": "course_image_url",
        "progress": 65,
        "totalLessons": 20,
        "completedLessons": 13,
        "lastAccessed": "2024-01-15T10:30:00Z",
        "certificate": null,
        "status": "in_progress"
      }
    ],
    "completedCourses": [
      {
        "id": 2,
        "title": "Dart Basics",
        "picture": "course_image_url",
        "progress": 100,
        "completedDate": "2024-01-10T15:45:00Z",
        "certificate": "certificate_url",
        "rating": 5
      }
    ]
  }
}
```

### 2. Get Course Detail

**Endpoint**: `GET /learning/courses/{id}`

**Response**:

```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Flutter Development",
    "description": "Complete Flutter course",
    "picture": "course_image_url",
    "progress": 65,
    "totalLessons": 20,
    "completedLessons": 13,
    "lessons": [
      {
        "id": 1,
        "title": "Introduction to Flutter",
        "duration": "15 minutes",
        "type": "video",
        "videoUrl": "video_url",
        "completed": true,
        "order": 1
      },
      {
        "id": 2,
        "title": "Widgets Basics",
        "duration": "20 minutes",
        "type": "video",
        "videoUrl": "video_url",
        "completed": false,
        "order": 2
      }
    ],
    "quizzes": [
      {
        "id": 1,
        "title": "Flutter Basics Quiz",
        "totalQuestions": 10,
        "passingScore": 70,
        "completed": true,
        "score": 85
      }
    ]
  }
}
```

**Implementation**:

```dart
// lib/features/learning/services/learning_api_service.dart
class LearningApiService {
  static Future<ApiResponse> getMyCourses() async {
    return await BaseApiClient.get('/learning/my-courses');
  }

  static Future<ApiResponse> getCourseDetail(String courseId) async {
    return await BaseApiClient.get('/learning/courses/$courseId');
  }

  static Future<ApiResponse> markLessonComplete(String lessonId) async {
    return await BaseApiClient.post('/learning/lessons/$lessonId/complete');
  }
}
```

---

## 💬 Consultation APIs

### 1. Get Available Mentors

**Endpoint**: `GET /consultation/mentors`

**Query Parameters**:

- `expertise`: Filter by expertise area
- `availability`: Filter by availability (available, busy, offline)
- `priceRange`: Filter by price range (low, medium, high)

**Response**:

```json
{
  "success": true,
  "data": {
    "mentors": [
      {
        "id": 1,
        "name": "John Smith",
        "picture": "mentor_image_url",
        "title": "Senior Flutter Developer",
        "expertise": ["Flutter", "Dart", "Mobile Development"],
        "rating": 4.8,
        "totalReviews": 150,
        "pricePerHour": 50,
        "availability": "available",
        "responseTime": "< 1 hour",
        "languages": ["English", "Indonesian"],
        "bio": "Expert Flutter developer with 5+ years experience"
      }
    ]
  }
}
```

### 2. Book Consultation

**Endpoint**: `POST /consultation/book`

**Request Body**:

```json
{
  "mentorId": 1,
  "date": "2024-01-20",
  "time": "14:00",
  "duration": 60,
  "topic": "Flutter State Management",
  "description": "Need help with Provider pattern",
  "paymentMethod": "coins"
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "bookingId": "booking_123",
    "status": "confirmed",
    "meetingUrl": "https://meet.mentorme.com/room/abc123",
    "totalCost": 50,
    "paymentStatus": "paid"
  }
}
```

### 3. Get Chat Messages

**Endpoint**: `GET /consultation/chat/{bookingId}/messages`

**Response**:

```json
{
  "success": true,
  "data": {
    "messages": [
      {
        "id": 1,
        "senderId": "user_123",
        "senderName": "John Doe",
        "message": "Hello, I need help with Flutter",
        "timestamp": "2024-01-20T14:05:00Z",
        "type": "text"
      },
      {
        "id": 2,
        "senderId": "mentor_456",
        "senderName": "Jane Smith",
        "message": "Sure, what specific issue are you facing?",
        "timestamp": "2024-01-20T14:06:00Z",
        "type": "text"
      }
    ]
  }
}
```

**Implementation**:

```dart
// lib/features/consultation/services/consultation_api_service.dart
class ConsultationApiService {
  static Future<ApiResponse> getAvailableMentors({
    String? expertise,
    String? availability,
    String? priceRange,
  }) async {
    final queryParams = <String, String>{};
    if (expertise != null) queryParams['expertise'] = expertise;
    if (availability != null) queryParams['availability'] = availability;
    if (priceRange != null) queryParams['priceRange'] = priceRange;

    return await BaseApiClient.get('/consultation/mentors', queryParams: queryParams);
  }

  static Future<ApiResponse> bookConsultation({
    required int mentorId,
    required String date,
    required String time,
    required int duration,
    required String topic,
    String? description,
  }) async {
    return await BaseApiClient.post('/consultation/book', body: {
      'mentorId': mentorId,
      'date': date,
      'time': time,
      'duration': duration,
      'topic': topic,
      'description': description,
    });
  }
}
```

---

## 💳 Payment APIs

### 1. Create Payment

**Endpoint**: `POST /payment/create`

**Request Body**:

```json
{
  "type": "course_enrollment", // course_enrollment, consultation, topup
  "itemId": "course_123",
  "amount": 100,
  "paymentMethod": "credit_card", // credit_card, bank_transfer, e_wallet, coins
  "currency": "IDR"
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "paymentId": "payment_123",
    "amount": 100,
    "currency": "IDR",
    "status": "pending",
    "paymentUrl": "https://payment.gateway.com/pay/abc123",
    "expiresAt": "2024-01-20T15:00:00Z"
  }
}
```

### 2. Check Payment Status

**Endpoint**: `GET /payment/{paymentId}/status`

**Response**:

```json
{
  "success": true,
  "data": {
    "paymentId": "payment_123",
    "status": "completed", // pending, completed, failed, expired
    "amount": 100,
    "currency": "IDR",
    "paidAt": "2024-01-20T14:30:00Z",
    "receipt": "receipt_url"
  }
}
```

**Implementation**:

```dart
// lib/features/payment/services/payment_api_service.dart
class PaymentApiService {
  static Future<ApiResponse> createPayment({
    required String type,
    required String itemId,
    required double amount,
    required String paymentMethod,
    String currency = 'IDR',
  }) async {
    return await BaseApiClient.post('/payment/create', body: {
      'type': type,
      'itemId': itemId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'currency': currency,
    });
  }

  static Future<ApiResponse> checkPaymentStatus(String paymentId) async {
    return await BaseApiClient.get('/payment/$paymentId/status');
  }
}
```

---

## 💰 Top-up APIs

### 1. Get Coin Packages

**Endpoint**: `GET /topup/packages`

**Response**:

```json
{
  "success": true,
  "data": {
    "packages": [
      {
        "id": 1,
        "name": "Starter Pack",
        "coins": 100,
        "price": 50000,
        "bonus": 10,
        "totalCoins": 110,
        "popular": false
      },
      {
        "id": 2,
        "name": "Popular Pack",
        "coins": 500,
        "price": 200000,
        "bonus": 100,
        "totalCoins": 600,
        "popular": true
      }
    ]
  }
}
```

### 2. Purchase Coins

**Endpoint**: `POST /topup/purchase`

**Request Body**:

```json
{
  "packageId": 1,
  "paymentMethod": "credit_card"
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "transactionId": "topup_123",
    "coins": 110,
    "amount": 50000,
    "paymentUrl": "https://payment.gateway.com/pay/xyz789"
  }
}
```

### 3. Get Top-up History

**Endpoint**: `GET /topup/history`

**Query Parameters**:

- `page`: Page number
- `limit`: Items per page
- `startDate`: Filter from date (YYYY-MM-DD)
- `endDate`: Filter to date (YYYY-MM-DD)

**Response**:

```json
{
  "success": true,
  "data": {
    "transactions": [
      {
        "id": "topup_123",
        "coins": 110,
        "amount": 50000,
        "status": "completed",
        "paymentMethod": "credit_card",
        "createdAt": "2024-01-20T14:30:00Z",
        "receipt": "receipt_url"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 3,
      "totalItems": 25
    }
  }
}
```

**Implementation**:

```dart
// lib/features/topup/services/topup_api_service.dart
class TopupApiService {
  static Future<ApiResponse> getCoinPackages() async {
    return await BaseApiClient.get('/topup/packages');
  }

  static Future<ApiResponse> purchaseCoins({
    required int packageId,
    required String paymentMethod,
  }) async {
    return await BaseApiClient.post('/topup/purchase', body: {
      'packageId': packageId,
      'paymentMethod': paymentMethod,
    });
  }

  static Future<ApiResponse> getTopupHistory({
    int page = 1,
    int limit = 10,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (startDate != null) queryParams['startDate'] = startDate;
    if (endDate != null) queryParams['endDate'] = endDate;

    return await BaseApiClient.get('/topup/history', queryParams: queryParams);
  }
}
```

---

## 👤 Profile APIs

### 1. Get User Profile

**Endpoint**: `GET /profile`

**Response**:

```json
{
  "success": true,
  "data": {
    "id": "user_123",
    "fullName": "John Doe",
    "email": "john@example.com",
    "picture": "profile_image_url",
    "phone": "+62812345678",
    "dateOfBirth": "1990-01-15",
    "gender": "male",
    "location": "Jakarta, Indonesia",
    "bio": "Flutter enthusiast",
    "coins": 150,
    "totalCourses": 5,
    "completedCourses": 2,
    "totalConsultations": 3,
    "joinedDate": "2023-12-01T00:00:00Z"
  }
}
```

### 2. Update Profile

**Endpoint**: `PUT /profile`

**Request Body**:

```json
{
  "fullName": "John Doe Updated",
  "phone": "+62812345679",
  "dateOfBirth": "1990-01-15",
  "gender": "male",
  "location": "Jakarta, Indonesia",
  "bio": "Updated bio"
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "message": "Profile updated successfully"
  }
}
```

### 3. Upload Profile Picture

**Endpoint**: `POST /profile/picture`

**Request**: Multipart form data

- `picture`: Image file

**Response**:

```json
{
  "success": true,
  "data": {
    "pictureUrl": "https://storage.googleapis.com/mentorme/profiles/user_123.jpg"
  }
}
```

**Implementation**:

```dart
// lib/features/profile/services/profile_api_service.dart
class ProfileApiService {
  static Future<ApiResponse> getUserProfile() async {
    return await BaseApiClient.get('/profile');
  }

  static Future<ApiResponse> updateProfile({
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? location,
    String? bio,
  }) async {
    final body = <String, dynamic>{};
    if (fullName != null) body['fullName'] = fullName;
    if (phone != null) body['phone'] = phone;
    if (dateOfBirth != null) body['dateOfBirth'] = dateOfBirth;
    if (gender != null) body['gender'] = gender;
    if (location != null) body['location'] = location;
    if (bio != null) body['bio'] = bio;

    return await BaseApiClient.put('/profile', body: body);
  }

  static Future<ApiResponse> uploadProfilePicture(String imagePath) async {
    return await BaseApiClient.multipartRequest(
      '/profile/picture',
      'POST',
      files: {'picture': imagePath},
    );
  }
}
```

---

## 🔔 Notification APIs

### 1. Get Notifications

**Endpoint**: `GET /notifications`

**Query Parameters**:

- `page`: Page number
- `limit`: Items per page
- `type`: Filter by type (course, consultation, payment, system)
- `read`: Filter by read status (true, false)

**Response**:

```json
{
  "success": true,
  "data": {
    "notifications": [
      {
        "id": 1,
        "title": "Course Completed",
        "message": "Congratulations! You've completed Flutter Basics",
        "type": "course",
        "read": false,
        "data": {
          "courseId": "course_123"
        },
        "createdAt": "2024-01-20T14:30:00Z"
      }
    ],
    "unreadCount": 5,
    "pagination": {
      "currentPage": 1,
      "totalPages": 3,
      "totalItems": 25
    }
  }
}
```

### 2. Mark as Read

**Endpoint**: `PUT /notifications/{id}/read`

**Response**:

```json
{
  "success": true,
  "data": {
    "message": "Notification marked as read"
  }
}
```

### 3. Mark All as Read

**Endpoint**: `PUT /notifications/read-all`

**Response**:

```json
{
  "success": true,
  "data": {
    "message": "All notifications marked as read"
  }
}
```

---

## 🚨 Error Handling

### Error Response Format

```json
{
  "success": false,
  "message": "Error message",
  "statusCode": 400,
  "errors": {
    "field": ["Validation error message"]
  }
}
```

### Common Error Codes

- **400**: Bad Request - Invalid input data
- **401**: Unauthorized - Invalid or missing token
- **403**: Forbidden - Insufficient permissions
- **404**: Not Found - Resource not found
- **422**: Unprocessable Entity - Validation errors
- **500**: Internal Server Error - Server error

### Error Handling Implementation

```dart
// lib/core/api/base_api_client.dart
static ApiResponse<T> _handleResponse<T>(http.Response response) {
  try {
    final Map<String, dynamic> data = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse.success(
        data: data['data'],
        message: data['message'] ?? 'Success',
        statusCode: response.statusCode,
      );
    } else {
      return ApiResponse.error(
        data['error'] ?? data['message'] ?? 'Terjadi kesalahan',
        statusCode: response.statusCode,
      );
    }
  } catch (e) {
    return ApiResponse.error(
      'Format response tidak valid',
      statusCode: response.statusCode,
    );
  }
}
```

---

## 🔧 API Client Configuration

### Base API Client

```dart
// lib/core/api/base_api_client.dart
class BaseApiClient {
  static const String baseUrl = 'https://widgets22-catb7yz54a-et.a.run.app/api';
  static const Duration timeout = Duration(seconds: 30);

  static Map<String, String> _getHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else if (currentUserToken != null) {
      headers['Authorization'] = 'Bearer $currentUserToken';
    }

    return headers;
  }
}
```

### API Response Model

```dart
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final int? statusCode;

  ApiResponse._({
    required this.success,
    this.data,
    required this.message,
    this.statusCode,
  });

  factory ApiResponse.success({
    T? data,
    required String message,
    int? statusCode,
  }) {
    return ApiResponse._(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(
    String message, {
    int? statusCode,
  }) {
    return ApiResponse._(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}
```

---

**API Documentation ini mencakup semua endpoint yang digunakan dalam aplikasi MentorMe dengan contoh request/response yang lengkap dan implementasi code yang sesuai.**
