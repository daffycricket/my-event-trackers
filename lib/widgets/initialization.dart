import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/screens/event_list_screen.dart';
import 'package:my_event_tracker/providers/auth_provider.dart';
import 'package:my_event_tracker/providers/events_provider.dart';

class InitializationWidget extends ConsumerWidget {
  const InitializationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.refresh(eventsProvider);
    
    return FutureBuilder<String?>(
      future: ref.read(authStateProvider.notifier).getStoredEmail(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mes événements'),
                if (snapshot.hasData)
                  Text(
                    snapshot.data!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  ref.read(authStateProvider.notifier).logout();
                },
              ),
            ],
          ),
          body: const EventListScreen(),
        );
      },
    );
  }
}
