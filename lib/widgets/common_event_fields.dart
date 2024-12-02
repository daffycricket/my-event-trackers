import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonEventFields extends StatelessWidget {
  final DateTime selectedDateTime;
  final Future<void> Function(BuildContext) onDateSelect;
  final TextEditingController notesController;

  const CommonEventFields({
    super.key,
    required this.selectedDateTime,
    required this.onDateSelect,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: Text(
            DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime),
          ),
          onTap: () => onDateSelect(context),
        ),
        TextField(
          controller: notesController,
          decoration: const InputDecoration(
            labelText: 'Notes',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
} 