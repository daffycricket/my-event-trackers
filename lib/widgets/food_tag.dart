import 'package:flutter/material.dart';

class FoodTag extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback onTap;

  const FoodTag({
    super.key,
    required this.name,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: onTap,
        child: Chip(
          label: Text(name),
          backgroundColor: color,
        ),
      ),
    );
  }
} 