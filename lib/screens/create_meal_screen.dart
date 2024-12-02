import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/providers/events_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import 'package:intl/intl.dart';

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
            ListTile(
              title: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDateTime,
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
      date: _selectedDateTime,
      type: _selectedType,
      foods: _foodsController.text.split(',').map((e) => e.trim()).toList(),
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );
    
    ref.read(eventsProvider.notifier).addEvent(meal);
    Navigator.pop(context);
  }
} 