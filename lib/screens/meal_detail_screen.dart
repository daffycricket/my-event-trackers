import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_event_tracker/data/static_food_data.dart';
import 'package:my_event_tracker/models/food_category.dart';
import 'package:my_event_tracker/models/unit_type.dart';
import 'package:my_event_tracker/screens/create_meal_screen.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MealDetailScreen extends ConsumerStatefulWidget {
  final MealEvent meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final updatedMeal = ref.watch(eventsProvider)
        .firstWhere((e) => e.id == widget.meal.id) as MealEvent;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mealDetails),
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
                    final foodName = _getLocalizedFoodName(l10n, foodItem.name);
                    
                    final staticFood = staticFoodSuggestions.firstWhere(
                      (food) => food.name == foodItem.name,
                      orElse: () => StaticFood(
                        name: foodItem.name,
                        category: FoodCategory.snacks,
                        unitType: UnitType.unit,
                      ),
                    );

                    return ListTile(
                      leading: const Icon(Icons.food_bank),
                      title: Text(foodName),
                      trailing: Text(
                        '${foodItem.quantity.toInt()} ${staticFood.unitType.getSymbol()}',
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateMealScreen(mealToEdit: updatedMeal),
            ),
          );
        },
        icon: const Icon(Icons.edit),
        label: Text(l10n.edit),
      ),
    );
  }

  String _getLocalizedFoodName(AppLocalizations l10n, String foodName) {
    switch (foodName) {
      // Fruits
      case 'Apple':
        return l10n.foodApple;
      case 'Banana':
        return l10n.foodBanana;
      case 'Orange':
        return l10n.foodOrange;
      // Légumes
      case 'Carrot':
        return l10n.foodCarrot;
      case 'Tomato':
        return l10n.foodTomato;
      case 'Cucumber':
        return l10n.foodCucumber;
      // Protéines
      case 'Chicken':
        return l10n.foodChicken;
      case 'Beef':
        return l10n.foodBeef;
      case 'Fish':
        return l10n.foodFish;
      // Féculents
      case 'Rice':
        return l10n.foodRice;
      case 'Pasta':
        return l10n.foodPasta;
      case 'Bread':
        return l10n.foodBread;
      // Produits laitiers
      case 'Milk':
        return l10n.foodMilk;
      case 'Yogurt':
        return l10n.foodYogurt;
      case 'Cheese':
        return l10n.foodCheese;
      // Boissons
      case 'Water':
        return l10n.foodWater;
      case 'Coffee':
        return l10n.foodCoffee;
      case 'Tea':
        return l10n.foodTea;
      // Snacks
      case 'Cookies':
        return l10n.foodCookies;
      case 'Chips':
        return l10n.foodChips;
      case 'Nuts':
        return l10n.foodNuts;
      default:
        return foodName;
    }
  }
} 