import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import 'event_list_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      final date = DateTime(event.date.year, event.date.month, event.date.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(event);
    }
    return Map.fromEntries(grouped.entries.toList()..sort((a, b) => b.key.compareTo(a.key)));
  }

  String _formatDate(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final locale = Localizations.localeOf(context).languageCode;

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return AppLocalizations.of(context)!.today;
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return AppLocalizations.of(context)!.yesterday;
    } else if (date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day) {
      return AppLocalizations.of(context)!.tomorrow;
    }
    return DateFormat.yMMMMd(locale).format(date);
  }
} 