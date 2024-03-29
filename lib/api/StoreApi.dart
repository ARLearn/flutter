import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youplay/config/app_config.dart';
import 'package:youplay/models/game.dart';

class StoreApi {

  static Future<List<Game>> recentGames() async {
    var url = Uri.https(AppConfig().baseUrl, 'api/games/library/recent');
    final response = await http.get(url);
    Map<String, dynamic> gamesMap = jsonDecode(response.body);
    if (gamesMap['games'] == null) return [];
    return (gamesMap['games'] as List).map((g)=> Game.fromJson(g)).toList();
  }


  static Future<List<Game>> featuredGames() async {
    var url = Uri.https(AppConfig().baseUrl, 'api/games/featured/nl');
    final response = await http.get(
        url);
    Map<String, dynamic> gamesMap = jsonDecode(response.body);
    if (gamesMap['games'] == null) return [];
    return (gamesMap['games'] as List)
        .map((g)=> Game.fromJson(g))
        .toList();
  }


  static Future<List<Game>> search(String query) async {
    var url = Uri.https(AppConfig().baseUrl, 'api/games/library/search/$query');
    final response = await http.get(url);
    // print(response.body);
    // print(query);
    Map<String, dynamic> gamesMap = jsonDecode(response.body);
    if (gamesMap['games'] == null) return [];
    return (gamesMap['games'] as List)
        .map((g)=> Game.fromJson(g)).toList();
  }

  static Future<dynamic> game(int gameId) async {
    var url = Uri.https(AppConfig().baseUrl, 'api/games/library/game/$gameId');
    final response = await http.get(url );
    Map<String, dynamic> gameMap = jsonDecode(response.body);
    if (gameMap['error'] != null) {
      return null;
    }
    // print(response.body);
    return Game.fromJson(gameMap);
  }
}
