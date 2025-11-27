// lib/screens/details_screen.dart
import 'package:flutter/material.dart';
import '../models/fixture.dart';
import '../widgets/fixture_card.dart';
import '../config/app_config.dart';

class DetailsScreen extends StatelessWidget {
  final String brandName;
  final List fixturesRaw; // puede ser List<Map> o List<Fixture>

  const DetailsScreen({
    super.key,
    required this.brandName,
    required this.fixturesRaw,
  });

  List<Fixture> _toFixtureList() {
    return fixturesRaw.map<Fixture>((f) {
      if (f is Fixture) return f;
      if (f is Map) return Fixture.fromJson(Map<String, dynamic>.from(f));
      return Fixture(
        nombre: '',
        tipo: '',
        imagen: '',
        marca: brandName,
        manual: '',
        libreria: '',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final fixtures = _toFixtureList();
    // Mostrar todos los fixtures, no solo 4
    final mostrar = fixtures;

    return Scaffold(
      backgroundColor: const Color(AppConfig.primaryColorValue),
      appBar: AppBar(
        backgroundColor: const Color(AppConfig.primaryLightColorValue),
        title: Text(
          brandName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: mostrar.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // responsive: puedes ajustar
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return FixtureCard(fixture: mostrar[index]);
          },
        ),
      ),
    );
  }
}
