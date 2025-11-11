import 'package:flutter/material.dart';
import 'details_screen.dart';

class MarcasScreen extends StatelessWidget {
  const MarcasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color azulFondo = Color(0xFF0D1B2A);
    const Color azulMedio = Color(0xFF1B263B);
    const Color blanco = Colors.white;

    final List<Map<String, String>> marcas = [
      {
        'nombre': 'Spotlight',
        'imagen': 'assets/images/spotlight.png',
        'descripcion': 'Luminarias teatrales italianas',
      },
      {
        'nombre': 'Chauvet',
        'imagen': 'assets/images/chauvet.png',
        'descripcion': 'Iluminación para espectáculos y eventos',
      },
      {
        'nombre': 'Claypaky',
        'imagen': 'assets/images/claypaky.png',
        'descripcion': 'Innovación italiana en luces de escenario',
      },
      {
        'nombre': 'ProtonTech',
        'imagen': 'assets/images/protontech.png',
        'descripcion': 'Soluciones profesionales para eventos',
      },
      {
        'nombre': 'Robe Lighting',
        'imagen': 'assets/images/robe.png',
        'descripcion': 'Líder en iluminación para giras y teatros',
      },
      {
        'nombre': 'Vari-Lite',
        'imagen': 'assets/images/varilite.png',
        'descripcion': 'Referente en tecnología de iluminación',
      },
      {
        'nombre': 'Elation Lighting',
        'imagen': 'assets/images/elation.png',
        'descripcion': 'Iluminación profesional de alto rendimiento',
      },
      {
        'nombre': 'GLP',
        'imagen': 'assets/images/glp.png',
        'descripcion': 'German Light Products – innovación LED',
      },
      {
        'nombre': 'Martin Professional',
        'imagen': 'assets/images/martin.png',
        'descripcion': 'Diseño danés para escenarios modernos',
      },
      {
        'nombre': 'High End Systems',
        'imagen': 'assets/images/highend.png',
        'descripcion': 'Alta tecnología para producciones visuales',
      },
      {
        'nombre': 'ETC',
        'imagen': 'assets/images/etc.png',
        'descripcion': 'Control y calidad en iluminación escénica',
      },
      {
        'nombre': 'Prolights',
        'imagen': 'assets/images/prolights.png',
        'descripcion': 'Soluciones italianas para iluminación profesional',
      },
    ];

    return Scaffold(
      backgroundColor: azulFondo,
      appBar: AppBar(
        backgroundColor: azulMedio,
        title: const Text(
          'Marcas de Luminarias',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: blanco,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF1B263B), Color(0xFF415A77)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: marcas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final marca = marcas[index];
            return _buildMarcaCard(context, marca);
          },
        ),
      ),
    );
  }

  Widget _buildMarcaCard(BuildContext context, Map<String, String> marca) {
    const Color azulClaro = Color(0xFF1B263B);
    const Color celeste = Color(0xFF00B4D8);
    const Color blanco = Colors.white;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              brandName: marca['nombre']!,
              marca: marca['nombre']!,
              fixtures: const [],
              luminaria: null,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: azulClaro.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: celeste.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: celeste.withOpacity(0.2), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    marca['imagen']!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.lightbulb_outline,
                      size: 60,
                      color: celeste.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              marca['nombre']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: blanco,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                marca['descripcion']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: blanco.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
