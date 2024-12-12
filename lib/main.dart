import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_event_tracker/providers/auth_provider.dart';
import 'package:my_event_tracker/screens/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'providers/config_provider.dart';
import 'package:my_event_tracker/screens/event_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser le logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Initialiser les formats de date
  await initializeDateFormatting();

  // Précharger les configurations
  final container = ProviderContainer();
  await container.read(foodReferencesProvider.future);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(authStateProvider);

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mes événements'),
          actions: [
            if (token != null)
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  ref.read(authStateProvider.notifier).logout();
                },
              ),
          ],
        ),
        body: token == null 
            ? const LoginScreen() 
            : const EventListScreen(),
      ),
    );
  }
}