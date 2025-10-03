import 'package:flutter/material.dart';
import 'package:talleres_moviles/widgets/base_drawer.dart';

class FutureView extends StatefulWidget {
  const FutureView({super.key});

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {
  String _status = "Presiona el botón para iniciar la tarea";

  // 1. Servicio simulado con Future.delayed
  Future<String> _fakeFetchData() async {
    print("Antes de la consulta");
    await Future.delayed(const Duration(seconds: 3), () {
      print("Durante la consulta");
    });

    // Aquí puedes forzar un error si quieres probar:
    // throw Exception("Error simulado en el servidor");

    return "Datos cargados correctamente";
  }

  // 2. Función que usa async/await
  void _loadData() async {
    setState(() => _status = "Cargando...");

    try {
      final result = await _fakeFetchData();
      setState(() => _status = result);
    } catch (e) {
      setState(() => _status = "Error al cargar datos");
    }

    print("Después de la consulta");
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Future / async-await',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Estado en pantalla
            Text(
              _status,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Botón que dispara el proceso
            ElevatedButton(
              onPressed: _loadData,
              child: const Text("Cargar datos"),
            ),
          ],
        ),
      ),
    );
  }
}
