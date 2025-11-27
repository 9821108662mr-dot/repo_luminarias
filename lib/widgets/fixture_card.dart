// lib/widgets/fixture_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/fixture.dart';
import '../config/app_config.dart';

class FixtureCard extends StatefulWidget {
  final Fixture fixture;
  static String get backendBase => AppConfig.backendUrl;

  const FixtureCard({super.key, required this.fixture});

  @override
  State<FixtureCard> createState() => _FixtureCardState();
}

class _FixtureCardState extends State<FixtureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => _isFront = !_isFront);
  }

  String get backendBase => FixtureCard.backendBase;

  Uri _toOpenableUri(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Uri.parse(path);
    }

    // assets/descargas/file.pdf -> backend static
    if (path.startsWith('assets/descargas/')) {
      final f = path.replaceFirst('assets/descargas/', '');
      return Uri.parse('$backendBase/static/descargas/$f');
    }
    // assets/luminarias/image.png -> serve via backend static
    if (path.startsWith('assets/luminarias/')) {
      final f = path.replaceFirst('assets/luminarias/', '');
      return Uri.parse('$backendBase/static/luminarias/$f');
    }
    final f = path.replaceFirst(RegExp(r'^assets/'), '');
    return Uri.parse('$backendBase/static/$f');
  }

  Future<void> _open(String path) async {
    final uri = _toOpenableUri(path);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo abrir el recurso')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final img = widget.fixture.imagen;
    final imageWidget = img.startsWith('assets/')
        ? Image.asset(
            img,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(AppConfig.cardBackColorValue),
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.white54,
                  size: 40,
                ),
              ),
            ),
          )
        : Image.network(
            img,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(AppConfig.cardBackColorValue),
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.white54,
                  size: 40,
                ),
              ),
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: const Color(AppConfig.cardBackColorValue),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(AppConfig.accentColorValue),
                  ),
                ),
              );
            },
          );

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * 3.1416;
          final transform = Matrix4.rotationY(angle);
          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: _controller.value < 0.5
                ? _buildFront(imageWidget)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.1416),
                    child: _buildBack(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFront(Widget imageWidget) {
    return Card(
      color: const Color(AppConfig.cardColorValue),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen que ocupa toda la tarjeta
            imageWidget,
            // Franja semi-transparente en la parte inferior para el nombre
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Text(
                  widget.fixture.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Card(
      color: const Color(AppConfig.cardBackColorValue),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.fixture.nombre,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: const Text('PDF', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppConfig.accentColorValue),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                final path = widget.fixture.manual.isNotEmpty
                    ? widget.fixture.manual
                    : '';
                if (path.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PDF no disponible')),
                  );
                } else {
                  _open(path);
                }
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Librería', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppConfig.accentColorValue),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                final path = widget.fixture.libreria.isNotEmpty
                    ? widget.fixture.libreria
                    : '';
                if (path.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Librería no disponible')),
                  );
                } else {
                  _open(path);
                }
              },
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: _toggle,
              child: const Text(
                'Voltear',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
