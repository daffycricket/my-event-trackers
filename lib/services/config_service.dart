import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_reference.dart';
import 'base_service.dart';

abstract class ConfigService {
  Future<List<FoodReference>> getFoodReferences(String language);
}

class ApiConfigService extends BaseService implements ConfigService {
  ApiConfigService() : super('ApiConfigService');

  @override
  Future<List<FoodReference>> getFoodReferences(String language) async {
    try {
      final uri = Uri.parse('${BaseService.baseUrl}/api/config/foods').replace(
        queryParameters: {'language': language},
      );
      logInfo('Fetching food references from $uri');
      
      final response = await http.get(uri);
      
      logInfo('Response status: ${response.statusCode}');
      logFine('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        return decodedResponse.map((json) => FoodReference.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load food references: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      logSevere('Error fetching food references', e, stackTrace);
      rethrow;
    }
  }
}