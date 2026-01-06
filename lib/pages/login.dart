import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/dio_provider.dart';
import 'package:kobool/providers/user_session_provider.dart';
import 'package:kobool/utils/validators.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageArgs =
        (ModalRoute.of(context)!.settings.arguments ?? {})
            as Map<dynamic, dynamic>;
    final autoLogout = useState(pageArgs['auto_logout'] ?? false);
    final isLogin = useState(true);
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    void onSubmitted() {
      isLoading.value = true;
      errorMessage.value = null;
      if (isLogin.value) {
        ref
            .read(dioProvider)
            .post(
              API.login,
              data: {
                'lname': usernameController.text,
                'pw': passwordController.text,
              },
              options: Options(contentType: Headers.formUrlEncodedContentType),
            )
            .then((response) {
              isLoading.value = false;
              if (response.statusCode == 200) {
                final error = response.data['error'] ?? "";
                final sessionId = response.headers.value('sid') ?? "";
                if (error.isEmpty && sessionId.isNotEmpty) {
                  final userSession = UserSession.fromResponse(response);
                  ref
                      .read(userSessionProvider.notifier)
                      .setUserSession(userSession);

                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, Routes.home);
                  }
                } else {
                  errorMessage.value = error.isEmpty ? "invalid_login" : error;
                }
              } else {
                errorMessage.value = "invalid_login";
              }
            })
            .catchError((error) {
              isLoading.value = false;
              debugPrint(error.toString());
              errorMessage.value = "unknown_error";
            });
      } else {
        // Trigger reset password logic
      }
    }

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
            child: isLoading.value
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      if (autoLogout.value)
                        Text(
                          'session_expired_title'.tr(),
                          style: const TextStyle(color: Colors.red),
                        ),
                      if (errorMessage.value != null)
                        Text(
                          errorMessage.value!.tr(),
                          style: const TextStyle(color: Colors.red),
                        ),

                      if (isLogin.value)
                        TextFormField(
                          autofocus: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                          onFieldSubmitted: (_) => onSubmitted(),
                        )
                      else
                        TextFormField(
                          autofocus: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: emailValidator,
                          onFieldSubmitted: (_) => onSubmitted(),
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
                              onPressed: () => obscurePassword.value =
                                  !obscurePassword.value,
                            ),
                          ),
                          validator: passwordValidator,
                          onFieldSubmitted: (_) => onSubmitted(),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            onSubmitted();
                          },
                          child: Text(
                            isLogin.value ? 'Submit' : 'Reset Password',
                          ),
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
