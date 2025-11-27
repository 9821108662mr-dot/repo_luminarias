// lib/data/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fixture.dart';
import '../models/brand.dart';
import '../config/app_config.dart';
import 'fixtures_data.dart';

class ApiService {
  // Usar configuración centralizada
  static String get baseUrl => AppConfig.backendUrl;

  /// Obtener marcas: intenta backend, si falla devuelve las keys de fixturesData.
  static Future<List<Brand>> obtenerMarcas({String? token}) async {
    try {
      final uri = Uri.parse("$baseUrl/brands"); // Use the new /brands endpoint
      final headers = token != null
          ? <String, String>{'Authorization': 'Bearer $token'}
          : <String, String>{};
      final response = await http
          .get(uri, headers: headers)
          .timeout(AppConfig.apiTimeout);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((e) => Brand.fromJson(e))
            .toList(); // Parse to Brand objects
      } else {
        throw Exception(
          'Failed to load brands from API: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load brands: $e');
    }
  }

  /// Obtener fixtures por marca: intenta backend, si falla usa fixturesData local.
  static Future<List<Fixture>> obtenerFixturesPorMarca(
    String marca, {
    String? token,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/fixtures/${Uri.encodeComponent(marca)}");
      final headers = token != null
          ? <String, String>{'Authorization': 'Bearer $token'}
          : <String, String>{};
      final response = await http
          .get(uri, headers: headers)
          .timeout(AppConfig.apiTimeout);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map<Fixture>((f) => Fixture.fromJson(Map<String, dynamic>.from(f)))
            .toList();
      } else {
        return _fromLocal(marca);
      }
    } catch (e) {
      return _fromLocal(marca);
    }
  }

  // Convierte el mapa local fixturesData a List<Fixture>
  static List<Fixture> _fromLocal(String marca) {
    final list = fixturesData[marca] ?? [];
    return list
        .map((m) => Fixture.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  // Crear Marca
  static Future<bool> createBrand(String name, String token) async {
    try {
      final uri = Uri.parse("$baseUrl/brands");
      final response = await http
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'nombre': name}),
          )
          .timeout(AppConfig.apiTimeout);

      return response.statusCode == 200;
    } catch (e) {
      print("Error creating brand: $e");
      return false;
    }
  }

  // Crear Fixture
  static Future<bool> createFixture(
    String name,
    String brandName,
    String imageUrl,
    String? tipo,
    String? manualUrl,
    String? libreriaUrl,
    String token,
  ) async {
    try {
      final uri = Uri.parse("$baseUrl/fixtures?marca_nombre=$brandName");
      final response = await http
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'nombre': name,
              'imagen': imageUrl,
              'tipo': tipo,
              'manual': manualUrl,
              'libreria': libreriaUrl,
            }),
          )
          .timeout(AppConfig.apiTimeout);

      return response.statusCode == 200;
    } catch (e) {
      print("Error creating fixture: $e");
      return false;
    }
  }
}
