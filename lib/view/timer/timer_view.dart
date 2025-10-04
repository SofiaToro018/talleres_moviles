import 'dart:async';
import 'package:flutter/material.dart';
import 'package:talleres_moviles/themes/app_theme.dart';
import '../../widgets/base_drawer.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  Timer? _timer;
  int _milliseconds = 0;
  bool _isRunning = false;

  // getters de estado para habilitar botones
  bool get canStart => !_isRunning && _milliseconds == 0;
  bool get canPause => _isRunning;
  bool get canResume => !_isRunning && _milliseconds > 0;
  bool get canReset => _milliseconds > 0;

  void _startTimer() {
    if (!canStart) return;
    setState(() => _isRunning = true);
    print("Cronómetro iniciado");
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() => _milliseconds += 100);
    });
  }

  void _pauseTimer() {
    if (!canPause) return;
    _timer?.cancel();
    setState(() => _isRunning = false);
    print("Cronómetro pausado");
  }

  void _resumeTimer() {
    if (!canResume) return;
    setState(() => _isRunning = true);
    print("Cronómetro reanudado");
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() => _milliseconds += 100);
    });
  }

  void _resetTimer() {
    if (!canReset) return;
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _milliseconds = 0;
    });
    print("Cronómetro reiniciado");
  }

  String _formatTime(int milliseconds) {
    final int centiseconds = (milliseconds ~/ 10) % 100;
    final int seconds = (milliseconds ~/ 1000) % 60;
    final int minutes = (milliseconds ~/ 60000) % 60;
    // formato: MM:SS.CS (ej. 00:12.34)
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}.'
        '${centiseconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    print("Timer cancelado al salir de la vista");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Timer - Cronómetro',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // tarjeta del cronómetro
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.95),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _formatTime(_milliseconds),
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'MM:SS.CS',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // estado
            Text(
              _isRunning ? 'EN EJECUCIÓN' : 'DETENIDO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _isRunning
                    ? Colors.greenAccent.shade200
                    : Colors.purpleAccent.shade100,
              ),
            ),

            const SizedBox(height: 20),

            // botones horizontales
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Iniciar
                ElevatedButton.icon(
                  onPressed: canStart ? _startTimer : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Pausar
                ElevatedButton.icon(
                  onPressed: canPause ? _pauseTimer : null,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pausar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor.withOpacity(0.9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Reanudar
                ElevatedButton.icon(
                  onPressed: canResume ? _resumeTimer : null,
                  icon: const Icon(Icons.play_circle),
                  label: const Text('Reanudar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Reiniciar
                ElevatedButton.icon(
                  onPressed: canReset ? _resetTimer : null,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reiniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
