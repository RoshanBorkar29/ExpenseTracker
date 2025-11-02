import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/common/categoryitem.dart' show CategoryItem;
import 'package:flutter_expense_tracker/common/categorytransactions.dart';
import 'package:flutter_expense_tracker/common/transactionsPage.dart';
import 'package:flutter_expense_tracker/common/transcations.dart';
import 'package:flutter_expense_tracker/models.dart/transactionNotifier.dart';
import 'package:flutter_expense_tracker/models.dart/trascations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 🚀 MUST IMPORT RIVERPOD
import 'package:google_fonts/google_fonts.dart';

 // Assuming this defines Categorytransactions

// Define consistent colors 
const Color kBackgroundColor = Color(0xFF1E1E1E); 
const Color kCardColor = Color(0xFF2C2C2C);
const Color kAccentColor = Color(0xFF00E5FF); 
const Color kGradientStart = Color(0xFF333333); 
const Color kGradientEnd = Color(0xFF1A1A1A);

// 🚀 FIX 1: Change from StatefulWidget to ConsumerWidget
class Homescreen extends ConsumerWidget {
  const Homescreen({super.key});

  // Helper to calculate data for the PieChart and breakdown list
  // NOTE: This logic now uses the live transactionList provided by Riverpod.
  Map<String, dynamic> _getChartData(List<Transaction> transactions) {
    final Map<String, double> categoryTotal = {};
    double totalExpense = 0;

    for (var t in transactions.where((t) => t.isExpense)) {
      categoryTotal.update(
        t.category.name,
        (value) => value + t.amount,
        ifAbsent: () => t.amount,
      );
      totalExpense += t.amount;
    }
    
    final List<CategoryItem> breakdown = [];
    final List<PieChartSectionData> sections = [];
    
    int index = 0;
    final fixedColors = [kAccentColor, const Color(0xFF8A2BE2), const Color(0xFFFF6347), const Color(0xFF40E0D0)];
    
    categoryTotal.forEach((name, amount) {
      final category = getCategoryByName(name); 
      final percentage = totalExpense > 0 ? (amount / totalExpense) * 100 : 0.0;
      final color = fixedColors[index % fixedColors.length];
      
      breakdown.add(CategoryItem(
        name: name,
        percentage: percentage,
        amount: amount,
        dotColor: color,
        icon: category.icon,
      ));

      sections.add(PieChartSectionData(
        color: color,
        value: percentage,
        title: '', 
        radius: 40, 
        borderSide: BorderSide.none,
      ));

      index++;
    });

    return {'breakdown': breakdown, 'sections': sections, 'totalExpense': totalExpense};
  }

  // Helper to build the chart widget
  Widget _buildPieChart(List<PieChartSectionData> sections) {
    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 30,
        sectionsSpace: 3,
        pieTouchData: PieTouchData(enabled: false), 
      ),
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) { // 🚀 WidgetRef ref is necessary
    // ----------------------------------------------------
    // 🚀 FIX 2: WATCH THE LIVE RIVERPOD STATE
    // ----------------------------------------------------
    final transactionList = ref.watch(transactionProvider);
    
    // Calculate live balance and chart data from the current state
    final balance = ref.read(transactionProvider.notifier).getTotalBalance();
    final totalBalance=ref.read(transactionProvider.notifier).getTotalExpenses();
    final chartData = _getChartData(transactionList);
    final recentTransactions = transactionList.reversed.toList();
    final List<CategoryItem> breakdownData = chartData['breakdown'];
    final List<PieChartSectionData> chartSections = chartData['sections'];


    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        toolbarHeight: 0, 
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Welcome Text ---
              Row(
                children: [
                  Text('Welcome back', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(width: 170),
                  Container(
                    height:50,
                    width: 100,
                   padding: const EdgeInsets.symmetric(vertical: 8,),
                    decoration: BoxDecoration(
                      
                      color: kGradientStart,
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                      boxShadow:[BoxShadow(
                        color: kCardColor.withOpacity(0.6),
                        blurRadius:8,
                        offset:const Offset(0,0),
                      )]
                    ),
                    child:Column(
                      children: [
                        Text(' Monthly Spending ', style: GoogleFonts.poppins(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                        Text('${totalBalance.toStringAsFixed(2)}', style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kAccentColor,
                          shadows:[Shadow(
                            blurRadius:8,
                            color:kAccentColor.withOpacity(0.6),
                            offset:const Offset(0,0),
                          )]
                        )),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Track your expenses smartly', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[400])),
                  const SizedBox(height: 25),
                  
                ],
              ),

              // --- Total Balance Card (LIVE DATA) ---

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6, 
                child: Container( 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), 
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft, 
                      end: Alignment.bottomRight, 
                      colors: [kGradientStart, kGradientEnd],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('Total Money Spend', style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 16)),
                        const SizedBox(height: 10),
                        Text(
                          '\$${balance.toStringAsFixed(2)}', // 🚀 LIVE BALANCE
                          style: GoogleFonts.poppins(
                            fontSize: 36, 
                            fontWeight: FontWeight.bold, 
                            color: kAccentColor,
                            shadows: [Shadow(blurRadius:8,color:kAccentColor.withOpacity(0.6),offset:const Offset(0,0))],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text('As of ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}', style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Monthly Spending Chart Card (LIVE CHART) ---
              Card(
                color: kCardColor, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Monthly Spending', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 16),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 1. Chart
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: chartSections.isEmpty 
                                ? Center(child: Text('No Expenses', style: TextStyle(color: Colors.grey[600])))
                                : _buildPieChart(chartSections), // 🚀 LIVE CHART
                          ),
                          const SizedBox(width: 20),
                          
                          // 2. Legend/Details (Live Breakdown)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: breakdownData.map((item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Categorytransactions(item: item), // LIVE LEGEND
                              )).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Recent Transactions List (LIVE LIST) ---
              Card(
                color: kCardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recent Transactions', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 10),
                      
                      if (recentTransactions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text('No transactions yet. Add your first expense!', style: TextStyle(color: Colors.grey[500])),
                          ),
                        )
                      else
                        // 🚀 DISPLAY LIVE TRANSACTIONS using the corrected Transcations widget
                        
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recentTransactions.length > 5 ? 5 : recentTransactions.length, 
                          itemBuilder: (context, index) {
                            final transaction = recentTransactions[index];
                            
                            // 🚀 FIX: Map the full Transaction object to the Transcations widget's three required properties
                            return Transcations(
                                icon: Icon(transaction.category.icon),
                                expenseName: transaction.title,
                                price: '${transaction.isExpense ? '-' : ''}\$${transaction.amount.toStringAsFixed(2)}',
                            );
                          },
                        ),
                        if(recentTransactions.length > 5)
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Transactionspage()),
                              );
                            },
                            child: Text('See All Transactions'),
                          ),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
