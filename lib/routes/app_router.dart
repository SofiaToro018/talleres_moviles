import 'package:go_router/go_router.dart';
import '../widgets/tabbar.dart';
import '../view/paso_parametros/detalle_screen.dart';
import '../view/ciclo_vida/ciclo_vida_screen.dart';
import '../view/home/home_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TabBarWidget()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/detalle/:parametro/:metodo',
      builder: (context, state) {
        final parametro = state.pathParameters['parametro']!;
        final metodo = state.pathParameters['metodo']!;
        return DetalleScreen(parametro: parametro, metodoNavegacion: metodo);
      },
    ),
    GoRoute(
      path: '/ciclo_vida',
      builder: (context, state) => const CicloVidaScreen(),
    ),
  ],
);
