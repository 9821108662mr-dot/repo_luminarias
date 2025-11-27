import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../data/api_service.dart';
import '../data/auth_service.dart';
import '../models/brand.dart';
import '../widgets/brand_card.dart';
import 'add_fixture_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Brand>> _brandsFuture;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
    _brandsFuture = ApiService.obtenerMarcas();
  }

  Future<void> _checkAdmin() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (mounted) {
      setState(() {
        _isAdmin = isLoggedIn;
      });
    }
  }

  void _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo PRO-MG'),
        actions: [
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Cerrar sesión',
            ),
        ],
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFixtureScreen(),
                  ),
                );
                if (result == true) {
                  setState(() {
                    _brandsFuture = ApiService.obtenerMarcas();
                  });
                }
              },
              backgroundColor: const Color(AppConfig.accentColorValue),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: FutureBuilder<List<Brand>>(
        future: _brandsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(AppConfig.accentColorValue),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _brandsFuture = ApiService.obtenerMarcas();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final allBrands = snapshot.data!;
            final displayedBrands = allBrands.take(16).toList();

            if (displayedBrands.isEmpty) {
              return const Center(
                child: Text(
                  'No se encontraron marcas',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: displayedBrands.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final brand = displayedBrands[index];
                return BrandCard(brand: brand);
              },
            );
          } else {
            return const Center(child: Text('No brands found.'));
          }
        },
      ),
    );
  }
}
