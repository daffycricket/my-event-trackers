import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import '../mixins/date_time_picker_mixin.dart';
import '../widgets/common_event_fields.dart';
import '../models/food_item.dart';
import 'package:flutter/services.dart';

class CreateMealScreen extends ConsumerStatefulWidget {
  final MealEvent? mealToEdit;

  const CreateMealScreen({super.key, this.mealToEdit});

  @override
  ConsumerState<CreateMealScreen> createState() => _CreateMealScreenState();
}

class _CreateMealScreenState extends ConsumerState<CreateMealScreen> 
    with DateTimePickerMixin {
  final List<TextEditingController> _foodControllers = [];
  final List<TextEditingController> _quantityControllers = [];
  var _notesController = TextEditingController();
  late MealType _selectedType;

  @override
  void initState() {
    super.initState();
    final meal = widget.mealToEdit;
    if (meal != null) {
      for (final food in meal.foods) {
        _foodControllers.add(TextEditingController(text: food.name));
        _quantityControllers.add(TextEditingController(text: food.quantity.toString()));
      }
    } else {
      _addFoodItem(); // Ajouter un champ vide par défaut
    }
    _notesController = TextEditingController(text: meal?.notes ?? '');
    _selectedType = meal?.type ?? MealType.lunch;
    selectedDateTime = meal?.date ?? DateTime.now();
  }

  void _addFoodItem() {
    setState(() {
      _foodControllers.add(TextEditingController());
      _quantityControllers.add(TextEditingController());
    });
  }

  void _removeFoodItem(int index) {
    setState(() {
      _foodControllers[index].dispose();
      _quantityControllers[index].dispose();
      _foodControllers.removeAt(index);
      _quantityControllers.removeAt(index);
    });
  }

  String _getMealTypeText(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return 'Petit déjeuner';
      case MealType.lunch:
        return 'Déjeuner';
      case MealType.dinner:
        return 'Dîner';
      case MealType.snack:
        return 'Collation';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mealToEdit != null ? 'Modifier le repas' : 'Nouveau repas'),
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
                child: Text(_getMealTypeText(type)),
              )).toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _foodControllers.length + 1, // +1 pour le bouton d'ajout
                itemBuilder: (context, index) {
                  if (index == _foodControllers.length) {
                    return ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Ajouter un aliment'),
                      onTap: _addFoodItem,
                    );
                  }
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _quantityControllers[index],
                          decoration: const InputDecoration(
                            labelText: 'Quantité',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: _foodControllers[index],
                          decoration: const InputDecoration(
                            labelText: 'Aliment',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeFoodItem(index),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveMeal,
              child: Text(widget.mealToEdit != null ? 'Mettre à jour' : 'Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveMeal() {
    final foods = <FoodItem>[];
    for (var i = 0; i < _foodControllers.length; i++) {
      if (_foodControllers[i].text.isNotEmpty && _quantityControllers[i].text.isNotEmpty) {
        final quantity = num.tryParse(_quantityControllers[i].text);
        if (quantity != null) {
          foods.add(FoodItem(
            name: _foodControllers[i].text,
            quantity: quantity,
          ));
        }
      }
    }

    final meal = MealEvent(
      id: widget.mealToEdit?.id ?? const Uuid().v4(),
      date: selectedDateTime,
      type: _selectedType,
      foods: foods,
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
  void dispose() {
    for (var controller in _foodControllers) {
      controller.dispose();
    }
    for (var controller in _quantityControllers) {
      controller.dispose();
    }
    _notesController.dispose();
    super.dispose();
  }
} 