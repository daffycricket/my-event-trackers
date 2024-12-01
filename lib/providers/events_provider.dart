import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';

final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>((ref) {
  return EventsNotifier();
});

class EventsNotifier extends StateNotifier<List<Event>> {
  EventsNotifier() : super([]);

  void addEvent(Event event) {
    state = [...state, event];
  }
} 