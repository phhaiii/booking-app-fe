import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  // Keys
  static const String _keyToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyEmail = 'user_email';
  static const String _keyRole = 'user_role';
  static const String _keyRoleId = 'user_role_id';
  static const String _keyFullName = 'user_full_name';
  static const String _keyPhone = 'user_phone';
  static const String _keyAvatar = 'user_avatar';

  // ✅ Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('StorageService initialized');
  }

  // ✅ Ensure initialized
  static Future<SharedPreferences> _getPrefs() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  // 🔐 TOKEN MANAGEMENT
  static Future<void> saveToken(String token) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyToken, token);
    print('Token saved');
  }

  static Future<String?> getToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyToken);
  }

  static Future<void> saveRefreshToken(String refreshToken) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyRefreshToken, refreshToken);
    print('Refresh token saved');
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyRefreshToken);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    final userId = await getUserId();

    bool loggedIn = token != null &&
        token.isNotEmpty &&
        userId != null &&
        userId.isNotEmpty;

    print('Login status: $loggedIn');
    return loggedIn;
  }

  // 👤 USER DATA MANAGEMENT
  static Future<void> saveUserId(String userId) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyUserId, userId);
    print('User ID saved: $userId');
  }

  static Future<String?> getUserId() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyUserId);
  }

  static Future<void> saveEmail(String email) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyEmail, email);
    print('Email saved: $email');
  }

  static Future<String?> getEmail() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyEmail);
  }

  static Future<void> saveRole(String role) async {
    print('💾 StorageService.saveRole called with: "$role"');
    final prefs = await _getPrefs();
    await prefs.setString(_keyRole, role);
    print('💾 Role saved to SharedPreferences: $role');
    // Verify it was saved
    final savedRole = prefs.getString(_keyRole);
    print('💾 Verification read: $savedRole');
  }

  static Future<String?> getUserRole() async {
    final prefs = await _getPrefs();
    final role = prefs.getString(_keyRole);
    print('📖 StorageService.getUserRole: $role');
    return role;
  }

  static Future<void> saveRoleId(int roleId) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_keyRoleId, roleId);
    print('Role ID saved: $roleId');
  }

  static Future<int?> getRoleId() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_keyRoleId);
  }

  static Future<void> saveFullName(String fullName) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyFullName, fullName);
    print('Full name saved: $fullName');
  }

  static Future<String?> getFullName() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyFullName);
  }

  static Future<void> savePhone(String phone) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyPhone, phone);
    print('Phone saved: $phone');
  }

  static Future<String?> getPhone() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyPhone);
  }

  static Future<void> saveAvatar(String avatarUrl) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyAvatar, avatarUrl);
    print('Avatar saved');
  }

  static Future<String?> getAvatar() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyAvatar);
  }

  // ✅ Save complete user data
  static Future<void> saveUserData({
    required String userId,
    required String email,
    required String role,
    int? roleId,
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    await Future.wait([
      saveUserId(userId),
      saveEmail(email),
      saveRole(role),
      if (roleId != null) saveRoleId(roleId),
      if (fullName != null) saveFullName(fullName),
      if (phone != null) savePhone(phone),
      if (avatarUrl != null) saveAvatar(avatarUrl),
    ]);

    print('All user data saved');
  }

  static Future<Map<String, dynamic>> getAllUserData() async {
    final results = await Future.wait([
      getUserId(),
      getEmail(),
      getUserRole(),
      getRoleId(),
      getFullName(),
      getPhone(),
      getAvatar(),
    ]);

    return {
      'userId': results[0],
      'email': results[1],
      'role': results[2],
      'roleId': results[3],
      'fullName': results[4],
      'phone': results[5],
      'avatar': results[6],
    };
  }

  // 🗑️ CLEAR DATA
  static Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
    print('All data cleared (logged out)');
  }

  static Future<void> clearTokens() async {
    final prefs = await _getPrefs();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyRefreshToken);
    print('Tokens cleared');
  }

  static Future<bool> hasKey(String key) async {
    final prefs = await _getPrefs();
    return prefs.containsKey(key);
  }

  static Future<void> debugPrintAll() async {
    final prefs = await _getPrefs();
    final keys = prefs.getKeys();

    print('===== STORED DATA =====');
    for (var key in keys) {
      final value = prefs.get(key);
      if (key.contains('token')) {
        print('   $key: ${value.toString().substring(0, 10)}...');
      } else {
        print('   $key: $value');
      }
    }
    print('========================');
  }
}
