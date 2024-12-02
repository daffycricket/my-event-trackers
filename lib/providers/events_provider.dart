import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/models/food_item.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';

final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>((ref) {
  return EventsNotifier();
});

class EventsNotifier extends StateNotifier<List<Event>> {
  EventsNotifier() : super(_initialEvents);

  void addEvent(Event event) {
    state = [...state, event];
  }

  Event getEventById(String id) {
    return state.firstWhere((event) => event.id == id);
  }

    void updateEvent(Event updatedEvent) {
    state = state.map((event) => 
      event.id == updatedEvent.id ? updatedEvent : event
    ).toList();
  }
} 

final _initialEvents = [
  // Aujourd'hui
  MealEvent(
    id: const Uuid().v4(),
    date: DateTime.now().subtract(const Duration(hours: 3)),
    type: MealType.breakfast,
    foods: [
      const FoodItem(name: 'Café', quantity: 1),
      const FoodItem(name: 'Pain', quantity: 1), 
      const FoodItem(name: 'Œufs', quantity: 2),
    ],
    notes: 'Petit déjeuner équilibré',
  ),
  WorkoutEvent(
    id: const Uuid().v4(),
    notes: 'Jogging matinal sur les quais',
    date: DateTime.now().subtract(const Duration(hours: 2)),
    type: WorkoutType.cardio,
    duration: const Duration(minutes: 30),
    caloriesBurned: 300,
  ),
  MealEvent(
    id: const Uuid().v4(),
    notes: 'Déjeuner léger',
    date: DateTime.now().subtract(const Duration(minutes: 45)),
    type: MealType.lunch,
    foods: [
      const FoodItem(name: 'Salade', quantity: 1),
      const FoodItem(name: 'Poulet', quantity: 1),
      const FoodItem(name: 'Riz', quantity: 100),
    ],
  ),
  // Hier
  MealEvent(
    id: const Uuid().v4(),
    date: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
    type: MealType.dinner,
    foods: [
      const FoodItem(name: 'Pâtes', quantity: 200),
      const FoodItem(name: 'Sauce tomate', quantity: 1),
      const FoodItem(name: 'Parmesan', quantity: 30),
    ],
    notes: 'Dîner italien',
  ),
  WorkoutEvent(
    id: const Uuid().v4(),
    notes: 'Séance de musculation',
    date: DateTime.now().subtract(const Duration(days: 1, hours: 16)),
    type: WorkoutType.strength,
    duration: const Duration(minutes: 45),
    caloriesBurned: 400,
  ),
  // Avant-hier
  MealEvent(
    id: const Uuid().v4(),
    date: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
    type: MealType.breakfast,
    foods: [
      const FoodItem(name: 'Yaourt', quantity: 1),
      const FoodItem(name: 'Granola', quantity: 50),
      const FoodItem(name: 'Banane', quantity: 1),
    ],
    notes: 'Petit déjeuner healthy',
  ),
  WorkoutEvent(
    id: const Uuid().v4(),
    notes: 'Match de tennis',
    date: DateTime.now().subtract(const Duration(days: 2, hours: 14)),
    type: WorkoutType.sport,
    duration: const Duration(minutes: 90),
    caloriesBurned: 600,
  ),
  // Il y a 3 jours
  MealEvent(
    id: const Uuid().v4(),
    date: DateTime.now().subtract(const Duration(days: 3, hours: 19)),
    type: MealType.snack,
    foods: [
      const FoodItem(name: 'Pomme', quantity: 1),
      const FoodItem(name: 'Amandes', quantity: 30),
    ],
    notes: 'Collation saine',
  ),
  WorkoutEvent(
    id: const Uuid().v4(),
    notes: 'Séance de yoga',
    date: DateTime.now().subtract(const Duration(days: 3, hours: 20)),
    type: WorkoutType.flexibility,
    duration: const Duration(minutes: 60),
    caloriesBurned: 200,
  ),
];