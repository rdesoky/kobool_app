import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Home Page", style: TextStyle(fontSize: 24)),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text("Go to Login"),
        ),
      ],
    );
  }
}
