import 'package:flutter/material.dart';
import 'package:my_event_tracker/models/event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension MealTypeUI on MealType {
  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case MealType.breakfast:
        return l10n.categoryBreakfast;
      case MealType.lunch:
        return l10n.categoryLunch;
      case MealType.dinner:
        return l10n.categoryDinner;
      case MealType.snack:
        return l10n.categorySnacks;
    }
  }
}

extension WorkoutTypeUI on WorkoutType {
  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case WorkoutType.running:
        return l10n.categoryRunning;
      case WorkoutType.cycling:
        return l10n.categoryCycling;
      case WorkoutType.fitness:
        return l10n.categoryFitness;
      case WorkoutType.strength:
        return l10n.categoryStrength;
    }
  }
}