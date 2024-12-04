
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': runtimeType == MealEvent ? 'MEAL' : 'WORKOUT',
    'date': date.toIso8601String(),
    'notes': notes,
    'data': _dataToJson(),
  };

  Map<String, dynamic> _dataToJson();

  static Event fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    if (type == 'MEAL') {
      return MealEvent.fromJson(json);
    } else {
      return WorkoutEvent.fromJson(json);
    }
  }
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

  @override
  Map<String, dynamic> _dataToJson() => {
    'foods': foods.map((food) => food.toJson()).toList(),
    'type': type.name,
  };

  factory MealEvent.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return MealEvent(
      id: json['id'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      foods: (data['foods'] as List)
          .map((food) => FoodItem.fromJson(food))
          .toList(),
      type: MealType.values.firstWhere(
        (e) => e.name == data['type'],
      ),
    );
  }
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

  @override
  Map<String, dynamic> _dataToJson() => {
    'duration': duration.inMinutes,
    'type': type.name,
    'calories_burned': caloriesBurned,
  };

  factory WorkoutEvent.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return WorkoutEvent(
      id: json['id'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      duration: Duration(minutes: data['duration']),
      type: WorkoutType.values.firstWhere(
        (e) => e.name == data['type'],
      ),
      caloriesBurned: data['calories_burned'],
    );
  }
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