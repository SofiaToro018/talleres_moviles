import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../themes/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ítems que enviarán un parámetro y usarán distintos métodos de navegación
    final List<Map<String, String>> items = [
      {'label': 'Navegar con Go', 'param': 'Item 1', 'method': 'go'},
      {'label': 'Navegar con Push', 'param': 'Item 2', 'method': 'push'},
      {'label': 'Navegar con Replace', 'param': 'Item 3', 'method': 'replace'},
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Bienvenido al Dashboard del Taller 2',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final param = item['param']!;
                  final method = item['method']!;
                  return GestureDetector(
                    onTap: () {
                      // Selecciona método de navegación según el item
                      if (method == 'go') {
                        context.go('/detalle/$param/$method');
                      } else if (method == 'push') {
                        context.push('/detalle/$param/$method');
                      } else {
                        context.replace('/detalle/$param/$method');
                      }
                    },
                    child: Card(
                      color: AppTheme.cardColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Hero(
                        tag:
                            param, // 👈 Hero usa el parámetro como identificador único
                        child: Card(
                          color: const Color.fromARGB(255, 142, 97, 225),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              item['label']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
