//import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models.dart/category.dart';
import 'package:flutter_expense_tracker/models.dart/trascations.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // Import models (Transaction, Category, initialTransactions)
import 'package:uuid/uuid.dart';


class TransactionNotifier extends StateNotifier<List<Transaction>> {

  TransactionNotifier() : super(initialTransactions.cast<Transaction>());

  final _uuid = const Uuid();

  
  void addTransaction({
    required String title,
    required double amount,
    required Category category,
  }) {
    final newTransaction = Transaction(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      date: DateTime.now(),
      category: category,
      isExpense: true, // Assuming default is expense
    );
    
    // This creates a new list and updates the state (required by Riverpod)
    state = [...state, newTransaction]; 
  }

  // Helper method to calculate and return the current balance
  double getTotalBalance() {
    return state.fold(
      0.0,
      (total, transaction) => transaction.isExpense
          ? total - transaction.amount
          : total + transaction.amount,
    );
  }
  double getTotalExpenses(){
    return state.fold(
      0.0,
      (total, transaction) => transaction.isExpense
          ? total + transaction.amount
          : total,
    );
  }
}

// The global provider used by the UI to interact with the state
final transactionProvider = 
    StateNotifierProvider<TransactionNotifier, List<Transaction>>(
  (ref) => TransactionNotifier(),
);

// ❌ REMOVED: getCategoryByName function, as it exists in lib/models/transaction.dart
