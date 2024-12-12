import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/widgets/event_list.dart';
import '../screens/statistics_screen.dart';
import '../screens/create_meal_screen.dart';
import '../screens/create_workout_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventListScreen extends ConsumerWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
        ],
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
              label: Text(AppLocalizations.of(context)!.meal),
            ),
            FloatingActionButton.extended(
              heroTag: 'workout_fab',
              onPressed: () => _showWorkoutForm(context),
              icon: const Icon(Icons.fitness_center),
              label: Text(AppLocalizations.of(context)!.workout),
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