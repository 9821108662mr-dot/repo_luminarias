// lib/config/app_config.dart
class AppConfig {
  // URL del backend - cambiar aquí si el backend corre en otro puerto
  static const String backendUrl = "https://luminarias-backend.onrender.com";

  // Timeout para llamadas API
  static const Duration apiTimeout = Duration(seconds: 10);

  // Usuario y contraseña por defecto
  static const String defaultUsername = "admin";
  static const String defaultPassword = "admin";

  // Colores del tema azul
  static const int primaryColorValue = 0xFF0D1B2A; // azul oscuro de fondo
  static const int primaryLightColorValue = 0xFF1B263B; // paneles
  static const int accentColorValue = 0xFF2F80ED; // acento azul
  static const int cardColorValue = 0xFF1B263B; // color de tarjetas
  static const int cardBackColorValue = 0xFF243B55; // color de tarjeta reverso
}
