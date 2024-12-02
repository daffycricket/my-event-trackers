import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../services/random_data_generator.dart';

final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>((ref) {
  return EventsNotifier(RandomDataGenerator().generateRandomEvents());
});

class EventsNotifier extends StateNotifier<List<Event>> {
  EventsNotifier(this.events) : super(events);

  final List<Event> events;

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