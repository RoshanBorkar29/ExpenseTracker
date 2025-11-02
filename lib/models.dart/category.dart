import 'package:flutter/material.dart';

// 1. Category Model
class Category {
  final String name;
  final IconData icon;
  final Color color;
  final int index;

  Category({
    required this.name,
    required this.icon,
    required this.color,
    required this.index
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    
    return other is Category &&
        other.index == index; // Use 'index' or 'name' as the unique identifier
  }

  // 🎯 CRITICAL FIX 2: Override the hashCode
  // If two objects are equal (==), they MUST have the same hash code.
  @override
  int get hashCode => index.hashCode;
}