import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onSelectMarca; // Callback para cuando se selecciona una marca
  final List<String> marcas;
  final String? selectedMarca;

  const Sidebar({
    super.key,
    required this.marcas,
    required this.onSelectMarca,
    this.selectedMarca,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100],
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
            ),
            child: const Center(
              child: Text(
                'Luminarias',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          // 🔍 Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar marca...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) {
                // filtrar marcas (a implementar desde dashboard)
              },
            ),
          ),
          const Divider(),

          // 📋 Lista de marcas
          Expanded(
            child: ListView.builder(
              itemCount: marcas.length,
              itemBuilder: (context, index) {
                final marca = marcas[index];
                final isSelected = marca == selectedMarca;

                return ListTile(
                  leading: const Icon(Icons.lightbulb_outline),
                  title: Text(
                    marca,
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () => onSelectMarca(marca),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
