class MealItem {
  final String name;
  final num quantity;

  const MealItem({
    required this.name,
    required this.quantity,
  });


  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
  };

  factory MealItem.fromJson(Map<String, dynamic> json) => MealItem(
    name: json['name'],
    quantity: json['quantity'],
  );

  @override
  String toString() => '$quantity $name';
} 


