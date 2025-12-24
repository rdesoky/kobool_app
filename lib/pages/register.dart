import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), centerTitle: false),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Register", style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              child: Text("Go to Search"),
            ),
          ],
        ),
      ),
    );
  }
}
