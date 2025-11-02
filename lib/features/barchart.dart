import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/models.dart/category.dart';
import 'package:flutter_expense_tracker/models.dart/transactionNotifier.dart';
import 'package:flutter_expense_tracker/models.dart/trascations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';



class CategorySpending {
  final String categoryName;
  final double amount;
  final int categoryIndex;
  final Color color; 

  CategorySpending(this.categoryName, this.amount, this.categoryIndex, this.color);
}

class BarChartDatas extends ConsumerWidget {
  const BarChartDatas({super.key});

  // Function to transform the raw transaction list into CategorySpending data
List<CategorySpending> _getCategorySpendingData(List<Transaction> transactions) {
  

  final Map<Category, double> spendingMap = {};
  
  for (var tx in transactions) {
    if (tx.isExpense) { // Only count expenses for the spending chart
      
      spendingMap.update(
        tx.category,
        (value) => value + tx.amount, 
        ifAbsent: () => tx.amount,   
      );
    }
  }
  

  int indexCounter = 0; 
  
  return spendingMap.entries.map((entry) {
    final category = entry.key; 
    
   
    Color barColor = Colors.blue.shade300; 
    
    return CategorySpending(
      category.name,          
      entry.value,             
      indexCounter++,          
      barColor,
    );
  }).toList();
}
  

  List<BarChartGroupData> _buildBarGroups(List<CategorySpending> data) {
    return data.map((item) => BarChartGroupData(
      x: item.categoryIndex,
      barRods: [
        BarChartRodData(
          toY: item.amount,
          color: item.color,
          width: 15,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
      showingTooltipIndicators: [0], 
    )).toList();
  }


  FlTitlesData _getTitlesData(List<CategorySpending> data) {
    return FlTitlesData(
      show: true,
 
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            final item = data.firstWhere(
              (e) => e.categoryIndex == value.toInt(),
           
              orElse: () => CategorySpending('', 0, -1, Colors.white), 
            );
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 4,
              child: Text(
                item.categoryName,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            );
          },
        ),
      ),
      
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          // You might need a custom getTitlesWidget here for formatting
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the Riverpod provider to get the transaction list
    final transactionsList = ref.watch(transactionProvider);

    // 2. Process the data to get spending per category
    final categorySpendingData = _getCategorySpendingData(transactionsList);
    
    // 3. Handle Empty State
    if (categorySpendingData.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('No expenses recorded yet.', style: TextStyle(color: Colors.white54)),
        ),
      );
    }

    // 4. Build the BarChart Widget
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        height: 220, // Define a fixed height for the chart area
        child: BarChart(
          BarChartData(
            // Data and Structure
           barGroups: _buildBarGroups(categorySpendingData),
            
            // Layout and Titles
            titlesData: _getTitlesData(categorySpendingData),
            
            // Appearance
            alignment: BarChartAlignment.spaceAround,
            maxY: categorySpendingData.map((e) => e.amount).reduce((a, b) => a > b ? a : b) * 1.1, // Set MaxY slightly above max amount
            gridData: FlGridData(
             // show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => const FlLine(
                color: Colors.grey,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            
            // Interactivity (Optional)
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.grey.shade900.withOpacity(0.9),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '\$${rod.toY.toStringAsFixed(2)}',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}