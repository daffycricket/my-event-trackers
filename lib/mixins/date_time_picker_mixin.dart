import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin DateTimePickerMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  DateTime selectedDateTime = DateTime.now();

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
    );

    if (time == null || !context.mounted) return;

    final newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Vérification que la date n'est pas dans le futur
    if (newDateTime.isAfter(now)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La date ne peut pas être dans le futur')),
      );
      return;
    }

    setState(() {
      selectedDateTime = newDateTime;
    });
  }
} 