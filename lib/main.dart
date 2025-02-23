import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_event_tracker/providers/auth_provider.dart';
import 'package:my_event_tracker/screens/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_event_tracker/utils/logger.dart';
import 'package:my_event_tracker/widgets/initialization.dart';
import 'providers/config_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_event_tracker/constants/storage_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser le logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final message = record.message;
    final time = record.time;
    final level = record.level.name;
    final error = record.error;
    final stackTrace = record.stackTrace;
    
    if (error != null || stackTrace != null) {
      debugPrint('$level: $time: $message\n$error\n$stackTrace');
    } else {
      debugPrint('$level: $time: $message');
    }
  });

  // Initialiser les formats de date
  await initializeDateFormatting();

  // Récupérer l'utilisateur stocké
  final prefs = await SharedPreferences.getInstance();
  final storedToken = prefs.getString(StorageKeys.userToken);
  AppLogger.info('storedToken: $storedToken');

  // Précharger les configurations
  final container = ProviderContainer();
  if (storedToken != null) {
    container.read(authStateProvider.notifier).setToken(storedToken);
  }

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
    return MaterialApp(
      navigatorKey: ref.watch(navigatorKeyProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Consumer(
        builder: (context, ref, _) {
          final token = ref.watch(authStateProvider);
          
          if (token == null) {
            return FutureBuilder<String?>(
              future: ref.read(authStateProvider.notifier).getStoredEmail(),
              builder: (context, snapshot) {
                return LoginScreen(
                  initialEmail: snapshot.data,
                );
              },
            );
          }
          
          return const InitializationWidget();
        },
      ),
    );
  }
}