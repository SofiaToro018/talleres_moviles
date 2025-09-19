import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// DetalleScreen
/// Recibe un parámetro y el método de navegación (go, push, replace)
/// Muestra ambos valores y permite regresar según el método usado.

/// También recibe un segundo parametro, el metodo de navegación (go, push, replace)
/// este con el fin de poder redirigir manualmente a la pantalla anterior.

class DetalleScreen extends StatelessWidget {
  final String parametro; // Parametro recibido desde la pantalla anterior
  final String metodoNavegacion; // el metodo de navegación

  //*en el contructor se reciben los parametros para poder mostrarlos en pantalla
  const DetalleScreen({
    super.key,
    required this.parametro,
    required this.metodoNavegacion,
  });

  // metodo para volver a la pantalla anterior
  // *void es un metodo que no retorna nada
  void _volverAtras(BuildContext context) {
    if (metodoNavegacion == 'push') {
      // push() mantiene el stack → se puede regresar con pop()
      context.pop();
    } else {
      // go() y replace() destruyen la ruta previa → redirigimos manualmente
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: parametro, // 👈 mismo tag que en Home
              child: Material(
                color: Colors.transparent,
                child: Text(
                  parametro,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 142, 97, 225),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Método usado: $metodoNavegacion",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _volverAtras(context),
              child: const Text("Volver"),
            ),
          ],
        ),
      ),
    );
  }
}
