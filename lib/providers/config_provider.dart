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
  
  // Si le contexte n'est pas disponible, on utilise la langue par défaut
  final language = context != null 
    ? Localizations.localeOf(context).languageCode 
    : 'fr';  // langue par défaut
    
  return service.getFoodReferences(language);
}); 