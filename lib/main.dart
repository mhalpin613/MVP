import 'package:flutter/material.dart';
import 'api.dart';
import 'add_player.dart';
import 'player_detail.dart';

void main() {
  runApp(MVPApp());
}

class MVPApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVP Baseball',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PlayerListPage(),
    );
  }
}

class PlayerListPage extends StatefulWidget {
  @override
  _PlayerListPageState createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  late Future<List<Player>> futurePlayers;

  @override
  void initState() {
    super.initState();
    futurePlayers = fetchPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Player List')),
      body: FutureBuilder<List<Player>>(
        future: futurePlayers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final players = snapshot.data!;

          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return ListTile(
                title: Text(player.name),
                subtitle: Text(
                  'Age: ${player.age}, FB Velo: ${player.fastballVelo ?? "N/A"}',
                ),
                onTap: () async {
                  final updated = await Navigator.push<Player>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerDetailPage(player: player),
                    ),
                  );

                  if (updated != null) {
                    setState(() {
                      futurePlayers = fetchPlayers(); // Refresh full list
                    });
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPlayerPage()),
          );
          setState(() {
            futurePlayers = fetchPlayers(); // Refresh list after add
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Add Player',
      ),
    );
  }
}
