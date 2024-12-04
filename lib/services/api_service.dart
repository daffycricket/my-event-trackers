import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import '../models/event.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:9095/api/v1';
  final _logger = Logger('ApiService');
  
  Future<List<Event>> getEvents() async {
    try {
      _logger.info('Fetching events from $baseUrl/events/');
      final response = await http.get(Uri.parse('$baseUrl/events/'));
      
      _logger.info('Response status: ${response.statusCode}');
      _logger.fine('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.severe('Error fetching events', e, stackTrace);
      rethrow;
    }
  }

  Future<Event> createEvent(Event event) async {
    try {
      _logger.info('Creating event');
      _logger.fine('Event data: ${event.toJson()}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/events/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(event.toJson()),
      );
      
      _logger.info('Response status: ${response.statusCode}');
      _logger.fine('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return Event.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create event: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.severe('Error creating event', e, stackTrace);
      rethrow;
    }
  }

  Future<Event> updateEvent(String id, Event event) async {
    final response = await http.put(
      Uri.parse('$baseUrl/events/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event.toJson()),
    );
    
    if (response.statusCode == 200) {
      return Event.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update event');
    }
  }

  Future<void> deleteEvent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/events/$id'));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to delete event');
    }
  }
} 