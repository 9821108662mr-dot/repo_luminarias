import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb

class StorageService {
  static final _storage = FirebaseStorage.instance;
  static final _picker = ImagePicker();

  // Seleccionar imagen
  static Future<XFile?> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024, // Reducir tamaño para optimizar
        maxHeight: 1024,
        imageQuality: 85,
      );
      return pickedFile;
    } catch (e) {
      print("Error al seleccionar imagen: $e");
      return null;
    }
  }

  // Subir imagen y obtener URL
  static Future<String?> uploadImage(XFile file, String folder) async {
    try {
      // Crear referencia única
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final ref = _storage.ref().child('$folder/$fileName');

      // Subir archivo
      if (kIsWeb) {
        // En web usamos putData con los bytes
        final bytes = await file.readAsBytes();
        await ref.putData(bytes, SettableMetadata(contentType: file.mimeType));
      } else {
        // En móvil usamos putFile
        await ref.putFile(File(file.path));
      }

      // Obtener URL
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error al subir imagen: $e");
      return null;
    }
  }
}
