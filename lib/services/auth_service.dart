import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print("Login Status: ${response.statusCode}");
      print("Login Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {
        "status": "error",
        "message": "Server Error: ${response.statusCode}",
      };
    } catch (e) {
      return {"status": "error", "message": "Koneksi gagal: $e"};
    }
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {"status": "error", "message": "Koneksi gagal"};
    } catch (e) {
      return {"status": "error", "message": "Koneksi gagal: $e"};
    }
  }

  static Future<void> saveUserSession(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', user['id'].toString());
    await prefs.setString('userName', user['name']);
    await prefs.setString('userRole', user['role']);
    await prefs.setString('userEmail', user['email']);
    if (user['photo_profile'] != null) {
      await prefs.setString('userPhoto', user['photo_profile']);
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }
}
