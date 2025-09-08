import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taller 1 - Laura Sofía Toro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Variable para el título de la AppBar
  String _titulo = "Hola, Flutter";

  // Método para cambiar el título de la AppBar
  void _cambiarTitulo() {
    setState(() {
      if (_titulo == "Hola, Flutter") {
        _titulo = "¡Título cambiado!";
      } else {
        _titulo = "Hola, Flutter";
      }
    });

    // Muestra un SnackBar al cambiar el título
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Título actualizado"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con título variable
      appBar: AppBar(
        title: Text(_titulo),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón principal para cambiar el título
            ElevatedButton(
              onPressed: _cambiarTitulo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text("Cambiar título de la AppBar"),
            ),
          ],
        ),
      ),
    );
  }
}
