import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color rojo = Color(0xFFD32F2F);
  static const Color blanco = Colors.white;
  static const Color dorado = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: rojo,
      primary: rojo,
      secondary: dorado,
      brightness: Brightness.light,
    );

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
      textTheme: const TextTheme(
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
      home: const LoginScreen(),
    );
  }
}
