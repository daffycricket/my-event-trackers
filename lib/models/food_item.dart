class FoodItem {
  final String name;
  final num quantity;

  const FoodItem({
    required this.name,
    required this.quantity,
  });


  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
  };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    name: json['name'],
    quantity: json['quantity'],
  );

  @override
  String toString() => '$quantity $name';
} 


