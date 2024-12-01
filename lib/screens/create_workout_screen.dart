import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/providers/events_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';

class CreateWorkoutScreen extends ConsumerStatefulWidget {
  const CreateWorkoutScreen({super.key});

  @override
  ConsumerState<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends ConsumerState<CreateWorkoutScreen> {
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _notesController = TextEditingController();
  WorkoutType _selectedType = WorkoutType.cardio;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvel Entraînement'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<WorkoutType>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: "Type d'exercice"),
              items: WorkoutType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedType = value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Durée (minutes)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _caloriesController,
              decoration: const InputDecoration(
                labelText: 'Calories brûlées (optionnel)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            const Spacer(),
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
      id: const Uuid().v4(),
      title: _titleController.text,
      date: DateTime.now(),
      type: _selectedType,
      duration: Duration(minutes: int.parse(_durationController.text)),
      caloriesBurned: _caloriesController.text.isEmpty 
          ? null 
          : int.parse(_caloriesController.text),
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );
    
    ref.read(eventsProvider.notifier).addEvent(workout);
    Navigator.pop(context);
  }
} 