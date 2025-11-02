import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/features/barchart.dart';
import 'package:flutter_expense_tracker/models.dart/transactionNotifier.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Define consistent colors 
const Color kBackgroundColor = Color(0xFF1E1E1E); 
const Color kCardColor = Color(0xFF2C2C2C);
const Color kAccentColor = Color(0xFF00E5FF); 


final selectedPeriodProvider = StateProvider<String>((ref) => 'October 2025');


class Anyaltics extends ConsumerWidget {
  const Anyaltics({super.key});
 
// Returns a list of the last 3 months as period options
List<String> periodOptions() {
  final dateNow = DateTime.now();
  List<String> periods = [];
  final formatter = DateFormat('MMMM yyyy');
  for (int i = 0; i < 3; i++) {
    final month = DateTime(dateNow.year, dateNow.month - i, 1);
    periods.add(formatter.format(month));
  }
  periods.add('Last 3 Months');
    periods.add('Last 6 Months');
    
    return periods;
 
}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
    final selectedPeriod = 'October 2025';
    
    // Read the total balance from the transaction notifier. 
    // This triggers a calculation every time the transaction list (state) changes.
    final double balance = ref.read(transactionProvider.notifier).getTotalBalance();
    
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Text
            Text('Analytics', style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
            // Subtext
            Text('Overview of your activity', style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey[500],
            )),
            const SizedBox(height: 20),

            // Time Period Drop Down Menu
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Time Period', style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
                  
                  // Dropdown Menu container
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kBackgroundColor, 
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        // 🚀 USE LIVE STATE: The selected period now matches Riverpod's state
                        value: selectedPeriod,
                        icon: Icon(Icons.arrow_drop_down, color: kAccentColor),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        dropdownColor: kCardColor,
                        items: periodOptions()
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            // 🚀 UPDATE RIVERPOD: Update the state provider when selection changes
                            ref.read(selectedPeriodProvider.notifier).state = newValue;
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Container with Graph (Spending by Category)
            Container(
              height: 400,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Spending by Category', style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )),
                      Text('Total Spent: \$${balance.toStringAsFixed(2)}', style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kAccentColor,
                      )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Graph Placeholder Area - THIS is where the BarChart will go
                  Expanded(
                    child: Center(
                     child: BarChartDatas(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            
            const SizedBox(height: 15),

            // AI Insights Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Insights', style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  )),
                  const SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.insights, color: kAccentColor),
                    title: Text(
                      'You spent 20% more on dining out this month compared to last month.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
