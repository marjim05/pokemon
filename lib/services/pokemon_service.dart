import 'dart:convert';
import '../models/pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

  Future<List<Pokemon>> fetchPokemons({int limit = 20, int offset = 0}) async {
    final url = Uri.parse('$baseUrl?limit=$limit&offset=$offset');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error al cargar Pokémon');
    }
    final data = json.decode(response.body);
    final results = data['results'] as List;

    final List<Future<Pokemon>> futures = results.map((item) {
    return fetchPokemonDetail(item['url']);
    }).toList();
    return await Future.wait(futures);
    }

  Future<Pokemon> fetchPokemonDetail(String urlDetail) async {
    final response = await http.get(Uri.parse(urlDetail));
    final data = json.decode(response.body);
    return Pokemon.fromJson(data);
  }
}
