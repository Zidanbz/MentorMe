import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentorme/app/constants/app_constants.dart';
import 'package:mentorme/core/error/app_error.dart';

abstract class StorageService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

class SharedPreferencesService implements StorageService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  SharedPreferencesService._();

  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  @override
  Future<void> setString(String key, String value) async {
    try {
      await _preferences!.setString(key, value);
    } catch (e) {
      throw CacheError(
        message: 'Failed to save string data',
        originalError: e,
      );
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return _preferences!.getString(key);
    } catch (e) {
      throw CacheError(
        message: 'Failed to get string data',
        originalError: e,
      );
    }
  }

  @override
  Future<void> setBool(String key, bool value) async {
    try {
      await _preferences!.setBool(key, value);
    } catch (e) {
      throw CacheError(
        message: 'Failed to save boolean data',
        originalError: e,
      );
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    try {
      return _preferences!.getBool(key);
    } catch (e) {
      throw CacheError(
        message: 'Failed to get boolean data',
        originalError: e,
      );
    }
  }

  @override
  Future<void> setInt(String key, int value) async {
    try {
      await _preferences!.setInt(key, value);
    } catch (e) {
      throw CacheError(
        message: 'Failed to save integer data',
        originalError: e,
      );
    }
  }

  @override
  Future<int?> getInt(String key) async {
    try {
      return _preferences!.getInt(key);
    } catch (e) {
      throw CacheError(
        message: 'Failed to get integer data',
        originalError: e,
      );
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await _preferences!.remove(key);
    } catch (e) {
      throw CacheError(
        message: 'Failed to remove data',
        originalError: e,
      );
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _preferences!.clear();
    } catch (e) {
      throw CacheError(
        message: 'Failed to clear data',
        originalError: e,
      );
    }
  }

  // Convenience methods for app-specific data
  Future<void> saveUserToken(String token) async {
    await setString(AppConstants.tokenKey, token);
  }

  Future<String?> getUserToken() async {
    return await getString(AppConstants.tokenKey);
  }

  Future<void> saveUserData({
    required String name,
    required String email,
    required String password,
  }) async {
    await setString(AppConstants.userNameKey, name);
    await setString(AppConstants.userEmailKey, email);
    await setString(AppConstants.userPasswordKey, password);
  }

  Future<Map<String, String?>> getUserData() async {
    return {
      'name': await getString(AppConstants.userNameKey),
      'email': await getString(AppConstants.userEmailKey),
      'password': await getString(AppConstants.userPasswordKey),
    };
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    await setBool(AppConstants.isLoggedInKey, isLoggedIn);
  }

  Future<bool> isLoggedIn() async {
    return await getBool(AppConstants.isLoggedInKey) ?? false;
  }

  Future<void> setFirstLaunch(bool isFirstLaunch) async {
    await setBool(AppConstants.isFirstLaunchKey, isFirstLaunch);
  }

  Future<bool> isFirstLaunch() async {
    return await getBool(AppConstants.isFirstLaunchKey) ?? true;
  }

  Future<void> logout() async {
    await remove(AppConstants.tokenKey);
    await remove(AppConstants.userNameKey);
    await remove(AppConstants.userEmailKey);
    await remove(AppConstants.userPasswordKey);
    await setBool(AppConstants.isLoggedInKey, false);
  }

  // Alias for clear method
  Future<void> clearAll() async {
    await clear();
  }
}
