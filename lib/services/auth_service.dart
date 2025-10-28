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
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];

        // Guardamos token de forma segura
        await storage.write(key: 'access_token', value: token);
        _token = token;

        // Si el backend devuelve info del usuario, la guardamos
        // (de lo contrario podrías hacer una petición adicional para obtenerla)
        _user = User(
          name: data['user']?['name'] ?? 'Unknown',
          email: data['user']?['email'] ?? request.email,
        );

        // Guardamos nombre/email en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', _user!.name);
        await prefs.setString('user_email', _user!.email);

        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        final body = jsonDecode(response.body);
        _errorMessage = body['message'] ?? 'Error al iniciar sesión';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: $e';
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
      final response = await http.post(
        Uri.parse(registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        final body = jsonDecode(response.body);
        _errorMessage = body['message'] ?? 'Error al registrar usuario';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: $e';
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
