import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String tokenKey = 'token';

  Future<void> saveUser({
    required int userId,
    required String name,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(userIdKey, userId);
    await prefs.setString(userNameKey, name);
    await prefs.setString(tokenKey, token);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(userIdKey);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(userNameKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(tokenKey);
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(userIdKey);
    await prefs.remove(userNameKey);
    await prefs.remove(tokenKey);
  }
}