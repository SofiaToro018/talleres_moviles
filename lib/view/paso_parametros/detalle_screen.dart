import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetalleScreen extends StatefulWidget {
  final String parametro;
  final String metodoNavegacion;

  const DetalleScreen({
    super.key,
    required this.parametro,
    required this.metodoNavegacion,
  });

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  // Se ejecuta una sola vez cuando el widget se inserta en el árbol
  @override
  void initState() {
    super.initState();
    print('initState: Se ejecuta al crear el widget');
  }

  // Se ejecuta cuando cambian las dependencias del widget
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies: Se ejecuta cuando cambian dependencias');
  }

  // Se ejecuta cada vez que se construye el widget
  @override
  Widget build(BuildContext context) {
    print('build: Se ejecuta al construir el widget');
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Parámetro recibido: ${widget.parametro}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Método de navegación: ${widget.metodoNavegacion}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _volverAtras(context),
              child: const Text("Volver"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  print('setState: Se ejecuta al actualizar el estado');
                });
              },
              child: const Text("Demostrar setState"),
            ),
          ],
        ),
      ),
    );
  }

  // Se ejecuta cuando el widget se elimina del árbol
  @override
  void dispose() {
    print('dispose: Se ejecuta al eliminar el widget');
    super.dispose();
  }

  void _volverAtras(BuildContext context) {
    if (widget.metodoNavegacion == 'push') {
      context.pop();
    } else {
      context.go('/paso_parametros');
    }
  }
}
