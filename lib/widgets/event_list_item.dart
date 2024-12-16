import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/extensions/event_ui_extensions.dart';
import 'package:my_event_tracker/models/food_reference.dart';
import 'package:my_event_tracker/providers/config_provider.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/meal_detail_screen.dart';
import '../screens/workout_detail_screen.dart';

class EventListItem extends ConsumerWidget {
  final Event event;

  const EventListItem({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(event.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteEventTitle),
          content: Text(AppLocalizations.of(context)!.deleteEventConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) async {
        final deletedEvent = event;
        try {
          await ref.read(eventsProvider.notifier).deleteEvent(event.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.eventDeleted),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.undo,
                  onPressed: () {
                    ref.read(eventsProvider.notifier).addEvent(deletedEvent);
                  },
                ),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.deleteEventError)),
            );
            // Forcer la reconstruction de la liste pour restaurer l'élément
            ref.refresh(eventsProvider);
          }
        }
      },
      child: ListTile(
        leading: Icon(
          event is MealEvent ? Icons.restaurant : Icons.fitness_center,
          color: event is MealEvent ? Colors.orange : Colors.blue,
        ),
        title: Text(_getEventTitle(event, context)),
        subtitle: _buildSubtitle(event, context, ref),
        trailing: Text(
          '${event.date.hour}:${event.date.minute.toString().padLeft(2, '0')}',
        ),
        onTap: () {
          if (event is MealEvent) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealDetailScreen(meal: event as MealEvent),
              ),
            );
          } else if (event is WorkoutEvent) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDetailScreen(workout: event as WorkoutEvent),
              ),
            );
          }
        },
      ),
    );
  }

String _getEventTitle(Event event, BuildContext context) {
  final localizations = AppLocalizations.of(context);
  if (localizations == null) return ''; // Gestion du cas où les localisations ne sont pas disponibles
  
  if (event is MealEvent) {
    return event.type.getName(context);
  } else if (event is WorkoutEvent) {
    return event.type.getName(context);
  }
  return 'UNKNOWN_TYPE';
}

  Widget _buildSubtitle(Event event, BuildContext context, WidgetRef ref) {
    if (event is MealEvent) {

    return FutureBuilder<List<FoodReference>>(
          future: ref.read(foodReferencesProvider.future),
          builder: (context, snapshot) {
            // Gérer les états de chargement et d'erreur
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            final foodReferences = snapshot.data!;

            // Utiliser les données
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.foods.isNotEmpty)
                    Text(event.foods.map((f) => foodReferences.firstWhere((food) => food.name == f.name).label).join(', ')),
                  if (event.notes != null && event.notes!.isNotEmpty)
                    Text(event.notes!),

                ],
              );
          }
        );
    } else if (event is WorkoutEvent) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.duration.inMinutes > 0 || event.caloriesBurned != null)
            Text([
              if (event.duration.inMinutes > 0) '${event.duration.inMinutes} min',
              if (event.caloriesBurned != null) '${event.caloriesBurned} kcal',
            ].join(' - ')),
          if (event.notes != null && event.notes!.isNotEmpty)
            Text(event.notes!),
        ],
      );
    }
    return const SizedBox.shrink();
  }
} 