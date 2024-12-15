import 'package:my_event_tracker/models/meal_item.dart';

abstract class Event {
  final int id;
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

    @override
  String toString() => toJson().toString();
}

class MealEvent extends Event {
  final List<MealItem> foods;
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
    'meal_items': foods.map((food) => {
      'food_id': food.name,
      'quantity': food.quantity.toDouble(),
    }).toList(),
    'meal_type': type.name,
  };

  factory MealEvent.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final mealItems = (data['meal_items'] as List<dynamic>? ?? []).map((item) => 
      MealItem(
        name: item['name'].toString(),
        quantity: (item['quantity'] as num).toDouble(),
      )
    ).toList();
    
    return MealEvent(
      id: json['id'] as int,
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      foods: mealItems,
      type: MealType.values.firstWhere(
        (e) => e.name == (data['meal_type'] ?? 'snack'),
        orElse: () => MealType.snack,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = {
      'type': 'MEAL',
      'date': date.toIso8601String(),
      'notes': notes,
      'data': {
        'meal_type': type.name,
      },
      'meal_items': foods.map((food) => {
        'name': food.name,
        'quantity': food.quantity,
      }).toList(),
    };
    
    return baseJson;
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
    'workout_type': type.name,
    'calories_burned': caloriesBurned,
  };

  factory WorkoutEvent.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return WorkoutEvent(
      id: json['id'] as int,
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      duration: Duration(minutes: data['duration']),
      type: WorkoutType.values.firstWhere(
        (e) => e.name == data['workout_type'],
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
  running,
  cycling,
  fitness,
  strength
}