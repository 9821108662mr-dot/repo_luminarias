// Este archivo contiene la configuración de la aplicación.
// Para un proyecto real, este archivo no debería ser incluido en el control de versiones (git).
// En su lugar, se deberían usar variables de entorno o un sistema de configuración más robusto.

class AppConfig {
  // Para desarrollo local, apunta a la IP de tu máquina o a localhost si usas un emulador de Android.
  // Para el emulador de Android, usa 10.0.2.2 para referirte al localhost de tu máquina.
  // Para un dispositivo físico en la misma red, usa la IP local de tu máquina (ej: 192.168.1.100).
  static const String apiUrl = "http://127.0.0.1:8000";
}
