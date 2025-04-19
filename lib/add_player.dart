import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPlayerPage extends StatefulWidget {
  const AddPlayerPage({super.key});

  @override
  _AddPlayerPageState createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int age = 0;
  String handedness = 'Right';
  double? fbVelo;
  double? exitVelo;

  Future<void> submit() async {
    final response = await http.post(
      Uri.parse('http://localhost:5173/api/player'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'age': age,
        'handedness': handedness,
        'fastballVelo': fbVelo,
        'exitVelo': exitVelo,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context); // Return to the player list
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add player')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Player')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (val) => name = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onChanged: (val) => age = int.tryParse(val) ?? 0,
              ),
              DropdownButtonFormField<String>(
                value: handedness,
                items:
                    ['Right', 'Left', 'Switch'].map((h) {
                      return DropdownMenuItem(value: h, child: Text(h));
                    }).toList(),
                onChanged: (val) => setState(() => handedness = val!),
                decoration: InputDecoration(labelText: 'Handedness'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fastball Velo'),
                keyboardType: TextInputType.number,
                onChanged: (val) => fbVelo = double.tryParse(val),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Exit Velo'),
                keyboardType: TextInputType.number,
                onChanged: (val) => exitVelo = double.tryParse(val),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: submit, child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
