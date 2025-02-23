import 'package:my_event_tracker/models/food_category.dart';
import 'package:my_event_tracker/models/unit_type.dart';
import 'dart:developer';

class FoodReference {
  final String name;
  final String label;
  final FoodCategory category;
  final UnitType unitType;
  final double defaultQuantity;

  const FoodReference({
    required this.name,
    required this.label,
    required this.category,
    required this.unitType,
    required this.defaultQuantity,
  });

  factory FoodReference.fromJson(Map<String, dynamic> json) {
    try {
      return FoodReference(
        name: json['name'],
        label: json['label'],
        category: FoodCategory.values.byName(json['category']),
        unitType: UnitType.values.byName(json['unit_type']),
        defaultQuantity: json['default_quantity'].toDouble(),
      );
    } catch (e) {
      log('Error parsing JSON: ${json.toString()}');
      log('Category value: ${json['category']}');
      log('UnitType value: ${json['unit_type']}');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'label': label,
    'category': category.name.toLowerCase(),
    'unit_type': unitType.name.toLowerCase(),
    'default_quantity': defaultQuantity,
  };

  @override
  String toString() => toJson().toString();
} 