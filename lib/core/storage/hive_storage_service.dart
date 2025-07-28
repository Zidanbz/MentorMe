import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OptimizedStorageService {
  static SharedPreferences? _prefs;
  static final Map<String, dynamic> _memoryCache = {};
  static const int _maxCacheSize = 100; // Limit memory cache size

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Clean up expired cache on init
    await _cleanupExpiredCache();
  }

  // User Data Storage with memory cache
  static Future<void> saveUserData(String key, dynamic value) async {
    final prefKey = 'user_$key';

    // Save to memory cache
    _memoryCache[prefKey] = value;
    _limitCacheSize();

    // Save to persistent storage
    if (value is String) {
      await _prefs!.setString(prefKey, value);
    } else if (value is int) {
      await _prefs!.setInt(prefKey, value);
    } else if (value is bool) {
      await _prefs!.setBool(prefKey, value);
    } else if (value is double) {
      await _prefs!.setDouble(prefKey, value);
    } else {
      // Serialize complex objects to JSON
      await _prefs!.setString(prefKey, jsonEncode(value));
    }
  }

  static T? getUserData<T>(String key) {
    final prefKey = 'user_$key';

    // Check memory cache first
    if (_memoryCache.containsKey(prefKey)) {
      return _memoryCache[prefKey] as T?;
    }

    // Fallback to persistent storage
    final value = _prefs!.get(prefKey);
    if (value != null) {
      _memoryCache[prefKey] = value;
      _limitCacheSize();
      return value as T?;
    }

    return null;
  }

  static Future<void> clearUserData() async {
    final keys =
        _prefs!.getKeys().where((key) => key.startsWith('user_')).toList();
    for (final key in keys) {
      await _prefs!.remove(key);
      _memoryCache.remove(key);
    }
  }

  // Cache Storage with TTL
  static Future<void> saveCache(String key, dynamic value,
      {Duration? ttl}) async {
    final cacheKey = 'cache_$key';
    final cacheData = {
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'ttl': ttl?.inMilliseconds,
    };

    // Save to memory cache
    _memoryCache[cacheKey] = cacheData;
    _limitCacheSize();

    // Save to persistent storage
    await _prefs!.setString(cacheKey, jsonEncode(cacheData));
  }

  static T? getCache<T>(String key) {
    final cacheKey = 'cache_$key';

    // Check memory cache first
    Map<String, dynamic>? cacheData;
    if (_memoryCache.containsKey(cacheKey)) {
      cacheData = _memoryCache[cacheKey] as Map<String, dynamic>?;
    } else {
      // Fallback to persistent storage
      final cacheString = _prefs!.getString(cacheKey);
      if (cacheString != null) {
        try {
          cacheData = jsonDecode(cacheString) as Map<String, dynamic>;
          _memoryCache[cacheKey] = cacheData;
          _limitCacheSize();
        } catch (e) {
          // Invalid cache data, remove it
          _prefs!.remove(cacheKey);
          return null;
        }
      }
    }

    if (cacheData == null) return null;

    final timestamp = cacheData['timestamp'] as int;
    final ttl = cacheData['ttl'] as int?;

    if (ttl != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - timestamp > ttl) {
        // Cache expired
        _prefs!.remove(cacheKey);
        _memoryCache.remove(cacheKey);
        return null;
      }
    }

    return cacheData['value'] as T?;
  }

  static Future<void> clearCache() async {
    final keys =
        _prefs!.getKeys().where((key) => key.startsWith('cache_')).toList();
    for (final key in keys) {
      await _prefs!.remove(key);
      _memoryCache.remove(key);
    }
  }

  // Settings Storage
  static Future<void> saveSetting(String key, dynamic value) async {
    final settingKey = 'setting_$key';

    _memoryCache[settingKey] = value;
    _limitCacheSize();

    if (value is String) {
      await _prefs!.setString(settingKey, value);
    } else if (value is int) {
      await _prefs!.setInt(settingKey, value);
    } else if (value is bool) {
      await _prefs!.setBool(settingKey, value);
    } else if (value is double) {
      await _prefs!.setDouble(settingKey, value);
    } else {
      await _prefs!.setString(settingKey, jsonEncode(value));
    }
  }

  static T? getSetting<T>(String key) {
    final settingKey = 'setting_$key';

    if (_memoryCache.containsKey(settingKey)) {
      return _memoryCache[settingKey] as T?;
    }

    final value = _prefs!.get(settingKey);
    if (value != null) {
      _memoryCache[settingKey] = value;
      _limitCacheSize();
      return value as T?;
    }

    return null;
  }

  // Cleanup expired cache entries
  static Future<void> _cleanupExpiredCache() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheKeys =
        _prefs!.getKeys().where((key) => key.startsWith('cache_')).toList();

    for (final key in cacheKeys) {
      final cacheString = _prefs!.getString(key);
      if (cacheString != null) {
        try {
          final cacheData = jsonDecode(cacheString) as Map<String, dynamic>;
          final timestamp = cacheData['timestamp'] as int?;
          final ttl = cacheData['ttl'] as int?;

          if (timestamp != null && ttl != null) {
            if (now - timestamp > ttl) {
              await _prefs!.remove(key);
              _memoryCache.remove(key);
            }
          }
        } catch (e) {
          // Invalid cache data, remove it
          await _prefs!.remove(key);
        }
      }
    }
  }

  // Limit memory cache size to prevent memory leaks
  static void _limitCacheSize() {
    if (_memoryCache.length > _maxCacheSize) {
      // Remove oldest entries (simple FIFO)
      final keysToRemove =
          _memoryCache.keys.take(_memoryCache.length - _maxCacheSize).toList();
      for (final key in keysToRemove) {
        _memoryCache.remove(key);
      }
    }
  }

  // Clear memory cache
  static void clearMemoryCache() {
    _memoryCache.clear();
  }

  // Get cache statistics
  static Map<String, int> getCacheStats() {
    final persistentKeys = _prefs!.getKeys();
    return {
      'memoryCache': _memoryCache.length,
      'userData': persistentKeys.where((k) => k.startsWith('user_')).length,
      'cache': persistentKeys.where((k) => k.startsWith('cache_')).length,
      'settings': persistentKeys.where((k) => k.startsWith('setting_')).length,
    };
  }
}
