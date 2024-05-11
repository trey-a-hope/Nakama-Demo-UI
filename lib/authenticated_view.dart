import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nakama_ui/providers.dart';

class AuthenticatedView extends ConsumerWidget {
  const AuthenticatedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionData =
        ref.read(Providers.nakamaSessionProvider.notifier).getSessionData()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(sessionData.username),
          subtitle: const Text('Username'),
        ),
        ListTile(
          leading: const Icon(Icons.numbers),
          title: Text(sessionData.uid),
          subtitle: const Text('UID'),
        ),
        ListTile(
          leading: const Icon(Icons.date_range),
          title: Text(DateFormat.jm().format(sessionData.exp)),
          subtitle: const Text('Token Expires'),
        )
      ],
    );
  }
}

// class AuthenticatedView extends StatefulWidget {
//   const AuthenticatedView({super.key});

//   @override
//   State<AuthenticatedView> createState() => _AuthenticatedViewState();
// }

// class _AuthenticatedViewState extends State<AuthenticatedView> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [Text('afeaf')],
//     );
//   }
// }
