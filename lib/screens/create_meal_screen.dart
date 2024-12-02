import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import '../mixins/date_time_picker_mixin.dart';
import '../widgets/common_event_fields.dart';

class CreateMealScreen extends ConsumerStatefulWidget {
  final MealEvent? mealToEdit;

  const CreateMealScreen({super.key, this.mealToEdit});

  @override
  ConsumerState<CreateMealScreen> createState() => _CreateMealScreenState();
}

class _CreateMealScreenState extends ConsumerState<CreateMealScreen> 
    with DateTimePickerMixin {
  var _foodsController = TextEditingController();
  var _notesController = TextEditingController();
  late MealType _selectedType;

  @override
  void initState() {
    super.initState();
    final meal = widget.mealToEdit;
    _foodsController = TextEditingController(text: meal?.foods.join(', ') ?? '');
    _notesController = TextEditingController(text: meal?.notes ?? '');
    _selectedType = meal?.type ?? MealType.lunch;
    selectedDateTime = meal?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _foodsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveMeal() {
    final meal = MealEvent(
      id: widget.mealToEdit?.id ?? const Uuid().v4(),
      date: selectedDateTime,
      type: _selectedType,
      foods: _foodsController.text.split(',').map((e) => e.trim()).toList(),
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );
    
    final notifier = ref.read(eventsProvider.notifier);
    if (widget.mealToEdit != null) {
      notifier.updateEvent(meal);
    } else {
      notifier.addEvent(meal);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.mealToEdit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier le repas' : 'Nouveau Repas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CommonEventFields(
              selectedDateTime: selectedDateTime,
              onDateSelect: selectDateTime,
              notesController: _notesController,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MealType>(
              value: _selectedType,
              onChanged: (value) => setState(() => _selectedType = value!),
              items: MealType.values.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type.name),
              )).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _foodsController,
              decoration: const InputDecoration(
                labelText: 'Aliments (séparés par des virgules)',
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveMeal,
              child: Text(isEditing ? 'Mettre à jour' : 'Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }
} 