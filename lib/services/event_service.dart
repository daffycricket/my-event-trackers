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
      final authData = await _ref.read(authServiceProvider).getStoredAuthData();
      logInfo('AuthData retrieved: $authData');
      final token = authData['token'];
      if (token == null) {
        throw Exception('Not authenticated');
      }

      logInfo('Fetching events from ${BaseService.baseUrl}/api/events/');
      logInfo('Request bearer token: $token');
      final response = await http.get(
        Uri.parse('${BaseService.baseUrl}/api/events/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      logInfo('Response status: ${response.statusCode}');
      logFine('Response body:');
      logFine(response.body);
      
      if (response.statusCode == 200) {
        try {
          final dynamic decodedResponse = json.decode(response.body);
          
          if (decodedResponse == null) {
            logWarning('Response is null');
            return [];
          }

          if (decodedResponse is List) {
            logInfo('Response parsed successfully, ${decodedResponse.length} events');
            return decodedResponse.map((json) => Event.fromJson(json)).toList();
          } else {
            logWarning('Unexpected response format: $decodedResponse');
            return [];
          }

        } catch (e, stackTrace) {
          logSevere('Error parsing response', e, stackTrace);
          rethrow;
        }
      } else {
        final error = 'Failed to load events: ${response.statusCode} \nBody: ${response.body}';
        logSevere(error);
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      logSevere('Error fetching events', e, stackTrace);
      rethrow;
    }
  }

  Future<Event> createEvent(Event event) async {
    final authData = await _ref.read(authServiceProvider).getStoredAuthData();
    final token = authData['token'];
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final jsonData = event.toJson();
    logInfo('Creating event at ${BaseService.baseUrl}/api/events');
    logInfo('Request bearer token: $token');
    logInfo('Request body:');
    logInfo(json.encode(jsonData));

    final response = await http.post(
      Uri.parse('${BaseService.baseUrl}/api/events'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(jsonData),
    );
    
    logInfo('Response status: ${response.statusCode}');
    logInfo('Response body:');
    logInfo(response.body);

    if (response.statusCode == 200) {
      try {
        final responseEvent = Event.fromJson(json.decode(response.body));
        logInfo('Response parsed successfully');
        return responseEvent;
      } catch (e, stackTrace) {
        logSevere('Error parsing response', e, stackTrace);
        rethrow;
      }
    } else {
      final error = 'Failed to create event: ${response.statusCode}';
      logSevere(error);
      logSevere('Error: $error');
      throw Exception(error);
    }
  }

  Future<Event> updateEvent(int id, Event event) async {
    final authData = await _ref.read(authServiceProvider).getStoredAuthData();
    final token = authData['token'];
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final jsonData = event.toJson();
    logInfo('Updating event at ${BaseService.baseUrl}/api/events/$id');
    logInfo('Request bearer token: $token');
    logInfo('Request body:');
    logInfo(json.encode(jsonData));

    final response = await http.put(
      Uri.parse('${BaseService.baseUrl}/api/events/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(jsonData),
    );

    logInfo('Response status: ${response.statusCode}');
    logInfo('Response body:');
    logInfo(response.body);
    
    if (response.statusCode == 200) {
      try {
        final responseEvent = Event.fromJson(json.decode(response.body));
        logInfo('Response body parsed successfully');
        return responseEvent;
      } catch (e, stackTrace) {
        logSevere('Error parsing response', e, stackTrace);
        rethrow;
      }
    } else {
      final error = 'Failed to update event: ${response.statusCode}\nBody: ${response.body}';
      logSevere(error);
      throw Exception(error);
    }
  }

  Future<void> deleteEvent(int id) async {
    final authData = await _ref.read(authServiceProvider).getStoredAuthData();
    final token = authData['token'];
    if (token == null) {
      throw Exception('Not authenticated');
    }
    logInfo('Deleting event at ${BaseService.baseUrl}/api/events/$id');
    logInfo('Request bearer token: $token');

    final response = await http.delete(
      Uri.parse('${BaseService.baseUrl}/api/events/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    logInfo('Response status: ${response.statusCode}');
    logInfo('Response body:');
    logInfo(response.body);
    
    if (response.statusCode != 200) {
      final error = 'Failed to delete event: ${response.statusCode}\nBody: ${response.body}';
      logSevere(error);
      throw Exception(error);
    }
  }
} 