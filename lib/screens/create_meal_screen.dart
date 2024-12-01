import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/providers/events_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';

class CreateMealScreen extends ConsumerStatefulWidget {
  const CreateMealScreen({super.key});

  @override
  ConsumerState<CreateMealScreen> createState() => _CreateMealScreenState();
}

class _CreateMealScreenState extends ConsumerState<CreateMealScreen> {
  final _titleController = TextEditingController();
  final _foodsController = TextEditingController();
  final _notesController = TextEditingController();
  MealType _selectedType = MealType.lunch;

  @override
  void dispose() {
    _titleController.dispose();
    _foodsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Repas'),
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
            DropdownButtonFormField<MealType>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Type de repas'),
              items: MealType.values.map((type) {
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
              controller: _foodsController,
              decoration: const InputDecoration(
                labelText: 'Aliments (séparés par des virgules)',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveMeal,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveMeal() {
    final meal = MealEvent(
      id: const Uuid().v4(),
      title: _titleController.text,
      date: DateTime.now(),
      type: _selectedType,
      foods: _foodsController.text.split(',').map((e) => e.trim()).toList(),
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );
    
    ref.read(eventsProvider.notifier).addEvent(meal);
    Navigator.pop(context);
  }
} 