import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/models/event.dart';
import '../providers/events_provider.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          String subtitle = '';
          
          if (event is MealEvent) {
            subtitle = '${event.type.name} - ${event.foods.length} items';
          } else if (event is WorkoutEvent) {
            subtitle = '${event.type.name} - ${event.duration.inMinutes} min';
          }
          
          return ListTile(
            title: Text(event.runtimeType.toString()),
            subtitle: Text(subtitle),
            trailing: Text(
              '${event.date.day}/${event.date.month}/${event.date.year}'
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implémenter l'ajout d'événement
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 