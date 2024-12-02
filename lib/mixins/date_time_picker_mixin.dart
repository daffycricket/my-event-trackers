import 'package:flutter/material.dart';

mixin DateTimePickerMixin {
  late DateTime selectedDateTime;

  Future<void> selectDateTime(BuildContext context) async {
    final now = DateTime.now();
    
    if (!context.mounted) return;
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: now,
    );

    if (date == null || !context.mounted) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      builder: (BuildContext context, Widget? child) {
        // Désactiver les heures futures si on est aujourd'hui
        if (date.year == now.year && 
            date.month == now.month && 
            date.day == now.day) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                  hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.selected)
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface),
                ),
              ),
              child: child!,
            ),
          );
        }
        return child!;
      },
    );

    if (time == null || !context.mounted) return;

    final newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Vérifier si la date/heure sélectionnée n'est pas dans le futur
    if (newDateTime.isAfter(now)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible de sélectionner une date future'),
          ),
        );
      }
      return;
    }

    selectedDateTime = newDateTime;
  }
} 