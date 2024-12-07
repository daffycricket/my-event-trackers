import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_event_tracker/models/food_category.dart';


extension FoodCategoryExtension on FoodCategory {
  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case FoodCategory.fruits:
        return l10n.categoryFruits;
      case FoodCategory.vegetables:
        return l10n.categoryVegetables;
      case FoodCategory.proteins:
        return l10n.categoryProteins;
      case FoodCategory.carbs:
        return l10n.categoryCarbs;
      case FoodCategory.dairy:
        return l10n.categoryDairy;
      case FoodCategory.drinks:
        return l10n.categoryDrinks;
      case FoodCategory.snacks:
        return l10n.categorySnacks;
    }
  }

  Color get color {
    switch (this) {
      case FoodCategory.fruits:
        return Colors.orange;
      case FoodCategory.vegetables:
        return Colors.green;
      case FoodCategory.proteins:
        return Colors.red;
      case FoodCategory.carbs:
        return Colors.brown;
      case FoodCategory.dairy:
        return Colors.blue;
      case FoodCategory.drinks:
        return Colors.purple;
      case FoodCategory.snacks:
        return Colors.yellow;
    }
  }
}

class FoodItem {
  final String Function(BuildContext) nameGetter;
  final FoodCategory category;

  FoodItem({
    required this.nameGetter,
    required this.category,
  });

  String getName(BuildContext context) => nameGetter(context);
}

List<FoodItem> getFoodSuggestions(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    // Fruits
    FoodItem(
      nameGetter: (context) => l10n.foodApple,
      category: FoodCategory.fruits,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodBanana,
      category: FoodCategory.fruits,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodOrange,
      category: FoodCategory.fruits,
    ),
    // Légumes
    FoodItem(
      nameGetter: (context) => l10n.foodCarrot,
      category: FoodCategory.vegetables,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodTomato,
      category: FoodCategory.vegetables,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodCucumber,
      category: FoodCategory.vegetables,
    ),
    // Protéines
    FoodItem(
      nameGetter: (context) => l10n.foodChicken,
      category: FoodCategory.proteins,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodBeef,
      category: FoodCategory.proteins,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodFish,
      category: FoodCategory.proteins,
    ),
    // Féculents
    FoodItem(
      nameGetter: (context) => l10n.foodRice,
      category: FoodCategory.carbs,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodPasta,
      category: FoodCategory.carbs,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodBread,
      category: FoodCategory.carbs,
    ),
    // Produits laitiers
    FoodItem(
      nameGetter: (context) => l10n.foodMilk,
      category: FoodCategory.dairy,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodYogurt,
      category: FoodCategory.dairy,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodCheese,
      category: FoodCategory.dairy,
    ),
    // Boissons
    FoodItem(
      nameGetter: (context) => l10n.foodWater,
      category: FoodCategory.drinks,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodCoffee,
      category: FoodCategory.drinks,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodTea,
      category: FoodCategory.drinks,
    ),
    // Snacks
    FoodItem(
      nameGetter: (context) => l10n.foodCookies,
      category: FoodCategory.snacks,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodChips,
      category: FoodCategory.snacks,
    ),
    FoodItem(
      nameGetter: (context) => l10n.foodNuts,
      category: FoodCategory.snacks,
    ),
  ];
} 