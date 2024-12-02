import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_event_tracker/screens/create_meal_screen.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';

class MealDetailScreen extends ConsumerStatefulWidget {
  final MealEvent meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final updatedMeal = ref.watch(eventsProvider)
        .firstWhere((e) => e.id == widget.meal.id) as MealEvent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail du repas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                        updatedMeal.type.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(updatedMeal.date),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Chip(label: Text(updatedMeal.type.name)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Aliments',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: updatedMeal.foods.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.food_bank),
                    title: Text(updatedMeal.foods[index].name),
                    trailing: Text(updatedMeal.foods[index].quantity.toString()),
                  ),
                ),
              ),
              if (updatedMeal.notes != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Notes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(updatedMeal.notes!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateMealScreen(mealToEdit: updatedMeal),
            ),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text('Modifier'),
      ),
    );
  }
} 