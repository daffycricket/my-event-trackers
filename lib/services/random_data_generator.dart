import 'dart:math';
import 'package:my_event_tracker/models/food_category.dart';
import 'package:my_event_tracker/models/meal_item.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import '../data/static_food_data.dart';

class RandomDataGenerator {
  final _random = Random();
  final _uuid = const Uuid();

  RandomDataGenerator();

  List<Event> generateRandomEvents() {
    final events = <Event>[];
    final now = DateTime.now();
    
    // Générer des événements pour les 14 derniers jours (sans aujourd'hui)
    for (var day = 1; day < 15; day++) {
      final currentDate = now.subtract(Duration(days: day));
      
      // Petit déjeuner (80% de chance)
      if (_random.nextDouble() < 0.8) {
        events.add(_generateRandomMeal(
          _adjustTime(currentDate, 7, 9), // Entre 7h et 9h
          forcedType: MealType.breakfast,
        ));
      }
      
      // Déjeuner (90% de chance)
      if (_random.nextDouble() < 0.9) {
        events.add(_generateRandomMeal(
          _adjustTime(currentDate, 12, 14), // Entre 12h et 14h
          forcedType: MealType.lunch,
        ));
      }
      
      // Collation (40% de chance)
      if (_random.nextDouble() < 0.4) {
        events.add(_generateRandomMeal(
          _adjustTime(currentDate, 16, 17), // Entre 16h et 17h
          forcedType: MealType.snack,
        ));
      }
      
      // Dîner (85% de chance)
      if (_random.nextDouble() < 0.85) {
        events.add(_generateRandomMeal(
          _adjustTime(currentDate, 19, 21), // Entre 19h et 21h
          forcedType: MealType.dinner,
        ));
      }
      
      // Sport (30% de chance par jour)
      if (_random.nextDouble() < 0.3) {
        final sportTime = _random.nextBool()
            ? _adjustTime(currentDate, 7, 9)   // Matin
            : _adjustTime(currentDate, 17, 19); // Après-midi
        events.add(_generateRandomWorkout(sportTime));
      }
    }

    // Trier par date
    events.sort((a, b) => b.date.compareTo(a.date));
    return events;
  }

  DateTime _adjustTime(DateTime date, int startHour, int endHour) {
    return date.add(Duration(
      hours: _random.nextInt(endHour - startHour) + startHour,
      minutes: _random.nextInt(60),
    ));
  }

  MealEvent _generateRandomMeal(DateTime date, {MealType? forcedType}) {
    final type = forcedType ?? MealType.values[_random.nextInt(MealType.values.length)];
    
    // Ajuster le nombre d'aliments selon le type de repas
    int minFoods, maxFoods;
    switch (type) {
      case MealType.breakfast:
        minFoods = 2;
        maxFoods = 4;
        break;
      case MealType.lunch:
      case MealType.dinner:
        minFoods = 3;
        maxFoods = 6;
        break;
      case MealType.snack:
        minFoods = 1;
        maxFoods = 2;
        break;
    }

    final numberOfFoods = _random.nextInt(maxFoods - minFoods + 1) + minFoods;
    final foods = <MealItem>[];
    final availableFoods = List<StaticFood>.from(staticFoodSuggestions);
    
    // Sélectionner des aliments appropriés selon le type de repas
    for (var i = 0; i < numberOfFoods; i++) {
      if (availableFoods.isEmpty) break;
      
      StaticFood selectedFood;
      if (type == MealType.breakfast) {
        // Favoriser les produits laitiers, fruits et boulangerie pour le petit déjeuner
        selectedFood = _selectFoodByCategories(availableFoods, 
          [FoodCategory.dairy, FoodCategory.fruits, FoodCategory.carbs]);
      } else if (type == MealType.snack) {
        // Favoriser les fruits et snacks pour les collations
        selectedFood = _selectFoodByCategories(availableFoods, 
          [FoodCategory.fruits, FoodCategory.snacks]);
      } else {
        selectedFood = availableFoods[_random.nextInt(availableFoods.length)];
      }
      
      foods.add(MealItem(
        name: selectedFood.name,
        quantity: _random.nextInt(3) + 1,
      ));
      availableFoods.remove(selectedFood);
    }

    return MealEvent(
      id: _random.nextInt(1000000),
      date: date,
      type: type,
      foods: foods,
      notes: _random.nextDouble() < 0.3 ? _generateRandomNote() : null, // 30% de chance d'avoir une note
    );
  }

  StaticFood _selectFoodByCategories(List<StaticFood> availableFoods, List<FoodCategory> preferredCategories) {
    final preferredFoods = availableFoods.where((food) => preferredCategories.contains(food.category)).toList();
    if (preferredFoods.isNotEmpty && _random.nextDouble() < 0.7) { // 70% de chance de choisir un aliment préféré
      return preferredFoods[_random.nextInt(preferredFoods.length)];
    }
    return availableFoods[_random.nextInt(availableFoods.length)];
  }

  WorkoutEvent _generateRandomWorkout(DateTime date) {
    const types = WorkoutType.values;
    return WorkoutEvent(
      id: _random.nextInt(1000000),
      date: date,
      type: types[_random.nextInt(types.length)],
      duration: Duration(minutes: (_random.nextInt(6) + 1) * 15), // 15-90 minutes
      caloriesBurned: _random.nextBool() ? _random.nextInt(400) + 100 : null,
      notes: _random.nextBool() ? _generateRandomNote() : null,
    );
  }

  String _generateRandomNote() {
    final notes = [
      'Super séance !',
      'À refaire',
      'Un peu difficile aujourd\'hui',
      'Manque d\'énergie',
      'Très satisfait',
      'Belle progression',
    ];
    return notes[_random.nextInt(notes.length)];
  }
} 