import 'package:flutter/material.dart';
import '../routes/app_router.dart';
import '../themes/app_theme.dart'; // Importa el tema
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //go_router para navegacion
    return MaterialApp.router(
      theme:
          AppTheme.lightTheme, //thema personalizado y permamente en toda la app
      title: 'Flutter - UCEVA', // Usa el tema personalizado.
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false, // Usa el router configurado
    );
  }
}
