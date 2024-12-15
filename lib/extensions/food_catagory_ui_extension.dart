import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_event_tracker/models/food_category.dart';

extension FoodCategoryUI on FoodCategory {
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