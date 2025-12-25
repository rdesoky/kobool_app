import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final String id;
  const UserPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User'), centerTitle: false),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("User: $id", style: TextStyle(fontSize: 24))],
        ),
      ),
    );
  }
}
