import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_event_tracker/models/event.dart';
import 'package:my_event_tracker/screens/create_meal_screen.dart';
import 'package:my_event_tracker/screens/create_workout_screen.dart';
import 'package:my_event_tracker/screens/statistics_screen.dart';
import 'package:my_event_tracker/widgets/event_list_item.dart';
import 'providers/events_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'providers/config_provider.dart';

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
    return MaterialApp(
      navigatorKey: ref.watch(navigatorKeyProvider),
      locale: Locale('fr', ''),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fr', ''),
        Locale('en', ''),
        Locale('de', ''),
        Locale('sv', ''),
      ],
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: const EventList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              heroTag: 'meal_fab',
              onPressed: () => _showMealForm(context),
              icon: const Icon(Icons.restaurant),
              label: Text(AppLocalizations.of(context)!.meal),
            ),
            FloatingActionButton.extended(
              heroTag: 'workout_fab',
              onPressed: () => _showWorkoutForm(context),
              icon: const Icon(Icons.fitness_center),
              label: Text(AppLocalizations.of(context)!.workout),
            ),
          ],
        ),
      ),
    );
  }

  void _showMealForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateMealScreen(),
      ),
    );
  }

  void _showWorkoutForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateWorkoutScreen(),
      ),
    );
  }
}

class EventList extends ConsumerWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    final groupedEvents = _groupEventsByDay(events);

    return ListView.builder(
      itemCount: groupedEvents.length,
      itemBuilder: (context, index) {
        final date = groupedEvents.keys.elementAt(index);
        final dayEvents = groupedEvents[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _formatDate(date, context),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...dayEvents.map((event) => EventListItem(event: event)).toList(),
            if (index < groupedEvents.length - 1) const Divider(),
          ],
        );
      },
    );
  }

  Map<DateTime, List<Event>> _groupEventsByDay(List<Event> events) {
    final grouped = <DateTime, List<Event>>{};
    
    for (final event in events) {
      final date = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
      );
      
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(event);
    }

    return Map.fromEntries(
      grouped.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key))
    );
  }

  String _formatDate(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final locale = Localizations.localeOf(context).languageCode;

    if (date.year == now.year && 
        date.month == now.month && 
        date.day == now.day) {
      return AppLocalizations.of(context)!.today;
    } else if (date.year == yesterday.year && 
               date.month == yesterday.month && 
               date.day == yesterday.day) {
      return AppLocalizations.of(context)!.yesterday;
    } else if (date.year == tomorrow.year && 
               date.month == tomorrow.month && 
               date.day == tomorrow.day) {
      return AppLocalizations.of(context)!.tomorrow;
    }

    return DateFormat.yMMMMd(locale).format(date);
  }
}