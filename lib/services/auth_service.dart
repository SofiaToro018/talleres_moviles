import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_models.dart';

class AuthService with ChangeNotifier {
  final storage = const FlutterSecureStorage();
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isAuthenticated => _token != null;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Base URL y endpoints
  String get baseUrl => 'https://parking.visiontic.com.co/api';
  String get loginEndpoint => '$baseUrl/login';
  String get registerEndpoint => '$baseUrl/users';

  /// -----------------------------------------------------
  /// 🟢 LOGIN
  /// -----------------------------------------------------
  Future<bool> login(LoginRequest request) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('🔵 Intentando login a: $loginEndpoint');

      final response = await http
          .post(
            Uri.parse(loginEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                'Tiempo de espera agotado. Verifica tu conexión a internet.',
              );
            },
          );

      print('🔵 Respuesta del servidor - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🔵 Datos recibidos: $data');

        // El servidor devuelve 'token', no 'access_token'
        final token = data['token'] ?? data['access_token'];

        if (token == null) {
          throw Exception('No se recibió token del servidor');
        }

        // Guardamos token de forma segura
        await storage.write(key: 'access_token', value: token);
        _token = token;

        // Extraer datos del usuario de la respuesta
        final userData = data['user'] ?? {};
        _user = User(
          name: userData['name'] ?? 'Usuario',
          email: userData['email'] ?? request.email,
        );

        // Guardamos nombre/email en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', _user!.name);
        await prefs.setString('user_email', _user!.email);

        print(
          '✅ Login exitoso - Usuario: ${_user!.name}, Email: ${_user!.email}',
        );

        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        final body = jsonDecode(response.body);
        _errorMessage = body['message'] ?? 'Error al iniciar sesión';
        print('❌ Error del servidor: $_errorMessage');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on http.ClientException catch (e) {
      _errorMessage =
          'No se puede conectar al servidor. Verifica:\n'
          '1. Conexión a internet\n'
          '2. Permisos de la app\n'
          '3. URL del servidor';
      print('❌ ClientException: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    } on Exception catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
      print('❌ Exception: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      print('❌ Error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// -----------------------------------------------------
  /// 🟣 REGISTRO
  /// -----------------------------------------------------
  Future<bool> register(RegisterRequest request) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('🟣 Intentando registro a: $registerEndpoint');

      final response = await http
          .post(
            Uri.parse(registerEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                'Tiempo de espera agotado. Verifica tu conexión a internet.',
              );
            },
          );

      print('🟣 Respuesta del servidor - Status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        print('✅ Registro exitoso');
        return true;
      } else {
        final body = jsonDecode(response.body);
        _errorMessage = body['message'] ?? 'Error al registrar usuario';
        print('❌ Error del servidor: $_errorMessage');
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on http.ClientException catch (e) {
      _errorMessage =
          'No se puede conectar al servidor. Verifica:\n'
          '1. Conexión a internet\n'
          '2. Permisos de la app\n'
          '3. URL del servidor';
      print('❌ ClientException: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    } on Exception catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
      print('❌ Exception: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      print('❌ Error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// -----------------------------------------------------
  /// 🟡 CARGAR SESIÓN LOCAL
  /// -----------------------------------------------------
  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    final email = prefs.getString('user_email');
    final token = await storage.read(key: 'access_token');

    if (name != null && email != null && token != null) {
      _user = User(name: name, email: email);
      _token = token;
    }
    notifyListeners();
  }

  /// -----------------------------------------------------
  /// 🔴 LOGOUT
  /// -----------------------------------------------------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await storage.deleteAll();

    _user = null;
    _token = null;
    notifyListeners();
  }
}
