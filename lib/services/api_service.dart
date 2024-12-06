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
        final dynamic decodedResponse = json.decode(response.body);
        
        // Log pour débugger la structure de la réponse
        _logger.info('Decoded response type: ${decodedResponse.runtimeType}');
        _logger.info('Decoded response: $decodedResponse');
        
        if (decodedResponse == null) {
          return [];
        }
        
        if (decodedResponse is List) {
          return decodedResponse.map((json) => Event.fromJson(json)).toList();
        } else {
          _logger.warning('Unexpected response format: $decodedResponse');
          return [];
        }
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
      final jsonData = event.toJson();
      _logger.info('Creating event at $baseUrl/events/');
      _logger.info('Request payload:\n${const JsonEncoder.withIndent('  ').convert(jsonData)}');

      final response = await http.post(
        Uri.parse('$baseUrl/events/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );
      
      _logger.info('Response status: ${response.statusCode}');
      _logger.info('Response body:\n${const JsonEncoder.withIndent('  ').convert(json.decode(response.body))}');
      
      if (response.statusCode == 200) {
        return Event.fromJson(json.decode(response.body));
      } else {
        final error = 'Failed to create event: ${response.statusCode}\nBody: ${response.body}';
        _logger.severe(error);
        throw Exception(error);
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