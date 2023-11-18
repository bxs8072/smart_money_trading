import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewUI extends StatefulWidget {
  final String pdfLink;
  const PdfViewUI({super.key, required this.pdfLink});

  @override
  State<PdfViewUI> createState() => _PdfViewUIState();
}

class _PdfViewUIState extends State<PdfViewUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "What is Call Option?",
          key: widget.key,
        ),
      ),
      body: SfPdfViewer.network(
        widget.pdfLink,
        canShowPaginationDialog: true,
        enableDoubleTapZooming: true,
        pageLayoutMode: PdfPageLayoutMode.continuous,
      ),
    );
  }
}
