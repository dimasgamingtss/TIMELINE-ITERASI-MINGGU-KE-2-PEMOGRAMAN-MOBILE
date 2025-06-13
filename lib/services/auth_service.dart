import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  // Hash password menggunakan SHA-256
  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Registrasi pengguna baru
  static Future<bool> register(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersKey) ?? [];
      
      // Cek apakah username sudah ada
      for (String userJson in usersJson) {
        final user = User.fromJson(jsonDecode(userJson));
        if (user.username == username) {
          return false; // Username sudah ada
        }
      }

      // Buat user baru
      final newUser = User(
        username: username,
        passwordHash: _hashPassword(password),
      );

      usersJson.add(jsonEncode(newUser.toJson()));
      await prefs.setStringList(_usersKey, usersJson);
      
      return true;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  // Login pengguna
  static Future<bool> login(String username, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersKey) ?? [];
      
      final passwordHash = _hashPassword(password);
      
      for (String userJson in usersJson) {
        final user = User.fromJson(jsonDecode(userJson));
        if (user.username == username && user.passwordHash == passwordHash) {
          // Simpan user yang sedang login
          await prefs.setString(_currentUserKey, userJson);
          return true;
        }
      }
      
      return false;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // Logout pengguna
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Dapatkan user yang sedang login
  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_currentUserKey);
      
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
      
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Cek apakah user sudah login
  static Future<bool> isLoggedIn() async {
    final currentUser = await getCurrentUser();
    return currentUser != null;
  }
} 