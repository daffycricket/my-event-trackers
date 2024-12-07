import 'package:my_event_tracker/models/food_category.dart';
import 'package:my_event_tracker/models/unit_type.dart';

class StaticFood {
  final String name;
  final FoodCategory category;
  final UnitType unitType;
  final int defaultQuantity;

  const StaticFood({
    required this.name,
    required this.category,
    required this.unitType,
    this.defaultQuantity = 1,
  });
}

const List<StaticFood> staticFoodSuggestions = [
  // Fruits (en unités)
  StaticFood(name: "Pomme", category: FoodCategory.fruits, unitType: UnitType.unit),
  StaticFood(name: "Banane", category: FoodCategory.fruits, unitType: UnitType.unit),
  StaticFood(name: "Orange", category: FoodCategory.fruits, unitType: UnitType.unit),
  
  // Légumes (en grammes)
  StaticFood(name: "Carotte", category: FoodCategory.vegetables, unitType: UnitType.weight, defaultQuantity: 100),
  StaticFood(name: "Tomate", category: FoodCategory.vegetables, unitType: UnitType.unit),
  StaticFood(name: "Concombre", category: FoodCategory.vegetables, unitType: UnitType.unit),
  
  // Protéines (en grammes)
  StaticFood(name: "Poulet", category: FoodCategory.proteins, unitType: UnitType.weight, defaultQuantity: 150),
  StaticFood(name: "Bœuf", category: FoodCategory.proteins, unitType: UnitType.weight, defaultQuantity: 150),
  StaticFood(name: "Poisson", category: FoodCategory.proteins, unitType: UnitType.weight, defaultQuantity: 150),
  
  // Féculents (en grammes)
  StaticFood(name: "Riz", category: FoodCategory.carbs, unitType: UnitType.weight, defaultQuantity: 100),
  StaticFood(name: "Pâtes", category: FoodCategory.carbs, unitType: UnitType.weight, defaultQuantity: 100),
  StaticFood(name: "Pain", category: FoodCategory.carbs, unitType: UnitType.weight, defaultQuantity: 50),
  
  // Produits laitiers
  StaticFood(name: "Lait", category: FoodCategory.dairy, unitType: UnitType.volume, defaultQuantity: 20),
  StaticFood(name: "Yaourt", category: FoodCategory.dairy, unitType: UnitType.unit),
  StaticFood(name: "Fromage", category: FoodCategory.dairy, unitType: UnitType.weight, defaultQuantity: 30),
  
  // Boissons (en cl)
  StaticFood(name: "Eau", category: FoodCategory.drinks, unitType: UnitType.volume, defaultQuantity: 25),
  StaticFood(name: "Café", category: FoodCategory.drinks, unitType: UnitType.volume, defaultQuantity: 15),
  StaticFood(name: "Thé", category: FoodCategory.drinks, unitType: UnitType.volume, defaultQuantity: 25),
  
  // Snacks
  StaticFood(name: "Biscuits", category: FoodCategory.snacks, unitType: UnitType.unit),
  StaticFood(name: "Chips", category: FoodCategory.snacks, unitType: UnitType.weight, defaultQuantity: 30),
  StaticFood(name: "Fruits secs", category: FoodCategory.snacks, unitType: UnitType.weight, defaultQuantity: 30),
]; 