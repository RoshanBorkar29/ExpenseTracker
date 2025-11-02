import 'package:flutter/material.dart';

import 'package:flutter_expense_tracker/common/transcations.dart';
import 'package:flutter_expense_tracker/models.dart/transactionNotifier.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


class Transactionspage extends ConsumerWidget {
  const Transactionspage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    final transactionsList = ref.watch(transactionProvider);

    final recentTransactions = transactionsList.reversed.toList();

    return Scaffold(
      backgroundColor:Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('All Recent Transactions',style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF272727),
      ),
      body: recentTransactions.isEmpty
          ? const Center(
              child: Text('No transactions yet! Add one to see it here.'),
            )
          : ListView.builder(
              itemCount: recentTransactions.length,
              itemBuilder: (context, index) {
                final transaction = recentTransactions[index];
                
                // Determine the sign and currency formatting
                final String formattedPrice = 
                    '${transaction.isExpense ? '-' : ''}\$${transaction.amount.toStringAsFixed(2)}';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Transcations(
                    // Assuming your Transaction model has a 'category' field which has an 'icon' property
                    icon: Icon(transaction.category.icon), 
                    expenseName: transaction.title,
                    price: formattedPrice,
                  ),
                );
              },
            ),
    );
  }
}

