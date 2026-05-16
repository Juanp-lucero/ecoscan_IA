import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class PdfService {
  Future<void> exportReportsPdf(
    List<Map<String, dynamic>> reports,
  ) async {
    final pdf = _buildReportsDocument(reports);

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  Future<void> shareReportsPdf(
    List<Map<String, dynamic>> reports,
  ) async {
    final pdf = _buildReportsDocument(reports);
    final bytes = await pdf.save();

    final directory =
        await getTemporaryDirectory();

    final file = File(
      '${directory.path}/ecoscan_environmental_reports.pdf',
    );

    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text: 'EcoScan AI environmental reports',
    );
  }

  pw.Document _buildReportsDocument(
    List<Map<String, dynamic>> reports,
  ) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            pw.Text(
              'EcoScan AI - Environmental Reports',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 8),

            pw.Text(
              'Total reports: ${reports.length}',
              style: const pw.TextStyle(
                fontSize: 14,
              ),
            ),

            pw.SizedBox(height: 20),

            ...reports.map(
              (report) => _buildReportCard(report),
            ),
          ];
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildReportCard(
    Map<String, dynamic> report,
  ) {
    final type =
        report['type']?.toString() ?? 'Unknown';
    final impact =
        report['impact']?.toString() ?? 'Unknown';
    final description =
        report['description']?.toString() ?? '';
    final toxicity =
        report['toxicity_level']?.toString() ?? '';
    final recycling =
        report['recycling_recommendation']
                ?.toString() ??
            '';
    final ecoAction =
        report['eco_action']?.toString() ?? '';
    final latitude =
        report['latitude']?.toString() ??
            'Not available';
    final longitude =
        report['longitude']?.toString() ??
            'Not available';
    final date =
        report['created_at']?.toString().substring(
                  0,
                  10,
                ) ??
            'Not available';

    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(
        bottom: 16,
      ),
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.grey400,
        ),
        borderRadius:
            pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment:
            pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            type,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 6),

          pw.Text('Impact: $impact'),
          pw.Text('Toxicity: $toxicity'),
          pw.Text('Date: $date'),

          pw.SizedBox(height: 10),

          pw.Text(
            'Description:',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(description),

          pw.SizedBox(height: 8),

          pw.Text(
            'Recycling recommendation:',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(recycling),

          pw.SizedBox(height: 8),

          pw.Text(
            'Suggested eco action:',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(ecoAction),

          pw.SizedBox(height: 8),

          pw.Text(
            'Location: $latitude, $longitude',
          ),
        ],
      ),
    );
  }
}