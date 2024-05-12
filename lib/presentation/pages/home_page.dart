import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nakama_ui/presentation/views/authenticated_view.dart';
import 'package:nakama_ui/domain/providers/providers.dart';
import 'package:nakama_ui/presentation/views/unauthenticated_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticatedProvider =
        ref.watch(Providers.nakamaAuthenticatedProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Nakama Demo'),
        actions: [
          if (isAuthenticatedProvider.hasValue &&
              isAuthenticatedProvider.asData!.value) ...[
            IconButton(
              onPressed: () => ref
                  .read(Providers.nakamaAuthenticatedProvider.notifier)
                  .logout(),
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ]
        ],
      ),
      body: SafeArea(
        child: isAuthenticatedProvider.when(
          data: (isAuthenticated) => isAuthenticated
              ? const AuthenticatedView()
              : UnauthenticatedView(),
          error: (err, stack) => Center(
            child: Text(
              err.toString(),
            ),
          ),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
