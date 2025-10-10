import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/character_model.dart';

class CharacterService {
  final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<List<Character>> fetchCharacters() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/character'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al cargar personajes: Código ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
