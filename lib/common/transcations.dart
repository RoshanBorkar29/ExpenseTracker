import 'package:flutter/material.dart';

class Transcations extends StatefulWidget {
  final Icon icon;
  final String expenseName;
  final String price;
  const Transcations({super.key,required this.icon, required this.expenseName, required this.price});

  @override
  State<Transcations> createState() => _TranscationsState();
}

class _TranscationsState extends State<Transcations> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding:const EdgeInsets.all(12.0),
        child:Row(
          
          children: [
             Container(
              height: 40,
                width: 40,
              decoration:BoxDecoration(
                color: Colors.blue[800],
                
                shape:BoxShape.circle,
              ),
              child: Icon(widget.icon.icon)),
            
            //expense name and category belwo
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.expenseName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            //price
         const Spacer(flex: 1,),
      
              Text(
                '${widget.price}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            
        ],),
      ),
    );
  }
}