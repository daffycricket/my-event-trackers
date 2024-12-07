import 'package:flutter/material.dart';
import '../models/unit_type.dart';

extension UnitTypeUI on UnitType {
  TextInputType getKeyboardType() {
    return TextInputType.number;
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) return 'Quantité requise';
    
    final number = int.tryParse(value);
    if (number == null) return 'Nombre entier requis';
    
    if (!isValid(number)) {
      return 'Nombre entier positif requis';
    }
    return null;
  }
} 