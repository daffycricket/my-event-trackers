import 'package:flutter/material.dart';

enum FoodCategory {
  fruit, legume, produitLaitier, viande, volaille, poisson,
  oeuf, feculent, boulangerie, patisserie, platsComposes,
  snack, boisson, sauce,
}

class CategoryFood {
  final String name;
  final FoodCategory category;

  const CategoryFood({
    required this.name,
    required this.category,
  });
}

extension FoodCategoryColor on FoodCategory {
  Color get color {
    switch (this) {
      case FoodCategory.fruit:
        return Colors.red.shade200;
      case FoodCategory.legume:
        return Colors.green.shade200;
      case FoodCategory.produitLaitier:
        return Colors.blue.shade200;
      case FoodCategory.viande:
        return Colors.red.shade400;
      case FoodCategory.volaille:
        return Colors.orange.shade200;
      case FoodCategory.poisson:
        return Colors.blue.shade400;
      case FoodCategory.oeuf:
        return Colors.yellow.shade200;
      case FoodCategory.feculent:
        return Colors.brown.shade200;
      case FoodCategory.boulangerie:
        return Colors.brown.shade300;
      case FoodCategory.patisserie:
        return Colors.pink.shade200;
      case FoodCategory.platsComposes:
        return Colors.purple.shade200;
      case FoodCategory.snack:
        return Colors.orange.shade300;
      case FoodCategory.boisson:
        return Colors.lightBlue.shade200;
      case FoodCategory.sauce:
        return Colors.amber.shade200;
    }
  }
}

const foodSuggestions = [
  // Fruit
  CategoryFood(name: 'Pomme', category: FoodCategory.fruit),
  CategoryFood(name: 'Banane', category: FoodCategory.fruit),
  CategoryFood(name: 'Orange', category: FoodCategory.fruit),
  CategoryFood(name: 'Poire', category: FoodCategory.fruit),
  CategoryFood(name: 'Raisin', category: FoodCategory.fruit),
  CategoryFood(name: 'Fraise', category: FoodCategory.fruit),
  CategoryFood(name: 'Abricot sec', category: FoodCategory.fruit),
  
  // Légumes
  CategoryFood(name: 'Carotte', category: FoodCategory.legume),
  CategoryFood(name: 'Tomate', category: FoodCategory.legume),
  CategoryFood(name: 'Salade', category: FoodCategory.legume),
  CategoryFood(name: 'Courgette', category: FoodCategory.legume),
  CategoryFood(name: 'Haricots verts', category: FoodCategory.legume),
  CategoryFood(name: 'Épinards', category: FoodCategory.legume),
  CategoryFood(name: 'Lentilles', category: FoodCategory.legume),
  
  // Produits laitiers
  CategoryFood(name: 'Yaourt nature', category: FoodCategory.produitLaitier),
  CategoryFood(name: 'Fromage blanc', category: FoodCategory.produitLaitier),
  CategoryFood(name: 'Camembert', category: FoodCategory.produitLaitier),
  CategoryFood(name: 'Emmental', category: FoodCategory.produitLaitier),
  CategoryFood(name: 'Lait', category: FoodCategory.produitLaitier),
  
  // Viandes
  CategoryFood(name: 'Steak haché', category: FoodCategory.viande),
  CategoryFood(name: 'Côte de bœuf', category: FoodCategory.viande),
  CategoryFood(name: 'Côtelette de porc', category: FoodCategory.viande),
  CategoryFood(name: 'Gigot d\'agneau', category: FoodCategory.viande),
  CategoryFood(name: 'Jambon blanc', category: FoodCategory.viande),
  
  // Volailles
  CategoryFood(name: 'Blanc de poulet', category: FoodCategory.volaille),
  CategoryFood(name: 'Cuisse de poulet', category: FoodCategory.volaille),
  CategoryFood(name: 'Escalope de dinde', category: FoodCategory.volaille),
  CategoryFood(name: 'Magret de canard', category: FoodCategory.volaille),
  
  // Poissons
  CategoryFood(name: 'Saumon', category: FoodCategory.poisson),
  CategoryFood(name: 'Thon', category: FoodCategory.poisson),
  CategoryFood(name: 'Cabillaud', category: FoodCategory.poisson),
  CategoryFood(name: 'Crevettes', category: FoodCategory.poisson),
  CategoryFood(name: 'Moules', category: FoodCategory.poisson),
  
  // Œufs
  CategoryFood(name: 'Œuf', category: FoodCategory.oeuf),
  CategoryFood(name: 'Omelette', category: FoodCategory.oeuf),
  
  // Féculents
  CategoryFood(name: 'Riz blanc', category: FoodCategory.feculent),
  CategoryFood(name: 'Pâtes', category: FoodCategory.feculent),
  CategoryFood(name: 'Pomme de terre', category: FoodCategory.feculent),
  CategoryFood(name: 'Semoule', category: FoodCategory.feculent),
  CategoryFood(name: 'Quinoa', category: FoodCategory.feculent),
  
  // Boulangerie
  CategoryFood(name: 'Baguette', category: FoodCategory.boulangerie),
  CategoryFood(name: 'Pain complet', category: FoodCategory.boulangerie),
  CategoryFood(name: 'Croissant', category: FoodCategory.boulangerie),
  CategoryFood(name: 'Pain au chocolat', category: FoodCategory.boulangerie),
  
  // Pâtisseries
  CategoryFood(name: 'Éclair chocolat', category: FoodCategory.patisserie),
  CategoryFood(name: 'Tarte aux pommes', category: FoodCategory.patisserie),
  CategoryFood(name: 'Gâteau yaourt', category: FoodCategory.patisserie),
  CategoryFood(name: 'Brownie', category: FoodCategory.patisserie),
  
  // Plats composés
  CategoryFood(name: 'Pizza', category: FoodCategory.platsComposes),
  CategoryFood(name: 'Lasagnes', category: FoodCategory.platsComposes),
  CategoryFood(name: 'Quiche lorraine', category: FoodCategory.platsComposes),
  CategoryFood(name: 'Couscous', category: FoodCategory.platsComposes),
  CategoryFood(name: 'Hachis parmentier', category: FoodCategory.platsComposes),
  
  // Snacks
  CategoryFood(name: 'Chips', category: FoodCategory.snack),
  CategoryFood(name: 'Cacahuètes', category: FoodCategory.snack),
  CategoryFood(name: 'Biscuits salés', category: FoodCategory.snack),
  CategoryFood(name: 'Fruits secs', category: FoodCategory.snack),
  
  // Boissons
  CategoryFood(name: 'Eau', category: FoodCategory.boisson),
  CategoryFood(name: 'Café', category: FoodCategory.boisson),
  CategoryFood(name: 'Thé', category: FoodCategory.boisson),
  CategoryFood(name: 'Jus d\'orange', category: FoodCategory.boisson),
  CategoryFood(name: 'Soda', category: FoodCategory.boisson),
  
  // Sauces et condiments
  CategoryFood(name: 'Mayonnaise', category: FoodCategory.sauce),
  CategoryFood(name: 'Ketchup', category: FoodCategory.sauce),
  CategoryFood(name: 'Moutarde', category: FoodCategory.sauce),
  CategoryFood(name: 'Vinaigrette', category: FoodCategory.sauce),
]; 