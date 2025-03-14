import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pdfx/pdfx.dart';

class CodigoEticaPage extends StatelessWidget {
  const CodigoEticaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Código de Ética',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ).animate().fadeIn(duration: 500.ms),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 4,
      ),
      body: PdfView(
        controller: PdfController(
          document: PdfDocument.openAsset('assets/codigo_etica.pdf'),
        ),
      ),
    );
  }
}
