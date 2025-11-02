import 'dart:ui';

import 'package:flutter/material.dart';

class CategoryItem{
  final String name;
  final double percentage;
  final double amount;
  final Color dotColor;
  final IconData icon;

  CategoryItem({
    required this.name,
    required this.percentage,
    required this.amount,
    required this.dotColor,
    required this.icon,
  });
}