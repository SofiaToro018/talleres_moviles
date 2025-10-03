import 'package:flutter/material.dart';

class IsolateView extends StatefulWidget {
  const IsolateView({super.key});

  @override
  State<IsolateView> createState() => _IsolateViewState();
}

class _IsolateViewState extends State<IsolateView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isolate Tarea Pesada')),
      body: const Center(
        child: Text(
          'Aquí va el contenido de Isolate Tarea Pesada',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
