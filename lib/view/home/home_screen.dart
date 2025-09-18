import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';
import 'package:go_router/go_router.dart';
import '../../themes/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de elementos para el GridView
    final List<String> items = [
      'Parámetro 1',
      'Parámetro 2',
      'Parámetro 3',
      'Parámetro 4',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Principal')),
      drawer: const CustomDrawer(),
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
                  return GestureDetector(
                    onTap: () {
                      // Navega a la pantalla de paso de parámetros
                      context.go('/paso_parametros');
                    },
                    child: Card(
                      color: AppTheme.cardColor, // Usamos el color del tema
                      child: Center(child: Text(items[index])),
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
