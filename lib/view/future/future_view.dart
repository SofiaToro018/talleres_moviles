import 'package:flutter/material.dart';
import 'package:talleres_moviles/widgets/base_drawer.dart';

class FutureView extends StatefulWidget {
  const FutureView({super.key});

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {
  String _status = "Presiona el botón para iniciar la tarea";
  List<String> _data = []; // Nueva lista para mostrar los datos cargados

  // 1. Servicio simulado con Future.delayed
  Future<List<String>> _fakeFetchData() async {
    print("Antes de la consulta");
    await Future.delayed(const Duration(seconds: 3), () {
      print("Durante la consulta");
    });

    // Simulamos datos que se obtendrían de un servidor
    return [
      "Elemento 1: Flutter Future",
      "Elemento 2: Async / Await",
      "Elemento 3: Simulación de datos",
      "Elemento 4: Carga completada",
    ];
  }

  // 2. Función que usa async/await
  void _loadData() async {
    setState(() {
      _status = "Cargando...";
      _data.clear();
    });

    try {
      final result = await _fakeFetchData();
      setState(() {
        _status = "Datos cargados correctamente";
        _data = result;
      });
    } catch (e) {
      setState(() {
        _status = "Error al cargar datos";
        _data.clear();
      });
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
            const SizedBox(height: 30),

            // Lista de datos (solo si hay elementos cargados)
            if (_data.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.deepPurple.shade50,
                      child: ListTile(
                        leading: const Icon(
                          Icons.bolt,
                          color: Colors.deepPurple,
                        ),
                        title: Text(
                          _data[index],
                          style: const TextStyle(fontSize: 16),
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
