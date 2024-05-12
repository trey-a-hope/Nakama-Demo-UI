import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nakama_ui/domain/providers/providers.dart';

class AuthenticatedView extends ConsumerWidget {
  const AuthenticatedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Safe to assume that session data is available at this point.
    final sessionData = ref.read(Providers.nakamaSessionDataProvider).value!;

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
                  subtitle:
                      Text('Score: ${record.score}\nUID: ${record.ownerId}'),
                );
              },
            ),
            error: (err, stack) => Text(
              err.toString(),
            ),
            loading: () => const CircularProgressIndicator(),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text('Username: ${sessionData.username}'),
          subtitle: Text(
            'Email: ${sessionData.email}\nToken Expires: ${DateFormat.jm().format(sessionData.expiresAt)}',
          ),
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
