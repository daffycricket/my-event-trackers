import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_event_tracker/models/event.dart';
import 'package:my_event_tracker/screens/create_meal_screen.dart';
import 'package:my_event_tracker/screens/create_workout_screen.dart';
import 'providers/events_provider.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/workout_detail_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Suivi des Événements',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Événements Quotidiens'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const EventList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              heroTag: 'meal_fab',
              onPressed: () => _showMealForm(context),
              icon: const Icon(Icons.restaurant),
              label: const Text('Repas'),
            ),
            FloatingActionButton.extended(
              heroTag: 'workout_fab',
              onPressed: () => _showWorkoutForm(context),
              icon: const Icon(Icons.fitness_center),
              label: const Text('Exercice'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMealForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateMealScreen(),
      ),
    );
  }

  void _showWorkoutForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateWorkoutScreen(),
      ),
    );
  }
}

class EventList extends ConsumerWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          child: ListTile(
            leading: Icon(
              event is MealEvent ? Icons.restaurant : Icons.fitness_center,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(event.title),
            subtitle: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(event.date),
            ),
            trailing: event is MealEvent
                ? Text(event.type.name)
                : Text('${(event as WorkoutEvent).duration.inMinutes}min'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => event is MealEvent
                    ? MealDetailScreen(meal: event)
                    : WorkoutDetailScreen(workout: event as WorkoutEvent),
              ),
            ),
          ),
        );
      },
    );
  }
}
