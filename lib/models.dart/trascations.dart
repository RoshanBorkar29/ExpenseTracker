import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models.dart/category.dart';
import 'package:uuid/uuid.dart';

// --- 1. Category Model ---


// --- 2. Transaction Model ---
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  final bool isExpense;

  // Constructor is clean
  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.isExpense = true,
  });
}

// --- 3. Initial Data and Helper ---
// ⚠️ FIX APPLIED HERE: Ensure this list is static and fully defined, 
// using a dedicated UUID instance for safe ID generation.
final _uuid = const Uuid();

final initialTransactions = [

];

// List of available category names
final List<String> categoryNames = ['Food', 'Transport', 'Entertainment', 'Bills'];

// Helper function to get the full Category object from its name
Category getCategoryByName(String name) {
  switch (name) {
    case 'Food': return Category(name: 'Food', icon: Icons.fastfood, color: Colors.orange,index: 0);
    case 'Transport': return Category(name: 'Transport', icon: Icons.directions_car, color: Colors.blue,index: 1);
    case 'Entertainment': return Category(name: 'Entertainment', icon: Icons.movie, color: Colors.purple,index: 2);
    case 'Bills': return Category(name: 'Bills', icon: Icons.receipt, color: Colors.red,index: 3);
    default: return Category(name: 'Other', icon: Icons.more_horiz, color: Colors.grey,index: 4);
  }
}
