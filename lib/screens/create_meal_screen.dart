import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_event_tracker/data/static_food_data.dart';
import 'package:my_event_tracker/extensions/unit_type_ui_extension.dart';
import 'package:my_event_tracker/models/food_category.dart';
import 'package:my_event_tracker/models/food_reference.dart';
import 'package:my_event_tracker/providers/config_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import '../mixins/date_time_picker_mixin.dart';
import '../widgets/common_event_fields.dart';
import '../models/meal_item.dart';
import '../data/food_suggestions.dart';
import '../models/unit_type.dart';
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
  final List<FoodItemData> _foodItems = [];
  var _notesController = TextEditingController();
  late MealType _selectedType;

  @override
  void initState() {
    super.initState();
    
    if (widget.mealToEdit != null) {
      final meal = widget.mealToEdit!;
      _selectedType = meal.type;
      _notesController.text = meal.notes ?? '';
      selectedDateTime = meal.date;

      // Initialiser les aliments existants
      for (var food in meal.foods) {
        _foodItems.add(FoodItemData(
          id: food.name,
          label: food.name,
          quantityController: TextEditingController(text: food.quantity.toString()),
          unitType: UnitType.unit,
        ));
      }
    } else {
      _selectedType = MealType.snack;
      selectedDateTime = DateTime.now();
    }
  }

  void _removeFoodItem(int index) {
    if (index < 0 || index >= _foodItems.length) return;

    setState(() {
      _foodItems[index].quantityController.dispose();
      _foodItems.removeAt(index);
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

  Widget _buildSuggestions(BuildContext context) {
    final groupedSuggestions = <FoodCategory, List<FoodItem>>{};
    final suggestions = getFoodSuggestions(context);
    
    for (var food in suggestions) {
      groupedSuggestions.putIfAbsent(food.category, () => []).add(food);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedSuggestions.entries.map((entry) {
        final category = entry.key;
        final foods = entry.value;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                category.getName(context),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Wrap(
              children: foods.map((food) {
                final foodName = food.getName(context);
                final isSelected = _foodItems.any(
                  (item) => item.label == foodName
                );
                
                return FoodTag(
                  name: foodName,
                  color: food.category.color,
                  onTap: isSelected ? null : () => _addFoodItem(foodName),
                  isSelected: isSelected,
                );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }

  void _addFoodItem(String foodName) async {
    final foodReferences = await ref.read(foodReferencesProvider.future);
    final foodRef = foodReferences.firstWhere(
      (food) => food.name == foodName,
      orElse: () => FoodReference(
        name: foodName.toLowerCase().replaceAll(' ', '_'),
        label: foodName,
        category: FoodCategory.snacks,
        unitType: UnitType.unit,
        defaultQuantity: 1.0,
      ),
    );

    setState(() {
      _foodItems.add(FoodItemData(
        id: foodRef.name,
        label: foodRef.label,
        quantityController: TextEditingController(text: foodRef.defaultQuantity.toString()),
        unitType: foodRef.unitType,
      ));
    });
  }

  String _getLocalizedFoodName(AppLocalizations l10n, String foodName) {
    switch (foodName) {
      // Fruits
      case 'Apple':
        return l10n.foodApple;
      case 'Banana':
        return l10n.foodBanana;
      case 'Orange':
        return l10n.foodOrange;
      // Légumes
      case 'Carrot':
        return l10n.foodCarrot;
      case 'Tomato':
        return l10n.foodTomato;
      case 'Cucumber':
        return l10n.foodCucumber;
      // Protéines
      case 'Chicken':
        return l10n.foodChicken;
      case 'Beef':
        return l10n.foodBeef;
      case 'Fish':
        return l10n.foodFish;
      // Féculents
      case 'Rice':
        return l10n.foodRice;
      case 'Pasta':
        return l10n.foodPasta;
      case 'Bread':
        return l10n.foodBread;
      // Produits laitiers
      case 'Milk':
        return l10n.foodMilk;
      case 'Yogurt':
        return l10n.foodYogurt;
      case 'Cheese':
        return l10n.foodCheese;
      // Boissons
      case 'Water':
        return l10n.foodWater;
      case 'Coffee':
        return l10n.foodCoffee;
      case 'Tea':
        return l10n.foodTea;
      // Snacks
      case 'Cookies':
        return l10n.foodCookies;
      case 'Chips':
        return l10n.foodChips;
      case 'Nuts':
        return l10n.foodNuts;
      default:
        return foodName;
    }
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
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  final item = _foodItems[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(item.label),
                        ),
                        Text(
                          item.unitType.getSymbol(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 160,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QuantityInput(
                            unitType: item.unitType,
                            controller: item.quantityController,
                            onChanged: (value) {
                              item.quantityController.text = value;
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _removeFoodItem(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
              Text(
                l10n.suggestions,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildSuggestions(context),
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
    final foods = <MealItem>[];
    for (var item in _foodItems) {
      if (item.quantityController.text.isNotEmpty) {
        final quantity = num.tryParse(item.quantityController.text);
        if (quantity != null) {
          foods.add(MealItem(
            name: item.id,
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
    for (var item in _foodItems) {
      item.quantityController.dispose();
    }
    _notesController.dispose();
    super.dispose();
  }
}

class QuantityInput extends StatelessWidget {
  final UnitType unitType;
  final TextEditingController controller;
  final Function(String) onChanged;

  const QuantityInput({
    required this.unitType,
    required this.controller,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: TextFormField(
        controller: controller,
        keyboardType: unitType.getKeyboardType(),
        decoration: InputDecoration(
          labelText: 'Quantité',
          suffixText: unitType.getSymbol(),
          border: const OutlineInputBorder(),
        ),
        validator: unitType.validateQuantity,
        onChanged: onChanged,
      ),
    );
  }
}

class FoodItemData {
  final String id;
  final String label;
  final TextEditingController quantityController;
  final UnitType unitType;

  FoodItemData({
    required this.id,
    required this.label,
    required this.quantityController,
    required this.unitType,
  });
} 