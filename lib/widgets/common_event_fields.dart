import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonEventFields extends StatelessWidget {
  final TextEditingController titleController;
  final DateTime selectedDateTime;
  final Function() onDateSelect;
  final TextEditingController? notesController;

  const CommonEventFields({
    super.key,
    required this.titleController,
    required this.selectedDateTime,
    required this.onDateSelect,
    this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Titre'),
        ),
        const SizedBox(height: 16),
        ListTile(
          title: Text(
            DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime),
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: onDateSelect,
        ),
        if (notesController != null) ...[
          const SizedBox(height: 16),
          TextField(
            controller: notesController!,
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 3,
          ),
        ],
      ],
    );
  }
} 