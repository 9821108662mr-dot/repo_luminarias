// lib/widgets/brand_card.dart
import 'package:flutter/material.dart';
import '../models/brand.dart';
import '../config/app_config.dart';
import '../screens/details_screen.dart';
import '../data/api_service.dart';

class BrandCard extends StatelessWidget {
  final Brand brand;

  const BrandCard({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
        try {
          final fixtures = await ApiService.obtenerFixturesPorMarca(brand.name);
          if (!context.mounted) return;
          Navigator.pop(context); // Dismiss loading dialog
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailsScreen(brandName: brand.name, fixturesRaw: fixtures),
            ),
          );
        } catch (e) {
          if (!context.mounted) return;
          Navigator.pop(context); // Dismiss loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cargar fixtures: $e')),
          );
        }
      },
      child: Card(
        color: const Color(AppConfig.cardColorValue),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Image.network(
                    brand.logo,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                brand.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
