import 'package:flutter/material.dart';
import 'package:talleres_moviles/widgets/base_drawer.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Timer',
      body: const Center(
        child: Text(
          'Aquí va el contenido del Timer',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
