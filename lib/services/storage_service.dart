import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:poetry_quest/models/user_progress.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static const String _userKey = 'current_user';
  static const String _usersKey = 'registered_users';
  static const String _progressPrefix = 'progress_';

  static Future<void> saveUser(String username, String password) async {
    try {
      print('=== StorageService.saveUser() ===');
      final p = await prefs;
      final users = p.getString(_usersKey) ?? '{}';
      print('保存前用户数据: $users');
      
      final Map<String, dynamic> usersMap = jsonDecode(users);
      print('当前用户映射: $usersMap');
      
      usersMap[username] = password;
      final encoded = jsonEncode(usersMap);
      print('保存后用户数据: $encoded');
      
      final success = await p.setString(_usersKey, encoded);
      print('保存操作结果: $success');
      print('用户 $username 保存成功');
    } catch (e) {
      print('保存用户时出错: $e');
      rethrow;
    }
  }

  static Future<bool> validateUser(String username, String password) async {
    try {
      print('=== StorageService.validateUser() ===');
      final p = await prefs;
      final users = p.getString(_usersKey) ?? '{}';
      print('存储的用户数据: $users');
      
      final Map<String, dynamic> usersMap = jsonDecode(users);
      print('用户映射: $usersMap');
      print('检查用户 $username');
      print('存储的密码: ${usersMap[username]}');
      print('输入的密码: $password');
      
      final isValid = usersMap[username] == password;
      print('验证结果: $isValid');
      
      return isValid;
    } catch (e) {
      print('验证用户时出错: $e');
      return false;
    }
  }

  static Future<bool> userExists(String username) async {
    final p = await prefs;
    final users = p.getString(_usersKey) ?? '{}';
    final Map<String, dynamic> usersMap = jsonDecode(users);
    return usersMap.containsKey(username);
  }

  static Future<void> setCurrentUser(String username) async {
    final p = await prefs;
    await p.setString(_userKey, username);
  }

  static Future<String?> getCurrentUser() async {
    final p = await prefs;
    return p.getString(_userKey);
  }

  static Future<void> logout() async {
    final p = await prefs;
    await p.remove(_userKey);
  }

  static Future<void> saveProgress(String username, UserProgress progress) async {
    final p = await prefs;
    await p.setString('$_progressPrefix$username', jsonEncode(progress.toJson()));
  }

  static Future<UserProgress?> loadProgress(String username) async {
    final p = await prefs;
    final data = p.getString('$_progressPrefix$username');
    if (data == null) return null;
    return UserProgress.fromJson(jsonDecode(data));
  }

  static Future<void> clearAll() async {
    final p = await prefs;
    await p.clear();
  }
}