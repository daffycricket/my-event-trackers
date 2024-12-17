import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_service.dart';

class AuthService extends BaseService {
  AuthService() : super('AuthService');

  Future<String> login(String email, String password) async {
    try {
      final uri = Uri.parse('${BaseService.baseUrl}/auth/login');
      logInfo('Logging in user: $email + $password');
      logInfo('Request URL: $uri');
      
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': email,
          'password': password,
        },
      );
      
      logInfo('Response status: ${response.statusCode}');
      logFine('Response body:');
      logFine(response.body);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        logInfo('Decoded response: $data');
        return data['access_token'];
      } else {
        logSevere('Login failed with status ${response.statusCode}');
        logSevere('Response body:');
        logSevere(response.body);
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logSevere('Login error', e, stackTrace);
      rethrow;
    }
  }

  Future<String> register(String email, String password) async {
    try {
      final uri = Uri.parse('${BaseService.baseUrl}/auth/register');
      final jsonData = {
        'email': email,
        'password': password,
        'is_active' : true,
        'is_superuser' : false,
        'is_verified' : true
        };
      logInfo('Registering user: $email');
      logInfo('Request URL: $uri');
      logInfo('Request body:');
      logInfo(jsonEncode(jsonData));
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(jsonData),
      );
      
      logInfo('Response status: ${response.statusCode}');
      logFine('Response body:');
      logFine(response.body);
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        logInfo('Decoded response: $data');
        // Après l'inscription réussie, on fait directement le login
        return login(email, password);
      } else {
        logSevere('Registration failed with status ${response.statusCode}');
        logSevere('Response body:');
        logSevere(response.body);
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logSevere('Registration error', e, stackTrace);
      rethrow;
    }
  }
} 