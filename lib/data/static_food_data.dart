enum FoodCategory {
  fruits,
  vegetables,
  proteins,
  carbs,
  dairy,
  drinks,
  snacks
}

class StaticFood {
  final String name;
  final FoodCategory category;

  const StaticFood({
    required this.name,
    required this.category,
  });
}

const List<StaticFood> staticFoodSuggestions = [
  // Fruits
  StaticFood(name: "Pomme", category: FoodCategory.fruits),
  StaticFood(name: "Banane", category: FoodCategory.fruits),
  StaticFood(name: "Orange", category: FoodCategory.fruits),
  // Légumes
  StaticFood(name: "Carotte", category: FoodCategory.vegetables),
  StaticFood(name: "Tomate", category: FoodCategory.vegetables),
  StaticFood(name: "Concombre", category: FoodCategory.vegetables),
  // Protéines
  StaticFood(name: "Poulet", category: FoodCategory.proteins),
  StaticFood(name: "Bœuf", category: FoodCategory.proteins),
  StaticFood(name: "Poisson", category: FoodCategory.proteins),
  // Féculents
  StaticFood(name: "Riz", category: FoodCategory.carbs),
  StaticFood(name: "Pâtes", category: FoodCategory.carbs),
  StaticFood(name: "Pain", category: FoodCategory.carbs),
  // Produits laitiers
  StaticFood(name: "Lait", category: FoodCategory.dairy),
  StaticFood(name: "Yaourt", category: FoodCategory.dairy),
  StaticFood(name: "Fromage", category: FoodCategory.dairy),
  // Boissons
  StaticFood(name: "Eau", category: FoodCategory.drinks),
  StaticFood(name: "Café", category: FoodCategory.drinks),
  StaticFood(name: "Thé", category: FoodCategory.drinks),
  // Snacks
  StaticFood(name: "Biscuits", category: FoodCategory.snacks),
  StaticFood(name: "Chips", category: FoodCategory.snacks),
  StaticFood(name: "Fruits secs", category: FoodCategory.snacks),
]; 