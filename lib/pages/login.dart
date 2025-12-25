import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var isLogin = useState(false);

    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: false),

      body: Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login", style: TextStyle(fontSize: 24)),

            if (!isLogin.value)
              ElevatedButton(
                onPressed: () {
                  isLogin.value = true;
                },
                child: Text("Login"),
              ),
            if (isLogin.value)
              ElevatedButton(
                onPressed: () {
                  isLogin.value = false;
                },
                child: Text("Logout"),
              ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text("Go to Register"),
            ),
          ],
        ),
      ),
    );
  }
}
