import 'dart:convert';
import 'package:http/http.dart' as http;

class Player {
  int id;
  String name;
  int age;
  String handedness;
  double? fastballVelo;
  double? exitVelo;

  Player({
    required this.id,
    required this.name,
    required this.age,
    required this.handedness,
    this.fastballVelo,
    this.exitVelo,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      handedness: json['handedness'],
      fastballVelo: (json['fastballVelo'] as num?)?.toDouble(),
      exitVelo: (json['exitVelo'] as num?)?.toDouble(),
    );
  }
}

Future<List<Player>> fetchPlayers() async {
  final response = await http.get(
    Uri.parse('http://localhost:5173/api/player'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Player.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load players');
  }
}
