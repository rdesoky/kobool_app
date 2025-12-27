import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/utils/validators.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLogin = useState(true);
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);

    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin.value ? 'Login' : 'Reset Password'),
        centerTitle: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                isLogin.value
                    ? TextFormField(
                        autofocus: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      )
                    : TextFormField(
                        autofocus: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: emailValidator,
                      ),
                if (isLogin.value)
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwordController,
                    obscureText: obscurePassword.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            obscurePassword.value = !obscurePassword.value,
                      ),
                    ),
                    validator: passwordValidator,
                  ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // TODO: Implement submission logic
                    },
                    child: Text(isLogin.value ? 'Submit' : 'Reset Password'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    isLogin.value = !isLogin.value;
                  },
                  child: Text(
                    isLogin.value ? 'Reset Password' : 'Back to Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
