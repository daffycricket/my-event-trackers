import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_event_tracker/services/base_service.dart';
import '../models/event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/providers/auth_provider.dart';

class EventService extends BaseService {
  final Ref _ref;
  
  EventService(this._ref) : super('EventService');

  Future<List<Event>> getEvents() async {
    try {
      final token = _ref.read(authStateProvider);
      if (token == null) {
        throw Exception('Not authenticated');
      }

      logInfo('Fetching events from ${BaseService.baseUrl}/api/events/');
      final response = await http.get(
        Uri.parse('${BaseService.baseUrl}/api/events/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      logInfo('Response status: ${response.statusCode}');
      logFine('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final dynamic decodedResponse = json.decode(response.body);
        
        logInfo('Decoded response type: ${decodedResponse.runtimeType}');
        logInfo('Decoded response: $decodedResponse');
        
        if (decodedResponse == null) {
          return [];
        }
        
        if (decodedResponse is List) {
          return decodedResponse.map((json) => Event.fromJson(json)).toList();
        } else {
          logWarning('Unexpected response format: $decodedResponse');
          return [];
        }
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logSevere('Error fetching events', e, stackTrace);
      rethrow;
    }
  }

  Future<Event> createEvent(Event event) async {
    try {
      final jsonData = event.toJson();
      logInfo('Creating event at ${BaseService.baseUrl}/api/events');
      logInfo('Request payload:\n${const JsonEncoder.withIndent('  ').convert(jsonData)}');

      final response = await http.post(
        Uri.parse('${BaseService.baseUrl}/api/events'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_ref.read(authStateProvider)}',
        },
        body: json.encode(jsonData),
      );
      
      logInfo('Response status: ${response.statusCode}');
      logInfo('Response body:\n${const JsonEncoder.withIndent('  ').convert(json.decode(response.body))}');
      
      if (response.statusCode == 200) {
        return Event.fromJson(json.decode(response.body));
      } else {
        final error = 'Failed to create event: ${response.statusCode}\nBody: ${response.body}';
        logSevere(error);
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      logSevere('Error creating event', e, stackTrace);
      rethrow;
    }
  }

  Future<Event> updateEvent(String id, Event event) async {
    final response = await http.put(
      Uri.parse('${BaseService.baseUrl}/api/events/$id'),
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
    final response = await http.delete(Uri.parse('${BaseService.baseUrl}/api/events/$id'));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to delete event');
    }
  }
} 