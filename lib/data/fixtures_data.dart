// lib/data/fixtures_data.dart
// Mapa local con la estructura: marca -> lista de fixtures (Maps compatibles con Fixture.fromJson)
final Map<String, List<Map<String, dynamic>>> fixturesData = {
  "Spotlight": [
    {
      "nombre": "Spotlight Beam 230",
      "tipo": "Beam",
      "imagen": "assets/luminarias/230beam250w.jpg",
      "manual": "assets/descargas/beam230.pdf",
      "libreria": "",
      "marca": "Spotlight",
    },
    {
      "nombre": "Spotlight Wash 500",
      "tipo": "Wash",
      "imagen": "assets/luminarias/sharpy.png",
      "manual": "assets/descargas/wash500.pdf",
      "libreria": "",
      "marca": "Spotlight",
    },
  ],
  "Chauvet": [
    {
      "nombre": "Chauvet Beam Q60",
      "tipo": "BEAM",
      "imagen": "assets/luminarias/intimidator.png",
      "manual": "assets/descargas/BeamQ60.pdf",
      "libreria": "",
      "marca": "Chauvet",
    },
  ],
  // ... pega aquí tu JSON completo si lo deseas ...
};
