import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_event_tracker/models/food_category.dart';
import 'package:my_event_tracker/models/food_reference.dart';
import 'package:my_event_tracker/models/unit_type.dart';
import 'package:my_event_tracker/providers/config_provider.dart';
import 'package:my_event_tracker/screens/create_meal_screen.dart';
import 'package:my_event_tracker/utils/logger.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MealDetailScreen extends ConsumerWidget {
  final MealEvent meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final updatedMeal = ref.watch(eventsProvider)
        .firstWhere((e) => e.id == meal.id) as MealEvent;

    String getMealTypeText(MealType type) {
      switch (type) {
        case MealType.breakfast:
          return l10n.breakfast;
        case MealType.lunch:
          return l10n.lunch;
        case MealType.dinner:
          return l10n.dinner;
        case MealType.snack:
          return l10n.snack;
      }
    }

    return ref.watch(foodReferencesProvider).when(
      data: (foodReferences) {
        AppLogger.info("État complet du repas :");
        AppLogger.info(updatedMeal);
        AppLogger.info("Liste des aliments brute :");
        AppLogger.info(updatedMeal.foods);

        // Pour chaque aliment, vérifions le matching
        for (var foodItem in updatedMeal.foods) {
          final matchingRef = foodReferences.firstWhere(
            (ref) => ref.name == foodItem.name,
            orElse: () => FoodReference(
              name: foodItem.name.toLowerCase().replaceAll(' ', '_'),
              label: foodItem.name,
              category: FoodCategory.snacks,
              unitType: UnitType.unit,
              defaultQuantity: 1.0,
            ),
          );
          AppLogger.info("Recherche de correspondance pour ${foodItem.name} : ${matchingRef.label}");
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.mealDetails),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                            getMealTypeText(updatedMeal.type),
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
                          Chip(label: Text(getMealTypeText(updatedMeal.type))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.foods,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: updatedMeal.foods.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final foodItem = updatedMeal.foods[index];
                        final foodRef = foodReferences.firstWhere(
                          (ref) => ref.name == foodItem.name,
                          orElse: () => FoodReference(
                            name: foodItem.name.toLowerCase().replaceAll(' ', '_'),
                            label: foodItem.name,
                            category: FoodCategory.snacks,
                            unitType: UnitType.unit,
                            defaultQuantity: 1.0,
                          ),
                        );

                        return ListTile(
                          leading: const Icon(Icons.food_bank),
                          title: Text(foodRef.label),
                          trailing: Text(
                            '${foodItem.quantity} ${foodRef.unitType.getSymbol()}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        );
                      },
                    ),
                  ),
                  if (updatedMeal.notes != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      l10n.notes,
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
            onPressed: () => _navigateToEditMeal(context, ref),
            label: Text(l10n.edit),
            icon: const Icon(Icons.edit),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Erreur: $error')),
    );
  }

  void _navigateToEditMeal(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateMealScreen(mealToEdit: ref.watch(eventsProvider)
            .firstWhere((e) => e.id == meal.id) as MealEvent),
      ),
    );
  }
} 