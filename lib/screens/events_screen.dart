import 'package:flutter/material.dart';
import 'package:my_event_tracker/models/food_item.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final ApiService _apiService = ApiService();
  List<Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await _apiService.getEvents();
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading events: $e')),
      );
    }
  }

  Future<void> _addTestEvent() async {
    try {
      final event = MealEvent(
        id: const Uuid().v4(),
        date: DateTime.now(),
        foods: [
          const FoodItem(
            name: 'Pasta',
            quantity: 100,
          ),
        ],
        notes: 'Test meal', type: MealType.breakfast,
      );

      await _apiService.createEvent(event);
      _loadEvents();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return ListTile(
                  title: Text(event.runtimeType.toString()),
                  subtitle: Text(event.notes ?? ''),
                  trailing: Text(event.date.toString()),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTestEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
} 