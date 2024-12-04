import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import '../mixins/date_time_picker_mixin.dart';
import '../widgets/common_event_fields.dart';
import '../models/food_item.dart';
import 'package:flutter/services.dart';
import '../data/food_suggestions.dart';
import '../widgets/food_tag.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    }
    _notesController = TextEditingController(text: meal?.notes ?? '');
    _selectedType = meal?.type ?? MealType.lunch;
    selectedDateTime = meal?.date ?? DateTime.now();
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
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case MealType.breakfast:
        return l10n.breakfast;
      case MealType.lunch:
        return l10n.lunch;
      case MealType.dinner:
        return l10n.dinner;
      case MealType.snack:
        return l10n.snack;
    }
  }

  Widget _buildSuggestions() {
    // Grouper les suggestions par catégorie
    final groupedSuggestions = <FoodCategory, List<CategoryFood>>{};
    for (var food in foodSuggestions) {
      groupedSuggestions.putIfAbsent(food.category, () => []).add(food);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedSuggestions.entries.map((entry) {
        final category = entry.key;
        final foods = entry.value;
        
        // Filtrer les aliments déjà sélectionnés
        final availableFoods = foods.where(
          (food) => !_foodControllers.map((c) => c.text).contains(food.name)
        ).toList();

        if (availableFoods.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Wrap(
              children: availableFoods.map((food) => FoodTag(
                name: food.name,
                color: food.category.color,
                onTap: () {
                  setState(() {
                    _foodControllers.add(TextEditingController(text: food.name));
                    _quantityControllers.add(TextEditingController(text: '1'));
                  });
                },
              )).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mealToEdit != null ? l10n.editMeal : l10n.newMeal),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                l10n.selectedFoods,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _foodControllers.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_foodControllers[index].text),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: _quantityControllers[index],
                          decoration: InputDecoration(
                            labelText: l10n.quantity,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeFoodItem(index),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Text(
                l10n.suggestions,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildSuggestions(),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _saveMeal,
                  child: Text(widget.mealToEdit != null ? l10n.update : l10n.save),
                ),
              ),
            ],
          ),
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