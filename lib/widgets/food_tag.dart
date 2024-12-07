import 'package:flutter/material.dart';

class FoodTag extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback? onTap;
  final bool isSelected;

  const FoodTag({
    required this.name,
    required this.color,
    this.onTap,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FilterChip(
        label: Text(name),
        selected: isSelected,
        onSelected: onTap == null ? null : (_) => onTap!(),
        backgroundColor: color.withOpacity(0.2),
        selectedColor: Colors.grey.withOpacity(0.3),
        labelStyle: TextStyle(
          color: isSelected ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
} 