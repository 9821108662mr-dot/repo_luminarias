import 'package:flutter/material.dart';
import '../widgets/fixture_card.dart';
import '../models/fixture.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Fixture> fixtures = [
      Fixture(
        nombre: 'Luminaria Beam 230',
        marca: 'Spotlight',
        tipo: 'Beam',
        imagen: 'assets/images/beam230.png',
      ),
      Fixture(
        nombre: 'Wash LED 36x10W',
        marca: 'Chauvet',
        tipo: 'Wash',
        imagen: 'assets/images/wash.png',
      ),
      Fixture(
        nombre: 'Sharpy',
        marca: 'Claypaky',
        tipo: 'Beam',
        imagen: 'assets/images/sharpy.png',
      ),
      Fixture(
        nombre: 'Protones',
        marca: 'ProtonTech',
        tipo: 'Beam',
        imagen: 'assets/images/proton.png',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositorio de Luminarias'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: fixtures.length,
        itemBuilder: (context, index) {
          return FixtureCard(fixture: fixtures[index]);
        },
      ),
    );
  }
}
