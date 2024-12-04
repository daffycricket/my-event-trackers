import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum FoodCategory {
  fruits,
  vegetables,
  proteins,
  carbs,
  dairy,
  drinks,
  snacks
}

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

class CategoryFood {
  final String Function(BuildContext) nameGetter;
  final FoodCategory category;

  CategoryFood({
    required this.nameGetter,
    required this.category,
  });

  String getName(BuildContext context) => nameGetter(context);
}

List<CategoryFood> getFoodSuggestions(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    // Fruits
    CategoryFood(
      nameGetter: (context) => l10n.foodApple,
      category: FoodCategory.fruits,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodBanana,
      category: FoodCategory.fruits,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodOrange,
      category: FoodCategory.fruits,
    ),
    // Légumes
    CategoryFood(
      nameGetter: (context) => l10n.foodCarrot,
      category: FoodCategory.vegetables,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodTomato,
      category: FoodCategory.vegetables,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodCucumber,
      category: FoodCategory.vegetables,
    ),
    // Protéines
    CategoryFood(
      nameGetter: (context) => l10n.foodChicken,
      category: FoodCategory.proteins,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodBeef,
      category: FoodCategory.proteins,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodFish,
      category: FoodCategory.proteins,
    ),
    // Féculents
    CategoryFood(
      nameGetter: (context) => l10n.foodRice,
      category: FoodCategory.carbs,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodPasta,
      category: FoodCategory.carbs,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodBread,
      category: FoodCategory.carbs,
    ),
    // Produits laitiers
    CategoryFood(
      nameGetter: (context) => l10n.foodMilk,
      category: FoodCategory.dairy,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodYogurt,
      category: FoodCategory.dairy,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodCheese,
      category: FoodCategory.dairy,
    ),
    // Boissons
    CategoryFood(
      nameGetter: (context) => l10n.foodWater,
      category: FoodCategory.drinks,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodCoffee,
      category: FoodCategory.drinks,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodTea,
      category: FoodCategory.drinks,
    ),
    // Snacks
    CategoryFood(
      nameGetter: (context) => l10n.foodCookies,
      category: FoodCategory.snacks,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodChips,
      category: FoodCategory.snacks,
    ),
    CategoryFood(
      nameGetter: (context) => l10n.foodNuts,
      category: FoodCategory.snacks,
    ),
  ];
} 