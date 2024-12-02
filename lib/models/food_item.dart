class FoodItem {
  final String name;
  final num quantity;

  const FoodItem({
    required this.name,
    required this.quantity,
  });

  @override
  String toString() => '$quantity $name';
} 