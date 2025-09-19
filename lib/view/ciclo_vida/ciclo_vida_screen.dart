import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Pantalla para demostrar el ciclo de vida de un StatefulWidget.
class CicloVidaScreen extends StatefulWidget {
  const CicloVidaScreen({super.key});

  @override
  State<CicloVidaScreen> createState() => CicloVidaScreenState();
}

class CicloVidaScreenState extends State<CicloVidaScreen> {
  String texto = "Texto inicial 🟢";

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("🟢 initState() -> La pantalla se ha inicializado");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kDebugMode) {
      print("🟡 didChangeDependencies() -> Tema actual");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("🔵 build() -> Construyendo la pantalla");
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Ciclo de Vida en Flutter (UCEVA)",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(texto, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: actualizarTexto,
              child: const Text("Actualizar Texto"),
            ),
          ],
        ),
      ),
    );
  }

  void actualizarTexto() {
    setState(() {
      texto = "Texto actualizado 🟠";
      if (kDebugMode) {
        print("🟠 setState() -> Estado actualizado");
      }
    });
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print("🔴 dispose() -> La pantalla se ha destruido");
    }
    super.dispose();
  }
}
