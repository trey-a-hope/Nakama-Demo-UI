import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nakama_ui/domain/providers/providers.dart';

/// Display leaderboard and user info when authenticated.
class AuthenticatedView extends ConsumerWidget {
  const AuthenticatedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionData = ref.watch(Providers.nakamaSessionDataProvider);
    final leaderBoardRecords = ref.watch(Providers.nakamaLeaderboardProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: leaderBoardRecords.when(
            data: (records) => ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(record.username!),
                  subtitle: Text(
                    'Score: ${record.score}\nUID: ${record.ownerId}',
                  ),
                );
              },
            ),
            error: (err, stack) => Text(
              err.toString(),
            ),
            loading: () => const CircularProgressIndicator(),
          ),
        ),
        sessionData.when(
          data: (data) => data == null
              ? const ListTile(
                  leading: Icon(Icons.error),
                  title: Text('Error'),
                  subtitle: Text('Could not load user information.'),
                )
              : ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('Username: ${data.username}'),
                  subtitle: Text(
                    'Email: ${data.email}\nToken Expires: ${DateFormat.jm().format(data.expiresAt)}',
                  ),
                ),
          error: (err, stack) => Center(
            child: Text(
              err.toString(),
            ),
          ),
          loading: () => const CircularProgressIndicator(),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => ref
                .read(Providers.nakamaLeaderboardProvider.notifier)
                .writeLeaderboardRecord(
                  score: Random().nextInt(100),
                ),
            child: const Text('Write Leaderboard Record'),
          ),
        ),
      ],
    );
  }
}
