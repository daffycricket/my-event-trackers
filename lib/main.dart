import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_event_tracker/models/event.dart';
import 'package:my_event_tracker/screens/create_meal_screen.dart';
import 'package:my_event_tracker/screens/create_workout_screen.dart';
import 'providers/events_provider.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/workout_detail_screen.dart';

void main() {
  initializeDateFormatting('fr_FR');
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
    
    // Grouper les événements par date
    final groupedEvents = groupEventsByDate(events);

    return ListView.builder(
      itemCount: groupedEvents.length,
      itemBuilder: (context, index) {
        final date = groupedEvents.keys.elementAt(index);
        final dayEvents = groupedEvents[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                formatDate(date),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ...dayEvents.map((event) => ListTile(
              leading: Icon(
                event is MealEvent ? Icons.restaurant : Icons.fitness_center,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                event is MealEvent 
                  ? _getMealTypeText((event as MealEvent).type)
                  : '${_getWorkoutTypeText((event as WorkoutEvent).type)} - ${(event as WorkoutEvent).duration.inMinutes}min'
              ),
              subtitle: event.notes != null 
                ? Text(event.notes!)
                : event is MealEvent 
                  ? Text((event as MealEvent).foods.map((f) => f.toString()).join(', '))
                  : null,
              trailing: Text(
                DateFormat('HH:mm').format(event.date),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => event is MealEvent
                      ? MealDetailScreen(meal: event)
                      : WorkoutDetailScreen(workout: event as WorkoutEvent),
                ),
              ),
            )),
            const Divider(),
          ],
        );
      },
    );
  }

  Map<DateTime, List<Event>> groupEventsByDate(List<Event> events) {
    final grouped = <DateTime, List<Event>>{};
    
    for (final event in events) {
      final date = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
      );
      
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(event);
    }

    // Trier les événements de chaque jour par heure
    for (final date in grouped.keys) {
      grouped[date]!.sort((a, b) => a.date.compareTo(b.date));
    }

    // Trier les dates par ordre décroissant
    return Map.fromEntries(
      grouped.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key))
    );
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    
    if (date.year == now.year && 
        date.month == now.month && 
        date.day == now.day) {
      return "Aujourd'hui";
    } else if (date.year == yesterday.year && 
               date.month == yesterday.month && 
               date.day == yesterday.day) {
      return "Hier";
    } else if (date.year == tomorrow.year && 
               date.month == tomorrow.month && 
               date.day == tomorrow.day) {
      return "Demain";
    }
    
    return DateFormat('EEEE dd MMMM', 'fr_FR').format(date);
  }

  String _getMealTypeText(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return 'Petit déjeuner';
      case MealType.lunch:
        return 'Déjeuner';
      case MealType.dinner:
        return 'Dîner';
      case MealType.snack:
        return 'Collation';
    }
  }

  String _getWorkoutTypeText(WorkoutType type) {
    switch (type) {
      case WorkoutType.cardio:
        return 'Cardio';
      case WorkoutType.strength:
        return 'Musculation';
      case WorkoutType.flexibility:
        return 'Étirements';
      case WorkoutType.sport:
        return 'Sport';
    }
  }
}
