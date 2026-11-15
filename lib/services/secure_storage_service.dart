import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/logger.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _tokenKey = 'auth_token';
  static const String _pinKey = 'user_pin';
  // Menyimpan token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    Logger.info('Token berhasil tersimpan', tag: 'SecureStorage');
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: _tokenKey);
    Logger.debug(
      token != null ? 'Token ditemukan' : 'Token tidak ditemukan',
      tag: 'SecureStorage',
    );
    return token;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    Logger.info('Token berhasil dihapus', tag: 'SecureStorage');
  }

  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    Logger.info('PIN berhasil disimpan', tag: 'SecureStorage');
  }

  Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
    Logger.info('Semua data berhasil dihapus', tag: 'SecureStorage');
  }

  Future<bool> hasToken() async {
    return await _storage.containsKey(key: _tokenKey);
  }
}
