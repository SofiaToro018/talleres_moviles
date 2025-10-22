import 'package:flutter/material.dart';
import 'custom_drawer.dart';

class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  final PreferredSizeWidget? appBar;

  const BaseView({
    super.key,
    required this.title,
    required this.body,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(title: Text(title)),
      drawer: const CustomDrawer(), // Drawer persistente para todas las vistas
      body: body,
    );
  }
}
