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

import '../view/auth/login_screen.dart';
import '../view/auth/register_screen.dart';
import '../view/auth/splash_screen.dart';
import '../view/profile/profile_screen.dart';

import '../view/firebase/universidad_fb_list_view.dart';
import '../view/firebase/universidad_fb_form_view.dart';

import '../services/storage_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final storage = StorageService();
    final token = await storage.getToken();
    final isAuthenticated = token != null;

    // Si intenta acceder a /profile sin estar autenticado → redirigir a /login
    if (state.matchedLocation == '/profile' && !isAuthenticated) {
      print('🔒 Acceso denegado a /profile - Redirigiendo a /login');
      return '/login';
    }

    return null; // No hay redirección, continuar normalmente
  },
  routes: [
    // Ruta inicial - Splash que verifica autenticación
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

    // Ruta del home (antes era /)
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
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
    // Pantalla de login
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Pantalla de registro
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Pantalla de perfil (evidencia)
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    // ========== RUTAS FIREBASE - UNIVERSIDADES ==========
    // Listado de universidades
    GoRoute(
      path: '/universidadesfb',
      name: 'universidadesfb',
      builder: (context, state) => const UniversidadFbListView(),
    ),

    // Crear nueva universidad
    GoRoute(
      path: '/universidadesfb/create',
      name: 'universidadesfb_create',
      builder: (context, state) => const UniversidadFbFormView(),
    ),

    // Editar universidad existente
    GoRoute(
      path: '/universidadesfb/edit/:id',
      name: 'universidadesfb_edit',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return UniversidadFbFormView(id: id);
      },
    ),
  ],
);
