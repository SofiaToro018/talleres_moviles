import 'package:flutter/material.dart';
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
        title: const Text('Taller 2 - Navegación'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.input), text: 'Parámetros'),
            Tab(icon: Icon(Icons.loop), text: 'Ciclo de Vida'),
          ],
        ),
      ),
      // 🔹 Drawer integrado aquí
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                _tabController.index = 0; // Cambia al tab Home
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.input),
              title: const Text('Paso de Parámetros'),
              onTap: () {
                _tabController.index = 1; // Cambia al tab Parámetros
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.loop),
              title: const Text('Ciclo de Vida'),
              onTap: () {
                _tabController.index = 2; // Cambia al tab Ciclo de Vida
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HomeScreen(),
          PasoParametrosScreen(),
          CicloVidaScreen(),
        ],
      ),
    );
  }
}
