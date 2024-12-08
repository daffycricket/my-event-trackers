import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../services/event_service.dart';

final apiServiceProvider = Provider<EventService>((ref) => EventService());

final eventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return EventsNotifier(apiService);
});

class EventsNotifier extends StateNotifier<List<Event>> {
  final EventService _apiService;

  EventsNotifier(this._apiService) : super([]) {
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      final events = await _apiService.getEvents();
      state = events;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      final newEvent = await _apiService.createEvent(event);
      state = [...state, newEvent];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      final updatedEvent = await _apiService.updateEvent(event.id, event);
      state = state.map((e) => e.id == event.id ? updatedEvent : e).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _apiService.deleteEvent(id);
      state = state.where((e) => e.id != id).toList();
    } catch (e) {
      rethrow;
    }
  }
} 