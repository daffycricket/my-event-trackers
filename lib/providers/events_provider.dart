import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    title: 'Petit déjeuner',
    date: DateTime.now().subtract(const Duration(hours: 3)),
    type: MealType.breakfast,
    foods: ['Café', 'Pain', 'Œufs'],
    notes: 'Petit déjeuner équilibré',
  ),
  WorkoutEvent(
    id: const Uuid().v4(),
    title: 'Jogging matinal',
    date: DateTime.now().subtract(const Duration(hours: 2)),
    type: WorkoutType.cardio,
    duration: const Duration(minutes: 30),
    caloriesBurned: 300,
  ),
  MealEvent(
    id: const Uuid().v4(),
    title: 'Déjeuner',
    date: DateTime.now().subtract(const Duration(minutes: 45)),
    type: MealType.lunch,
    foods: ['Salade', 'Poulet', 'Riz'],
  ),
];