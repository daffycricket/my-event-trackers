import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import '../mixins/date_time_picker_mixin.dart';
import '../widgets/common_event_fields.dart';

class CreateWorkoutScreen extends ConsumerStatefulWidget {
  final WorkoutEvent? workoutToEdit;

  const CreateWorkoutScreen({super.key, this.workoutToEdit});

  @override
  ConsumerState<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends ConsumerState<CreateWorkoutScreen>
    with DateTimePickerMixin {
  late final TextEditingController _titleController;
  late final TextEditingController _durationController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _notesController;
  late WorkoutType _selectedType;

  @override
  void initState() {
    super.initState();
    final workout = widget.workoutToEdit;
    _titleController = TextEditingController(text: workout?.title ?? '');
    _durationController = TextEditingController(
        text: workout?.duration.inMinutes.toString() ?? '');
    _caloriesController = TextEditingController(
        text: workout?.caloriesBurned?.toString() ?? '');
    _notesController = TextEditingController(text: workout?.notes ?? '');
    _selectedType = workout?.type ?? WorkoutType.cardio;
    selectedDateTime = workout?.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.workoutToEdit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier l\'entraînement' : 'Nouvel Entraînement'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CommonEventFields(
              titleController: _titleController,
              selectedDateTime: selectedDateTime,
              onDateSelect: selectDateTime,
              notesController: _notesController,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<WorkoutType>(
              value: _selectedType,
              onChanged: (value) => setState(() => _selectedType = value!),
              items: WorkoutType.values.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type.name),
              )).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Durée (minutes)'),
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _caloriesController,
              decoration: const InputDecoration(labelText: 'Calories brûlées'),
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveWorkout,
              child: Text(isEditing ? 'Mettre à jour' : 'Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveWorkout() {
    final workout = WorkoutEvent(
      id: widget.workoutToEdit?.id ?? const Uuid().v4(),
      title: _titleController.text,
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

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }
} 