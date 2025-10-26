import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../../core/presentation/navigation/navigation_container.dart';

class Receipt extends StatefulWidget {
  final String collectionNumber;
  const Receipt({super.key, required this.collectionNumber});

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  bool _isLoading = false;
  final logger = Logger();

  Future<File> fetchPdfFromBackend(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/downloaded.pdf');
      await file.writeAsBytes(bytes);
      return file;
    } else {
      throw Exception('Failed to load PDF');
    }
  }

  Future<void> printPdf(File file) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => file.readAsBytes(),
    );
  }

  Future<void> _fetchAndPrintPdf() async {
    setState(() {
      _isLoading = true;
    });

    try {
      logger.i("the collection code is ${widget.collectionNumber}");
      final pdfFile = await fetchPdfFromBackend(
          'http://18.219.121.50:9600/api/v1/reports/collection?collectionCode=${widget.collectionNumber}');
      await printPdf(pdfFile);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      logger.e('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Receipt'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomNavigationContainer()),
                (route) => false);
          },
        ),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _fetchAndPrintPdf,
                child: const Text('Fetch and Print PDF Receipt'),
              ),
      ),
    );
  }
}
