import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? "";

  Future<List<dynamic>> fetchCharacters(int page, int limit) async {
    final response = await http.get(Uri.parse('$baseUrl?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      final List<dynamic> characters = json.decode(response.body)['characters'];
      return characters;
    } else {
      throw Exception("Failed to load characters");
    }
  }

  Future<Map<String, dynamic>> fetchCharacterDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load character details");
    }
  }
}
