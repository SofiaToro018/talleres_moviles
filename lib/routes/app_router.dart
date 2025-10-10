import 'package:go_router/go_router.dart';
import '../view/paso_parametros/detalle_screen.dart';
import '../view/ciclo_vida/ciclo_vida_screen.dart';
import '../view/paso_parametros/paso_parametros_screen.dart';

import '../view/home/home_screen.dart';
import '../view/future/future_view.dart';
import '../view/isolate/isolate_view.dart';
import '../view/timer/timer_view.dart';

import '../view/rick_and_morty/character_detail_screen.dart';
import '../view/rick_and_morty/character_list_screen.dart';

import '../models/character_model.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(), // Usa HomeView
    ),
    // Rutas para el paso de parámetros
    GoRoute(
      path: '/paso_parametros',
      name: 'paso_parametros',
      builder: (context, state) => const PasoParametrosScreen(),
    ),

    // !Ruta para el detalle con parámetros
    GoRoute(
      path:
          '/detalle/:parametro/:metodo', //la ruta recibe dos parametros los " : " indican que son parametros
      builder: (context, state) {
        //*se capturan los parametros recibidos
        // declarando las variables parametro y metodo
        // es final porque no se van a modificar
        final parametro = state.pathParameters['parametro']!;
        final metodo = state.pathParameters['metodo']!;
        return DetalleScreen(parametro: parametro, metodoNavegacion: metodo);
      },
    ),
    //!Ruta para el ciclo de vida
    GoRoute(
      path: '/ciclo_vida',
      builder: (context, state) => const CicloVidaScreen(),
    ),
    //!Ruta para FUTURE
    GoRoute(
      path: '/future',
      name: 'future',
      builder: (context, state) => const FutureView(),
    ),
    //!Ruta para ISOLATE
    GoRoute(
      path: '/isolate',
      name: 'isolate',
      builder: (context, state) => const IsolateView(),
    ),
    //!Ruta para TIMER
    GoRoute(
      path: '/timer',
      name: 'timer',
      builder: (context, state) => const TimerView(),
    ),
    // Ruta del listado de personajes
    GoRoute(
      path: '/rickandmorty',
      name: 'rickandmorty',
      builder: (context, state) => const CharacterListScreen(),
    ),

    // Ruta del detalle del personaje
    GoRoute(
      path: '/character_detail/:id',
      name: 'character_detail',
      builder: (context, state) {
        final character = state.extra as Character;
        return CharacterDetailScreen(character: character);
      },
    ),
  ],
);
