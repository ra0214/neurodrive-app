import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> saveUserId(int id) async {
    await _storage.write(key: _userIdKey, value: id.toString());
  }

  Future<int?> getUserId() async {
    final idStr = await _storage.read(key: _userIdKey);
    return idStr != null ? int.tryParse(idStr) : null;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
