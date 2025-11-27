// lib/models/fixture.dart
class Fixture {
  final String nombre;
  final String tipo;
  final String imagen;
  final String marca;
  final String manual;   // ruta al PDF (puede ser /static/... o assets/...)
  final String libreria; // ruta a la librería (opcional)

  Fixture({
    required this.nombre,
    required this.tipo,
    required this.imagen,
    required this.marca,
    this.manual = '',
    this.libreria = '',
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      nombre: json["nombre"]?.toString() ?? "",
      tipo: json["tipo"]?.toString() ?? "",
      imagen: json["imagen"]?.toString() ?? "",
      marca: json["marca"]?.toString() ?? "",
      manual: json["manual"]?.toString() ?? "",
      libreria: json["libreria"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "tipo": tipo,
        "imagen": imagen,
        "marca": marca,
        "manual": manual,
        "libreria": libreria,
      };
}
