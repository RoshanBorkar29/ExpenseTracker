import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final Icon icon;
  final String name;
  // Renamed to highlight its purpose in the dark theme
  final Color backgroundColor; 
  final Color foregroundColor;
  final VoidCallback? onPressed;

  const Mybutton({
    super.key,
    required this.icon,
    required this.name,
    required this.backgroundColor,
    required this.foregroundColor, // Added foreground color for text/icon
    this.onPressed, required Color mycolor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // 🚀 FIX: Apply background color using styleFrom
        backgroundColor: backgroundColor, 
        // Set foreground color for text/icon
        foregroundColor: foregroundColor, 
        // Remove elevation/shadow in dark design
        elevation: 0, 
        minimumSize: const Size(double.infinity, 50), // Set min size for full width/height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        // Added styling for 'Upload from Gallery' button border
        side: backgroundColor == Colors.transparent 
              ? BorderSide(color: Colors.grey.shade700, width: 1.5) // Subtle border
              : null,
        padding: EdgeInsets.zero, // Remove default button padding
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon.icon, size: 20),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}