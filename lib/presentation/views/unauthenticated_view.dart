import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nakama_ui/domain/providers/providers.dart';

/// Login screen for unauthenticated users.
class UnauthenticatedView extends ConsumerWidget {
  /// Email controller.
  final _emailController = TextEditingController();

  /// Password controller.
  final _passwordController = TextEditingController();

  UnauthenticatedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () => _login(ref),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Attempt to authenticate user via email/password.
  void _login(WidgetRef ref) {
    // Extract email and password from text controllers.
    String email = _emailController.text;
    String password = _passwordController.text;

    // Call provider for authentication.
    ref.read(Providers.nakamaAuthenticatedProvider.notifier).authenticateEmail(
          email: email,
          password: password,
        );
  }
}
