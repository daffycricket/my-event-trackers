enum UnitType {
  unit,     // unité (ex: 1 pomme)
  weight,   // grammes
  volume,   // centilitres
  serving;  // portion

  String getSymbol() {
    switch (this) {
      case UnitType.unit:
        return 'unité(s)';
      case UnitType.weight:
        return 'gr';
      case UnitType.volume:
        return 'cl';
      case UnitType.serving:
        return 'portion';
    }
  }

  bool isValid(int value) {
    return value > 0;  // Simplement un entier positif
  }
} 