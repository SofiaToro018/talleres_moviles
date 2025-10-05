import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talleres_moviles/themes/app_theme.dart';
import '../../widgets/base_drawer.dart';

// --- FUNCIÓN PESADA ---
Future<Map<String, dynamic>> heavySumTask(int n) async {
  final stopwatch = Stopwatch()..start();
  var sum = 0;
  for (var i = 1; i <= n; i++) {
    sum += i;
  }
  stopwatch.stop();

  return {'n': n, 'sum': sum, 'timeMs': stopwatch.elapsedMilliseconds};
}

class IsolateView extends StatefulWidget {
  const IsolateView({super.key});

  @override
  State<IsolateView> createState() => _IsolateViewState();
}

class _IsolateViewState extends State<IsolateView> {
  bool _running = false;
  String _status = 'Listo';
  String? _resultText;
  final TextEditingController _controller = TextEditingController(
    text: '50000000',
  );

  final List<String> _logs = [];

  void _addLog(String text) {
    setState(() {
      _logs.insert(0, '${DateTime.now().toIso8601String()} - $text');
      if (_logs.length > 200) _logs.removeLast();
    });
  }

  Future<void> _startTask() async {
    if (_running) return;
    final input = int.tryParse(_controller.text.replaceAll(',', '')) ?? 0;
    if (input <= 0) {
      setState(() => _status = 'Ingrese un número válido mayor que 0');
      return;
    }

    print('⏳ Iniciando tarea pesada con n=$input');
    setState(() {
      _running = true;
      _status = 'Ejecutando tarea pesada...';
      _resultText = null;
    });
    _addLog('Inicio de tarea con n=$input');

    try {
      print('🚀 Ejecutando en isolate...');
      // compute() usa isolate interno si está disponible o fallback en web
      final result = await compute(heavySumTask, input);
      setState(() {
        _status = 'Completado correctamente';
        _resultText =
            'Suma(1..${result['n']}) = ${result['sum']}\nTiempo: ${result['timeMs']} ms';
        _running = false;
      });
      print('✅ Tarea completada. Tiempo: ${result['timeMs']} ms');
      _addLog('Tarea completada. Tiempo: ${result['timeMs']} ms');
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _running = false;
      });
      print('❌ Error en ejecución: $e');
      _addLog('Error en ejecución: $e');
    }
  }

  void _cancelTask() {
    setState(() {
      _running = false;
      _status = 'Cancelado';
    });
    print('🛑 Tarea cancelada por el usuario');
    _addLog('Tarea cancelada');
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Isolate - Tarea pesada',
      appBar: AppBar(
        title: const Text('Isolate - Tarea pesada'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor, // Usa el color de fondo del theme
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: AppTheme.primaryColor.withOpacity(0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Parámetros de la tarea',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText:
                                    'Número de iteraciones (ej. 50000000)',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _running ? null : _startTask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[200],
                            ),
                            child: const Text('Iniciar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _running ? _cancelTask : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estado: $_status',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      if (_resultText != null)
                        SelectableText(_resultText!)
                      else
                        const Text('Aún no hay resultado.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _addLog('Evento manual'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                              ),
                              child: const Text('Añadir log'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => setState(() => _logs.clear()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                              child: const Text('Limpiar'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            itemCount: _logs.length,
                            itemBuilder: (context, index) {
                              return Text(
                                _logs[index],
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
