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
    notes: 'Déjeuner sucré',
    date: DateTime.now().subtract(const Duration(minutes: 45)),
    type: MealType.lunch,
    foods: [
      const FoodItem(name: 'Salade', quantity: 1),
      const FoodItem(name: 'Poulet', quantity: 1),
      const FoodItem(name: 'Riz', quantity: 100),
    ],
  ),
];