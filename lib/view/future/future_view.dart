import 'package:flutter/material.dart';
import 'package:talleres_moviles/widgets/base_drawer.dart';

class FutureView extends StatefulWidget {
  const FutureView({super.key});

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Future / async-await',
      body: const Center(
        child: Text(
          'Aquí va el contenido de Future / async-await',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
