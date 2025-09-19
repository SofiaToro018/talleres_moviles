import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../themes/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de elementos para el GridView
    final List<Map<String, String>> items = [
      {'label': 'Métodos de Navegación', 'route': '/paso_parametros'},
      {'label': 'Ciclo de Vida', 'route': '/ciclo_vida'},
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Bienvenido al Dashboard del Taller 2',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () {
                      context.go(item['route']!);
                    },
                    child: Card(
                      color: AppTheme.cardColor,
                      child: Center(child: Text(item['label']!)),
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
