// lib/models.dart/AddTransactionsModel.dart (The actual file name might be slightly different)

import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models.dart/transactionNotifier.dart';
import 'package:flutter_expense_tracker/models.dart/trascations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AddTransactions extends ConsumerStatefulWidget {
  const AddTransactions({super.key});

  @override
  ConsumerState<AddTransactions> createState() => AddTransactionsState();
}

class AddTransactionsState extends ConsumerState<AddTransactions> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final List<String> categoryNames = ['Food', 'Transport', 'Entertainment', 'Bills'];
  late String selectedCategoryName;

  @override
  void initState() {
    super.initState();
    // Set the default selection to the first category name
    selectedCategoryName = categoryNames[0]; 
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  // 🚀 New function to handle the Save button press 🚀
  // ignore: unused_element
void saveTransaction(){
  final String title=titleController.text;
  final double? amount=double.tryParse(amountController.text);
  if(title.isEmpty||amount==null){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content:Text('Please enter valid title and amount')),
    );
  }
  else{
    final category=getCategoryByName(selectedCategoryName);
    ref.read(transactionProvider.notifier).
    addTransaction(title: title, amount: amount, category: category);
  }
   Navigator.of(context).pop(); 
}


  @override
  Widget build(BuildContext context) {
    // NOTE: For better dark mode visuals, use dark theme AlertDialog/Modal or adjust colors here
    return Container(
      height: 300, // Increased height slightly
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
          const SizedBox(height: 16.0),
          
          DropdownButton<String>(
            value: selectedCategoryName,
            isExpanded: true,
            items: categoryNames.map((String catItem) {
              return DropdownMenuItem<String>(
                value: catItem,
                child: Text(catItem),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue == null) return;
              setState(() {
                selectedCategoryName = newValue;
              });
            },
          ),
          
          // ADD button is moved to AlertDialog actions in Step 4
        ],
      ),
    );
  }
}