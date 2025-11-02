import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/common/categoryitem.dart';
import 'package:google_fonts/google_fonts.dart';

class Categorytransactions extends StatefulWidget {
  final CategoryItem item;
  const Categorytransactions({super.key,required this.item});

  @override
  State<Categorytransactions> createState() => _CategorytransactionsState();
}

class _CategorytransactionsState extends State<Categorytransactions> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Left Section: Dot, Icon, and Text
          Row(
            children: [
              // 1. Colored Dot
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: widget.item.dotColor, // Use the specific category color
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              
              // 2. Icon and Text Details
              
              Padding(
                padding: const EdgeInsets.only(top:12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  children: [
                    Row(
                      
                      children: [
                        // Icon
                        Icon(widget.item.icon, size: 16, color: Colors.grey[400]),
                        const SizedBox(width: 8),
                        // Category Name
                        Text(
                          widget.item.name,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    // Percentage Subtext
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0), // Align percentage under name/icon
                      child: Text(
                        '${widget.item.percentage.toInt()}%',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Right Section: Amount
          Text(
            '\$${widget.item.amount.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}