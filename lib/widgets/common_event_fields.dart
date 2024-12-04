import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
          decoration: InputDecoration(
            labelText: l10n.notes,
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
} 