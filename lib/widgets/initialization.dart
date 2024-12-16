import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/providers/config_provider.dart';
import 'package:my_event_tracker/screens/event_list_screen.dart';

class InitializationWidget extends ConsumerWidget {
  const InitializationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Déclencher le chargement une fois que le contexte est disponible
    final foodReferences = ref.watch(foodReferencesProvider);
    
    return foodReferences.when(
      data: (_) => const EventListScreen(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erreur: $error')),
    );
  }
}
