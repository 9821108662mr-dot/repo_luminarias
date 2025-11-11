import 'package:flutter/material.dart';
import '../screens/details_screen.dart';
import '../models/fixture.dart';

final List<Map<String, dynamic>> todasLasMarcas = [
  {"nombre": "Spotlight", "descripcion": "Luminarias teatrales italianas", "logo": "assets/images/spotlight.png"},
  {"nombre": "Chauvet", "descripcion": "Iluminación para espectáculos y eventos", "logo": "assets/images/chauvet.png"},
  {"nombre": "Claypaky", "descripcion": "Innovación italiana en luces de escenario", "logo": "assets/images/claypaky.png"},
  {"nombre": "ProtonTech", "descripcion": "Soluciones profesionales para eventos", "logo": "assets/images/protontech.png"},
  {"nombre": "Vari-Lite", "descripcion": "Pioneros en cabezas móviles", "logo": "assets/images/varilite.png"},
  {"nombre": "Robe Lighting", "descripcion": "Tecnología de iluminación checa", "logo": "assets/images/robe.png"},
  {"nombre": "Martin Professional", "descripcion": "Calidad danesa para escenarios", "logo": "assets/images/martin.png"},
  {"nombre": "Elation Lighting", "descripcion": "Iluminación para conciertos y clubs", "logo": "assets/images/elation.png"},
  {"nombre": "Ayrton", "descripcion": "Diseño francés en luces avanzadas", "logo": "assets/images/ayrton.png"},
  {"nombre": "High End Systems", "descripcion": "Innovación americana en luminarias", "logo": "assets/images/highend.png"},
  {"nombre": "GLP", "descripcion": "Diseño alemán en sistemas de luz", "logo": "assets/images/glp.png"},
  {"nombre": "Prolights", "descripcion": "Calidad italiana en iluminación", "logo": "assets/images/prolights.png"},
  {"nombre": "ETC", "descripcion": "Control y luminarias teatrales", "logo": "assets/images/etc.png"},
  {"nombre": "MOKA SFX", "descripcion": "Efectos especiales para eventos", "logo": "assets/images/moka.png"},
  {"nombre": "Showco", "descripcion": "Equipos clásicos de iluminación", "logo": "assets/images/showco.png"},
  {"nombre": "Lite Tek", "descripcion": "Iluminación compacta y eficiente", "logo": "assets/images/litetek.png"},
  {"nombre": "Apligth / Cymproled", "descripcion": "Marcas nacionales de iluminación", "logo": "assets/images/apligth.png"},
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _busqueda = '';
  List<Map<String, dynamic>> _marcasFiltradas = List.from(todasLasMarcas);

  void _filtrarMarcas(String texto) {
    setState(() {
      _busqueda = texto.toLowerCase();
      _marcasFiltradas = todasLasMarcas
          .where((m) => m["nombre"].toLowerCase().contains(_busqueda))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),

            // 🏷️ Encabezado
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber, size: 30),
                SizedBox(width: 8),
                Text(
                  'Catálogo de marcas PRO-MG',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Descubre los fabricantes líderes en iluminación profesional',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 16),

            // 🔍 Buscador con autocompletado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue value) {
                  if (value.text.isEmpty) return const Iterable<String>.empty();
                  return todasLasMarcas
                      .map((m) => m["nombre"] as String)
                      .where((nombre) => nombre.toLowerCase().contains(value.text.toLowerCase()));
                },
                onSelected: (seleccion) => _filtrarMarcas(seleccion),
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  controller.text = _busqueda;
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: _filtrarMarcas,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '🔍 Buscar marca (ej. Robe, Claypaky...)',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 📦 Grid
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int columnas = 3;
                  if (constraints.maxWidth > 1000) {
                    columnas = 6;
                  } else if (constraints.maxWidth > 600) {
                    columnas = 4;
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnas,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _marcasFiltradas.length,
                    itemBuilder: (context, index) {
                      final marca = _marcasFiltradas[index];
                      return _buildMarcaCard(context, marca);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarcaCard(BuildContext context, Map<String, dynamic> marca) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 1.0, end: 1.0),
      builder: (context, scale, child) {
        return MouseRegion(
          onEnter: (_) => setState(() => scale = 1.05),
          onExit: (_) => setState(() => scale = 1.0),
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailsScreen(
                      marca: marca["nombre"],
                      fixtures: [
                        Fixture(
                          nombre: "Modelo de ejemplo",
                          marca: marca["nombre"],
                          tipo: "Spot",
                          imagen: marca["logo"], manual: '',
                        ),
                      ], brandName: '', luminaria: null,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white.withOpacity(0.1),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          marca["logo"],
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        marca["nombre"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        marca["descripcion"],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
