import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';

class PlayerDetailPage extends StatefulWidget {
  final Player player;

  const PlayerDetailPage({super.key, required this.player});

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  late bool isEditing;
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController handednessController;
  late TextEditingController fbVeloController;
  late TextEditingController exitVeloController;

  @override
  void initState() {
    super.initState();
    isEditing = false;

    nameController = TextEditingController(text: widget.player.name);
    ageController = TextEditingController(text: widget.player.age.toString());
    handednessController = TextEditingController(
      text: widget.player.handedness,
    );
    fbVeloController = TextEditingController(
      text: widget.player.fastballVelo?.toString() ?? '',
    );
    exitVeloController = TextEditingController(
      text: widget.player.exitVelo?.toString() ?? '',
    );
  }

  Future<void> updatePlayer() async {
    final updatedPlayer = {
      'id': widget.player.id,
      'name': nameController.text,
      'age': int.tryParse(ageController.text) ?? widget.player.age,
      'handedness': handednessController.text,
      'fastballVelo': double.tryParse(fbVeloController.text),
      'exitVelo': double.tryParse(exitVeloController.text),
    };

    final response = await http.put(
      Uri.parse('http://localhost:5173/api/player/${widget.player.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedPlayer),
    );

    if (response.statusCode == 204) {
      setState(() {
        widget.player.name = nameController.text;
        widget.player.age =
            int.tryParse(ageController.text) ?? widget.player.age;
        widget.player.handedness = handednessController.text;
        widget.player.fastballVelo = double.tryParse(fbVeloController.text);
        widget.player.exitVelo = double.tryParse(exitVeloController.text);
        isEditing = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Player updated')));

      Navigator.pop(context, widget.player); // Return updated player
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update player')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player.name),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                updatePlayer();
              } else {
                setState(() => isEditing = true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildField('Name', nameController),
            buildField(
              'Age',
              ageController,
              keyboardType: TextInputType.number,
            ),
            buildField('Handedness', handednessController),
            buildField(
              'Fastball Velo',
              fbVeloController,
              keyboardType: TextInputType.number,
            ),
            buildField(
              'Exit Velo',
              exitVeloController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child:
          isEditing
              ? TextFormField(
                controller: controller,
                decoration: InputDecoration(labelText: label),
                keyboardType: keyboardType,
              )
              : Text(
                '$label: ${controller.text}',
                style: TextStyle(fontSize: 18),
              ),
    );
  }
}
