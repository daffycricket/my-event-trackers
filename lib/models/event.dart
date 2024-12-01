abstract class Event {
  final String id;
  final String title;
  final DateTime date;

  const Event({
    required this.id,
    required this.title,
    required this.date,
  });
}

class MealEvent extends Event {
  final List<String> foods;
  final String? notes;
  final MealType type;

  const MealEvent({
    required super.id,
    required super.title,
    required super.date,
    required this.foods,
    this.notes,
    required this.type,
  });
}

class WorkoutEvent extends Event {
  final Duration duration;
  final WorkoutType type;
  final int? caloriesBurned;
  final String? notes;

  const WorkoutEvent({
    required super.id,
    required super.title,
    required super.date,
    required this.duration,
    required this.type,
    this.caloriesBurned,
    this.notes,
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