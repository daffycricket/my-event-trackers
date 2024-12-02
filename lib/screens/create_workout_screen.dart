import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/providers/events_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import 'package:intl/intl.dart';

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
  DateTime _selectedDateTime = DateTime.now();

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

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
            ListTile(
              title: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDateTime,
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
      date: _selectedDateTime,
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