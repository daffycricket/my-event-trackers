import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import '../mixins/date_time_picker_mixin.dart';

class CreateWorkoutScreen extends ConsumerStatefulWidget {
  final WorkoutEvent? workoutToEdit;

  const CreateWorkoutScreen({super.key, this.workoutToEdit});

  @override
  ConsumerState<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends ConsumerState<CreateWorkoutScreen>
    with DateTimePickerMixin {
  var _durationController = TextEditingController();
  var _caloriesController = TextEditingController();
  var _notesController = TextEditingController();
  late WorkoutType _selectedType;

  @override
  void initState() {
    super.initState();
    final workout = widget.workoutToEdit;
    _selectedType = workout?.type ?? WorkoutType.strength;
    selectedDateTime = workout?.date ?? DateTime.now();
    _durationController = TextEditingController(
      text: workout?.duration.inMinutes.toString() ?? '',
    );
    _caloriesController = TextEditingController(
      text: workout?.caloriesBurned?.toString() ?? '',
    );
    _notesController = TextEditingController(text: workout?.notes ?? '');
  }

  String _getWorkoutTypeText(WorkoutType type) {
    return type.name.toLowerCase().replaceFirst(RegExp(r'^[a-z]'), String.fromCharCode(type.name.codeUnitAt(0) - 32));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutToEdit != null ? 'Modifier la séance' : 'Nouvelle séance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type de workout
            Text(
              'Type d\'activité',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<WorkoutType>(
              value: _selectedType,
              onChanged: (value) => setState(() => _selectedType = value!),
              items: WorkoutType.values.map((type) => DropdownMenuItem(
                value: type,
                child: Text(_getWorkoutTypeText(type)),
              )).toList(),
            ),
            const SizedBox(height: 24),

            // Date et heure
            Text(
              'Date et heure',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime),
              ),
              onTap: () => selectDateTime(context),
            ),
            const SizedBox(height: 24),

            // Notes
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ajouter des notes...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Durée et calories (optionnel)
            Text(
              'Détails additionnels',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Durée (minutes)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _caloriesController,
                    decoration: const InputDecoration(
                      labelText: 'Calories',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bouton de sauvegarde
            Center(
              child: ElevatedButton(
                onPressed: _saveWorkout,
                child: Text(
                  widget.workoutToEdit != null ? 'Mettre à jour' : 'Sauvegarder',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveWorkout() {
    if (_durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir une durée')),
      );
      return;
    }

    final workout = WorkoutEvent(
      id: widget.workoutToEdit?.id ?? const Uuid().v4(),
      date: selectedDateTime,
      type: _selectedType,
      duration: Duration(minutes: int.parse(_durationController.text)),
      caloriesBurned: _caloriesController.text.isNotEmpty
          ? int.parse(_caloriesController.text)
          : null,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    final notifier = ref.read(eventsProvider.notifier);
    if (widget.workoutToEdit != null) {
      notifier.updateEvent(workout);
    } else {
      notifier.addEvent(workout);
    }
    Navigator.pop(context);
  }
} 