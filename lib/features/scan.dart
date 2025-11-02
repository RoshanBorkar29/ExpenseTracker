import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/common/mybutton.dart';
import 'package:flutter_expense_tracker/models.dart/AddTransactionsModel.dart';
import 'package:flutter_expense_tracker/models.dart/parsedData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Scan extends ConsumerStatefulWidget {
  const Scan({super.key});

  @override
  ConsumerState<Scan> createState() => _ScanState();
}

class _ScanState extends ConsumerState<Scan> {
  final ImagePicker _picker=ImagePicker();
  late final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
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
 void openCamera() async {
    try {
      final XFile? imageFile = await _picker.pickImage(source: ImageSource.camera);
      if (imageFile != null) {
        _processImageForOCR(imageFile);
      }
    } catch (e) {
      print("Camera Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accessing camera. Check permissions.')),
      );
    }
  }
  
  // 🚀 COMPLETED FUNCTION 2: Open Gallery
  Future<void> openGallery() async {
    try {
      final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
      
      // FIX: Check if imageFile is NOT null before proceeding
      if (imageFile != null) { 
        _processImageForOCR(imageFile);
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Image selection canceled.')),
         );
      }
    } catch (e) {
      print("Gallery Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image.')),
      );
    }
  }

  // --- OCR Processing Logic (Shared) ---
  Future<void> _processImageForOCR(XFile imageFile) async {
    

    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);

      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
 
      print('--- RAW OCR TEXT ---');
      print(recognizedText.text);
      print('--------------------');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OCR complete. Ready for parsing.')),
      );

      // TODO: Call _showReviewScreen(recognizedText.text); here.

    } catch (e) {
      print("OCR Processing Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error processing receipt via OCR.')),
      );
    } 
  }
  // ignore: unused_element
  ParsedData _parseOcrText(String ocrText){
   // 1. Clean and split text
    final cleanedText = ocrText.toUpperCase().replaceAll(',', '.').replaceAll('€', '').replaceAll('\$', '').replaceAll('£', '');
    final lines = cleanedText.split('\n').map((line) => line.trim()).toList();

    double amountExtracted = 0.0;
   // DateTime dateExtracted = DateTime.now();
    String titleExtracted = 'Unknown Expense';
    
    // Helper to try parsing date formats
  


    // 2. Total Amount Extraction
    final totalKeywords = ['TOTAL', 'AMOUNT DUE', 'AMOUNT', 'BALANCE DUE', 'GRAND TOTAL', 'PAYABLE', 'SUM'];
    // Matches numbers with up to two decimal places, possibly preceded by a currency symbol or word (handled by clean), often on its own line or with keywords
    final amountRegex = RegExp(r'(\d{1,3}(?:[,\.]\d{3})*(?:[\.,]\d{2})?)|(\d+[\.,]\d{2})');

    // Iterate backwards to find total, as it's often at the end
    for (int i = lines.length - 1; i >= 0; i--) {
      final line = lines[i];
      final matches = amountRegex.allMatches(line);

      for (final keyword in totalKeywords) {
        if (line.contains(keyword)) {
          // If the line contains a total keyword, look for the *last* number in that line
          if (matches.isNotEmpty) {
            final match = matches.last;
            final amountString = match.group(0)?.replaceAll(',', '.');
            if (amountString != null && double.tryParse(amountString) != null) {
              amountExtracted = double.parse(amountString);
              // Stop searching once the total is found
              i = -1; // break outer loop
              break; 
            }
          }
        }
      }
    }
    
    // If no total found, try to find the largest number as a fallback
    if (amountExtracted == 0.0) {
      double maxAmount = 0.0;
      for (final line in lines) {
        final matches = amountRegex.allMatches(line);
        for (final match in matches) {
          final amountString = match.group(0)?.replaceAll(',', '.');
          if (amountString != null) {
            final currentAmount = double.tryParse(amountString);
            if (currentAmount != null && currentAmount > maxAmount) {
              maxAmount = currentAmount;
            }
          }
        }
      }
      amountExtracted = maxAmount;
    }


    // // 3. Date Extraction
    // final dateRegex = RegExp(r'(\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4})|(\d{4}[\/\-\.]\d{1,2}[\/\-\.]\d{1,2})');
    // for (final line in lines) {
    //   final matches = dateRegex.allMatches(line);
    //   if (matches.isNotEmpty) {
    //     final matchString = matches.first.group(0);
    //     if (matchString != null) {
    //       final parsedDate = _tryParseDate(matchString);
    //       if (parsedDate != null) {
    //         dateExtracted = parsedDate;
    //         break;
    //       }
    //     }
    //   }
    // }


    // 4. Title Extraction (Vendor/Store Name)
    // Use the first non-empty line as the title, as receipts often start with the store name.
   titleExtracted=lines.first.trim();


    // 5. Return the ParsedData object
    return ParsedData(
      title: titleExtracted, // Assuming a toTitleCase() extension exists
      amount: amountExtracted,
     // date: dateExtracted,
      // Default category
    );

  }
  Widget build(BuildContext context) {
    return Scaffold(
      //text
      backgroundColor:Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text('Scan Recipet',
            style:GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
            SizedBox(height: 18,),
            Text('Use Ai to automatically Categorize your expenses',
            style:GoogleFonts.poppins(
              fontSize:16,
              fontWeight: FontWeight.w500,
              color:Colors.white,
            )),
            SizedBox(height:46,),
            DottedBorder(
              options:RectDottedBorderOptions(
                dashPattern:[6,3],
                strokeWidth: 2,
                padding: EdgeInsets.all(12),
                color: Colors.blue,
              ),
              child:Column(
                children: [
                  ClipRRect(
                    borderRadius:BorderRadius.circular(100),
                  child:Container(
                    color:Colors.grey[900],
                    height:80,
                    width:80,
                    child:Icon(Icons.camera_alt,
                    color:Colors.grey,
                    size:50,),
                  ),
                  ),
                  SizedBox(height:8,),
                  Text('Capture Receipt',style:TextStyle(fontWeight:FontWeight.bold,color:Colors.white),),
                  SizedBox(height:4,),
                  Text('Point your camera at a receipt to scan',style:TextStyle(color:Colors.grey),),
                  SizedBox(height:16,),
                  Mybutton(
                    icon:Icon(Icons.camera_alt),
                    name:'Take Photo',
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    mycolor:const Color.fromARGB(255, 43, 64, 54),
                    onPressed:(){
                      openCamera();
                    },
                  ),
                  SizedBox(height:5,),
                   Mybutton(
                    icon:Icon(Icons.upload_sharp),
                    name:'Upload from Gallery',
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    mycolor:Colors.black,
                    onPressed:(){
                      openGallery();
                    },
                  ),
                ],
              )
            )
        
          ],
        ),
      ),
      
      floatingActionButton:FloatingActionButton(
        onPressed:(){
          addExpense();
        },
        backgroundColor:Colors.blue,
        child:Icon(Icons.add),
      ),
    );
  }
}