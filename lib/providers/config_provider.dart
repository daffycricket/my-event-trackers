import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_event_tracker/models/food_reference.dart';
import 'package:my_event_tracker/services/config_service.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

final configServiceProvider = Provider<ConfigService>((ref) {
  return ApiConfigService();
});

final foodReferencesProvider = FutureProvider<List<FoodReference>>((ref) async {
  final service = ref.watch(configServiceProvider);
  final context = ref.read(navigatorKeyProvider).currentContext;
  
  final language = context != null 
    ? Localizations.localeOf(context).languageCode 
    : 'fr';
    
  final foods = await service.getFoodReferences(language);
  return foods;
}); 

final mealItemWithReferenceProvider = Provider.family<FoodReference?, String>((ref, foodId) {
  final foodReferences = ref.watch(foodReferencesProvider).value ?? [];
  try {
    return foodReferences.firstWhere((food) => food.name == foodId);
  } catch (e) {
    return null;
  }
});