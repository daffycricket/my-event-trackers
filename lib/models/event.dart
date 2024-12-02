import 'package:my_event_tracker/models/food_item.dart';

abstract class Event {
  final String id;
  final DateTime date;
  final String? notes;

  Event({
    required this.id,
    required this.date,
    this.notes,
  });
}

class MealEvent extends Event {
  final List<FoodItem> foods;
  final MealType type;

  MealEvent({
    required super.id,
    required super.date,
    required this.foods,
    required this.type,
    super.notes,
  });
}

class WorkoutEvent extends Event {
  final Duration duration;
  final WorkoutType type;
  final int? caloriesBurned;

  WorkoutEvent({
    required super.id,
    required super.date,
    required this.duration,
    required this.type,
    this.caloriesBurned,
    super.notes,
  });
}

enum MealType {
  breakfast,
  lunch,
  dinner,
  snack
}

enum WorkoutType {
  cardio,
  strength,
  flexibility,
  sport
}