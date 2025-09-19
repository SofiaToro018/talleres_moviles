import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// PasoParametrosScreen - Pantalla para ingresar y enviar parámetros
/// Permite ingresar un valor y enviarlo a DetalleScreen usando go, push y replace.
/// Metodos de navegación disponibles:
/// *- go: Reemplaza toda la navegación anterior.
/// *- push: Agrega una nueva pantalla encima de la actual.
/// *- replace: Reemplaza la pantalla actual en la pila de navegación.

class PasoParametrosScreen extends StatefulWidget {
  const PasoParametrosScreen({super.key});

  @override
  State<PasoParametrosScreen> createState() => _PasoParametrosScreenState();
}

class _PasoParametrosScreenState extends State<PasoParametrosScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Navega a DetalleScreen usando el método indicado y muestra SnackBar de confirmación
  void goToDetalle(String metodo) {
    String valor = controller.text;
    if (valor.isEmpty) return;
    switch (metodo) {
      case 'go':
        context.go('/detalle/$valor/$metodo');
        break;
      case 'push':
        context.push('/detalle/$valor/$metodo');
        break;
      case 'replace':
        context.replace('/detalle/$valor/$metodo');
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Parámetro enviado: $valor'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.purple[200],
      ),
    );
  }

  /// Limpia el campo de texto y muestra SnackBar de confirmación
  void limpiarCampo() {
    controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Campo limpiado'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.purple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paso de Parámetros')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ingrese un valor',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => goToDetalle('go'),
              child: const Text('Ir con Go'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => goToDetalle('push'),
              child: const Text('Ir con Push'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => goToDetalle('replace'),
              child: const Text('Ir con Replace'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: limpiarCampo,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.cleaning_services),
        tooltip: 'Limpiar campo',
      ),
    );
  }
}
