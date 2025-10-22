import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talleres_moviles/themes/app_theme.dart';
import '../../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _tapScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.95),
                AppTheme.secondaryColor.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            title: const Text(
              'Consumo de API Rick and Morty',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity, // 🔹 Ocupa toda la pantalla
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, AppTheme.secondaryColor.withOpacity(0.08)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight:
                    600, // 🔹 Garantiza que el scroll tenga fondo completo
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Bienvenido al mundo Rick and Morty, podrás explorar personajes de la serie y ver detalles interesantes de cada uno.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.92, end: 1.0),
                      duration: const Duration(milliseconds: 420),
                      curve: Curves.easeOutBack,
                      builder: (context, entranceScale, child) {
                        return GestureDetector(
                          onTap: () => context.go('/rickandmorty'),
                          onTapDown: (_) => setState(() => _tapScale = 0.97),
                          onTapUp: (_) => setState(() => _tapScale = 1.0),
                          onTapCancel: () => setState(() => _tapScale = 1.0),
                          child: Transform.scale(
                            scale: entranceScale * _tapScale,
                            child: child,
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 280,
                        height: 200,
                        child: _buildFeatureCard(
                          context,
                          title: 'Listado de Personajes',
                          description: 'Explora personajes de Rick and Morty',
                          icon: Icons.list,
                          routeName: '/rickandmorty',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String routeName,
  }) {
    // Tarjeta moderna y compacta con efectos visuales mejorados
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        // Gradiente moderno y atractivo
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.9),
            AppTheme.primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          // Sombra profunda
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          // Efecto de borde brillante (glow)
          BoxShadow(
            color: AppTheme.secondaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 0),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono en círculo con fondo degradado
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                size: 36,
                color: Colors.white.withOpacity(0.95),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.white.withOpacity(0.75),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
