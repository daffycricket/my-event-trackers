import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
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
    _durationController = TextEditingController(
        text: workout?.duration.inMinutes.toString() ?? '');
    _caloriesController = TextEditingController(
        text: workout?.caloriesBurned?.toString() ?? '');
    _notesController = TextEditingController(text: workout?.notes ?? '');
    _selectedType = workout?.type ?? WorkoutType.cardio;
    selectedDateTime = workout?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un entraînement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ajoutez ici les champs de saisie pour la durée, les calories, les notes, etc.
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Durée (minutes)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _caloriesController,
              decoration: const InputDecoration(labelText: 'Calories brûlées'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            // Ajoutez un bouton pour enregistrer l'entraînement
            ElevatedButton(
              onPressed: _saveWorkout,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveWorkout() {
    final workout = WorkoutEvent(
      id: widget.workoutToEdit?.id ?? const Uuid().v4(),
      date: selectedDateTime,
      type: _selectedType,
      duration: Duration(minutes: int.parse(_durationController.text)),
      caloriesBurned: _caloriesController.text.isEmpty
          ? null
          : int.parse(_caloriesController.text),
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