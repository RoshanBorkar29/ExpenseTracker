import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/features/anyltics.dart';
import 'package:flutter_expense_tracker/features/homescreen.dart';
import 'package:flutter_expense_tracker/models.dart/AddTransactionsModel.dart';
// import 'package:flutter_expense_tracker/features/scan.dart'; // Not needed for the FAB approach

class NavigationBarT extends StatefulWidget {
  const NavigationBarT({super.key}); // Added const for best practice

  @override
  State<NavigationBarT> createState() => _NavigationBarTState();
}

class _NavigationBarTState extends State<NavigationBarT> {
 
  int index = 0;

  // List of screens corresponding to the navigation bar items (Home and Analytics).
  final List<Widget> pages = [
    Homescreen(),
    Anyaltics(),
  ];

  // Handler to update the selected index.
  void onTapItem(int page) {
    setState(() {
      index = page;
    });
  }

  
 final GlobalKey<AddTransactionsState> _addTransactionKey=GlobalKey<AddTransactionsState>();
  void addExpense() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          
          title: Text('Add Expense'),
          content: AddTransactions(key:_addTransactionKey),
          actions: [
            TextButton(
              onPressed: () {
               _addTransactionKey.currentState?.saveTransaction();
              // print("Presesd");
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define a primary color for consistency (matching your desired look)
    const Color primaryRed = Color(0xFFE53935); // Example Red

    return Scaffold(
      body: pages[index],

      // 1. Define the Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: addExpense,
        backgroundColor:Color(0xFF2C2C2C), 
        shape: const CircleBorder(), 
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),

 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF333333), 
        
        shape: const CircularNotchedRectangle(),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        
        child: Row(
          
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // --- Left Items (Home) ---
            IconButton(
              icon: Icon(
                Icons.home,
                // Highlight the selected icon
                color: index == 0 ? Colors.white : Colors.white70,
              ),
              onPressed: () => onTapItem(0),
              tooltip: 'Home',
            ),

        
            
            // Analytics
            IconButton(
              icon: Icon(
                Icons.analytics,
                // Highlight the selected icon
                color: index == 1 ? Colors.white : Colors.white70,
              ),
              onPressed: () => onTapItem(1),
              tooltip: 'Analytics',
            ),
            
            // Search (Example of a non-page item)
         
          ],
        ),
      ),
    );
  }
}