import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../widgets/base_view.dart';

/// nos permite entender cómo funciona el ciclo de vida
/// de un StatefulWidget en Flutter.

class CicloVidaScreen extends StatefulWidget {
  const CicloVidaScreen({super.key});

  @override
  State<CicloVidaScreen> createState() => CicloVidaScreenState();
}

class CicloVidaScreenState extends State<CicloVidaScreen> {
  String texto = "texto inicial 🟢";

  // Se ejecuta una vez cuando el widget es insertado en el árbol.
  // Ideal para inicializar datos o suscripciones.
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("🟢 initState() -> La pantalla se ha inicializado");
    }
  }

  // Se ejecuta cada vez que cambian las dependencias del widget (por ejemplo, el tema).
  // Útil para obtener datos de InheritedWidget o dependencias externas.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kDebugMode) {
      print("🟡 didChangeDependencies() -> Tema actual");
    }
  }

  // Se ejecuta cada vez que el widget necesita ser reconstruido (por cambios de estado).
  // Aquí se define la interfaz visual.
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("🔵 build() -> Construyendo la pantalla");
    }
    return BaseView(
      title: "Ciclo de Vida de en flutter uceva",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

  // Actualiza el texto y llama a setState para reconstruir el widget.
  // Se usa para modificar el estado y reflejar cambios en pantalla.
  void actualizarTexto() {
    setState(() {
      texto = "Texto actualizado 🟠";
      if (kDebugMode) {
        print("🟠 setState() -> Estado actualizado");
      }
    });
  }

  // Se ejecuta cuando el widget es removido del árbol y destruido.
  // Ideal para liberar recursos, cancelar suscripciones, etc.
  @override
  void dispose() {
    if (kDebugMode) {
      print("🔴 dispose() -> La pantalla se ha destruido");
    }
    super.dispose();
  }
}
