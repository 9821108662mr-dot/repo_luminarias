import 'package:flutter/material.dart';
import 'package:repo_luminarias/models/fixture.dart';
import 'package:url_launcher/url_launcher.dart';

// Pantalla de detalle de las luminarias
class DetailsScreen extends StatelessWidget {
  final String brandName;

  const DetailsScreen({
    super.key,
    required this.brandName, required String marca, required List<Fixture> fixtures, required luminaria,
  });

  @override
  Widget build(BuildContext context) {
    // Lista temporal de luminarias (puedes conectar a tu base o JSON después)
    final List<Map<String, String>> luminarias = [
      {
        'nombre': 'Beam 230',
        'imagen': 'assets/luminarias/beam230.jpg',
        'descripcion':
            'Luminaria tipo Beam con lámpara de 230W, ideal para eventos y escenarios de gran escala.',
        'pdf': 'assets/descargas/BEAM-230.pdf',
        'libreria': 'assets/librerias/beam230.lib',
      },
      {
        'nombre': 'Spot 350',
        'imagen': 'assets/luminarias/spot350.jpg',
        'descripcion':
            'Spot 350 con mezcla de color CMY y zoom motorizado. Perfecto para teatro o eventos corporativos.',
        'pdf': 'assets/descargas/SPOT-350.pdf',
        'libreria': 'assets/librerias/spot350.lib',
      },
      {
        'nombre': 'Wash 1000',
        'imagen': 'assets/luminarias/wash1000.jpg',
        'descripcion':
            'Luminaria Wash de alta potencia con temperatura de color variable y mezcla RGBW.',
        'pdf': 'assets/descargas/WASH-1000.pdf',
        'libreria': 'assets/librerias/wash1000.lib',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Luminarias - $brandName'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 tarjetas por fila
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: luminarias.length,
          itemBuilder: (context, index) {
            final item = luminarias[index];
            return FlipCard(
              nombre: item['nombre']!,
              imagen: item['imagen']!,
              descripcion: item['descripcion']!,
              pdfUrl: item['pdf']!,
              libreriaUrl: item['libreria']!,
            );
          },
        ),
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  final String nombre;
  final String imagen;
  final String descripcion;
  final String pdfUrl;
  final String libreriaUrl;

  const FlipCard({
    super.key,
    required this.nombre,
    required this.imagen,
    required this.descripcion,
    required this.pdfUrl,
    required this.libreriaUrl,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  Future<void> _abrirArchivo(String path) async {
    final Uri url = Uri.parse(path);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el archivo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * 3.1416;
          final transform = Matrix4.rotationY(angle);
          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: _controller.value < 0.5
                ? _buildFront()
                : Transform(
                    transform: Matrix4.rotationY(3.1416),
                    alignment: Alignment.center,
                    child: _buildBack(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: Colors.blue.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.asset(
                widget.imagen,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.lightbulb_outline,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade600.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
            ),
            child: Text(
              widget.nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return Card(
      color: Colors.blue.shade700,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.descripcion,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _abrirArchivo(widget.pdfUrl),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Ver PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _abrirArchivo(widget.libreriaUrl),
              icon: const Icon(Icons.download),
              label: const Text('Descargar Librería'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
