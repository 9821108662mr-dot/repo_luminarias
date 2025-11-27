// lib/models/brand.dart
class Brand {
  final String name;
  final String logo;
  final String description;

  Brand({
    required this.name,
    required this.logo,
    required this.description,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      name: json['name'] as String,
      logo: json['logo'] as String,
      description: json['description'] as String,
    );
  }
}
