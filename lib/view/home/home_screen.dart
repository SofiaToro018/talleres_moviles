import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Taller Segundo Plano')),
      drawer: const CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/future'),
              child: const Text("Future / async-await"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/timer'),
              child: const Text("Cronómetro"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/isolate'),
              child: const Text("Isolate Tarea Pesada"),
            ),
          ],
        ),
      ),
    );
  }
}
