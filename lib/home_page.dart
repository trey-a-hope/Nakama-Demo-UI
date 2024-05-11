import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nakama_ui/authenticated_view.dart';
import 'package:nakama_ui/providers.dart';
import 'package:nakama_ui/unauthenticated_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticatedProvider = ref.watch(Providers.nakamaSessionProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Nakama Demo'),
      ),
      body: isAuthenticatedProvider.when(
        data: (isAuthenticated) =>
            isAuthenticated ? const AuthenticatedView() : UnauthenticatedView(),
        error: (err, stack) => Center(
          child: Text(
            err.toString(),
          ),
        ),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
