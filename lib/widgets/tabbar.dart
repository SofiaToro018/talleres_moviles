import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../view/home/home_screen.dart';
import '../view/paso_parametros/paso_parametros_screen.dart';
import '../view/ciclo_vida/ciclo_vida_screen.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({super.key});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú con TabBar'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/paso_parametros');
                break;
              case 2:
                context.go('/ciclo_vida');
                break;
            }
          },
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.input), text: 'Parámetros'),
            Tab(icon: Icon(Icons.loop), text: 'Ciclo de Vida'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [HomeScreen(), PasoParametrosScreen(), CicloVidaScreen()],
      ),
    );
  }
}
