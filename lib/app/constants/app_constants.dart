class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://widgets22-catb7yz54a-et.a.run.app/api';

  // App Information
  static const String appName = 'MentorMe';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String tokenKey = 'user_token';
  static const String userNameKey = 'nameUser';
  static const String userEmailKey = 'emailUser';
  static const String userPasswordKey = 'passwordUser';
  static const String isLoggedInKey = 'isLoggedIn';
  static const String isFirstLaunchKey = 'isFirstLaunch';
  static const String categoriesKey = 'categories';
  static const String learningPathsKey = 'learningPaths';

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String profileEndpoint = '/profile/get';
  static const String coinEndpoint = '/coin/get';
  static const String learningEndpoint = '/my/learning';
  static const String categoriesEndpoint = '/categories';
  static const String learnPathEndpoint = '/all/learnpath';
  static const String historyEndpoint = '/profile/history';

  // Notification
  static const String notificationChannelId = 'mentorme_channel';
  static const String notificationChannelName = 'MentorMe Notifications';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}
