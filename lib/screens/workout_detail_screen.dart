import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_event_tracker/providers/events_provider.dart';
import 'package:my_event_tracker/screens/create_workout_screen.dart';
import '../models/event.dart';

class WorkoutDetailScreen extends ConsumerStatefulWidget {
  final WorkoutEvent workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  ConsumerState<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends ConsumerState<WorkoutDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Récupérer la version à jour depuis le provider
    final updatedWorkout = ref.watch(eventsProvider)
        .firstWhere((e) => e.id == widget.workout.id) as WorkoutEvent;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(updatedWorkout.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      updatedWorkout.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(updatedWorkout.date),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Chip(label: Text(updatedWorkout.type.name)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Durée'),
                        Text('${updatedWorkout.duration.inMinutes} minutes'),
                      ],
                    ),
                    if (updatedWorkout.caloriesBurned != null) ...[
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Calories brûlées'),
                          Text('${updatedWorkout.caloriesBurned} kcal'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (updatedWorkout.notes != null) ...[
              const SizedBox(height: 16),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(updatedWorkout.notes!),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateWorkoutScreen(workoutToEdit: updatedWorkout),
            ),
          ).then((_) => setState(() {})); // Force refresh après modification
        },
        icon: const Icon(Icons.edit),
        label: const Text('Modifier'),
      ),
    );
  }
} 