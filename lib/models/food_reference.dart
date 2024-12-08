import 'package:my_event_tracker/models/food_category.dart';
import 'package:my_event_tracker/models/unit_type.dart';

class FoodReference {
  final String id;
  final String name;
  final FoodCategory category;
  final UnitType unitType;
  final int defaultQuantity;

  const FoodReference({
    required this.id,
    required this.name,
    required this.category,
    required this.unitType,
    this.defaultQuantity = 1,
  });

  factory FoodReference.fromJson(Map<String, dynamic> json) {
    return FoodReference(
      id: json['id'],
      name: json['name'],
      category: FoodCategory.values.byName(json['category']),
      unitType: UnitType.values.byName(json['unit_type']),
      defaultQuantity: json['default_quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category.name,
    'unit_type': unitType.name,
    'default_quantity': defaultQuantity,
  };
} 