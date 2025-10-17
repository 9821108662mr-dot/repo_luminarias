import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 🎨 Paleta de colores corporativos PRO-MG
  static const Color rojo = Color(0xFFD32F2F);
  static const Color blanco = Colors.white;
  static const Color dorado = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    // ✅ Definir el esquema de color usando una copia de la base
    final colorScheme = ColorScheme.fromSeed(
      seedColor: rojo,
      primary: rojo,
      secondary: dorado,
      brightness: Brightness.light,
    );

    // ✅ Crear el tema principal de la app
    final theme = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: blanco,
      appBarTheme: const AppBarTheme(
        backgroundColor: rojo,
        foregroundColor: blanco,
        centerTitle: true,
        elevation: 2,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: dorado,
        foregroundColor: rojo,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: rojo,
        ),
        bodyMedium: TextStyle(
          color: rojo,
          fontSize: 16,
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Repositorio de Luminarias',
      theme: theme,
      home: const HomeScreen(),
    );
  }
}

