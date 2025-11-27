import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/api_service.dart';
import '../data/auth_service.dart';
import '../data/storage_service.dart';
import '../models/brand.dart';

class AddFixtureScreen extends StatefulWidget {
  const AddFixtureScreen({super.key});

  @override
  State<AddFixtureScreen> createState() => _AddFixtureScreenState();
}

class _AddFixtureScreenState extends State<AddFixtureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tipoController = TextEditingController();
  final _libreriaController = TextEditingController();
  final _brandController =
      TextEditingController(); // Opcional: Dropdown si cargamos marcas

  XFile? _imageFile;
  bool _isLoading = false;
  List<Brand> _brands = [];
  String? _selectedBrand;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    try {
      final brands = await ApiService.obtenerMarcas();
      setState(() {
        _brands = brands;
        if (_brands.isNotEmpty) {
          _selectedBrand = _brands.first.name;
        }
      });
    } catch (e) {
      print("Error loading brands: $e");
    }
  }

  Future<void> _pickImage() async {
    final file = await StorageService.pickImage(ImageSource.gallery);
    if (file != null) {
      setState(() {
        _imageFile = file;
      });
    }
  }

  Future<void> _saveFixture() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una imagen')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception("No hay sesión activa");
      }

      // 1. Subir imagen
      final imageUrl = await StorageService.uploadImage(
        _imageFile!,
        "luminarias",
      );
      if (imageUrl == null) throw Exception("Error al subir imagen");

      // 2. Crear fixture en backend
      final brandName = _selectedBrand ?? _brandController.text;

      final success = await ApiService.createFixture(
        _nameController.text,
        brandName,
        imageUrl,
        _tipoController.text,
        null, // manualUrl es opcional
        _libreriaController.text.isEmpty ? null : _libreriaController.text,
        token,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Luminaria agregada correctamente')),
          );
          Navigator.pop(context, true); // Retornar true para recargar lista
        }
      } else {
        throw Exception("Error al guardar en base de datos");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Luminaria')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagen
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    image: _imageFile != null
                        ? DecorationImage(
                            image: NetworkImage(
                              _imageFile!.path,
                            ), // En web path es blob url
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _imageFile == null
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.white54,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Nombre
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nombre del Modelo',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              // Marca Dropdown
              DropdownButtonFormField<String>(
                value: _selectedBrand,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
                items: _brands.map((b) {
                  return DropdownMenuItem(value: b.name, child: Text(b.name));
                }).toList(),
                onChanged: (val) => setState(() => _selectedBrand = val),
              ),
              const SizedBox(height: 16),

              // Tipo
              TextFormField(
                controller: _tipoController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Tipo (e.g., Beam, Spot, Wash)',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              // Libreria
              TextFormField(
                controller: _libreriaController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Librería (URL, opcional)',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _saveFixture,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar Luminaria'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
