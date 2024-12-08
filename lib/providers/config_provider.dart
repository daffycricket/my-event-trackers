import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/models/food_reference.dart';
import 'package:my_event_tracker/services/config_service.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

final configServiceProvider = Provider<ConfigService>((ref) {
  return MockConfigService();
});

final foodReferencesProvider = FutureProvider<List<FoodReference>>((ref) async {
  final service = ref.watch(configServiceProvider);
  return service.getFoodReferences('fr');
}); 