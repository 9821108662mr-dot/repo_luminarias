import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';

  // Login contra el backend
  static Future<bool> login(String username, String password) async {
    try {
      final uri = Uri.parse("${AppConfig.backendUrl}/token");
      final response = await http
          .post(uri, body: {'username': username, 'password': password})
          .timeout(AppConfig.apiTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        await _storage.write(key: _tokenKey, value: token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error en login: $e");
      return false;
    }
  }

  // Obtener token guardado
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Cerrar sesión
  static Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  // Verificar si está logueado
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
