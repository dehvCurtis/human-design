import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../chart/domain/models/human_design_chart.dart';

/// Service for exporting Human Design charts as images and PDFs
class ChartExportService {
  /// Capture a widget as a PNG image using RepaintBoundary
  static Future<Uint8List?> captureWidgetAsImage(
    GlobalKey repaintBoundaryKey, {
    double pixelRatio = 3.0,
  }) async {
    try {
      final boundary = repaintBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }

  /// Export bodygraph as PNG image and share
  static Future<void> exportAsImage({
    required GlobalKey repaintBoundaryKey,
    required String chartName,
    required BuildContext context,
  }) async {
    final bytes = await captureWidgetAsImage(repaintBoundaryKey);
    if (bytes == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture chart image')),
        );
      }
      return;
    }

    // Save to temp file
    final tempDir = await getTemporaryDirectory();
    final sanitizedName = chartName.replaceAll(RegExp(r'[^\w\s-]'), '');
    final file = File('${tempDir.path}/${sanitizedName}_bodygraph.png');
    await file.writeAsBytes(bytes);

    // Share the file
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: '$chartName - Human Design Bodygraph',
      ),
    );
  }

  /// Generate and share a PDF report of the chart
  static Future<void> exportAsPdf({
    required HumanDesignChart chart,
    GlobalKey? bodygraphKey,
    required BuildContext context,
  }) async {
    final pdf = pw.Document();

    // Capture bodygraph image if key is provided
    Uint8List? bodygraphImage;
    if (bodygraphKey != null) {
      bodygraphImage = await captureWidgetAsImage(bodygraphKey, pixelRatio: 2.0);
    }

    // Build PDF content
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) => [
          // Header
          pw.Center(
            child: pw.Text(
              'Human Design Chart',
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text(
              chart.name,
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.SizedBox(height: 24),

          // Bodygraph image
          if (bodygraphImage != null) ...[
            pw.Center(
              child: pw.Image(
                pw.MemoryImage(bodygraphImage),
                width: 300,
                height: 400,
              ),
            ),
            pw.SizedBox(height: 24),
          ],

          // Basic Info Section
          _buildPdfSection('Basic Information', [
            _buildPdfRow('Type', chart.type.displayName),
            _buildPdfRow('Strategy', chart.strategy),
            _buildPdfRow('Authority', chart.authority.displayName),
            _buildPdfRow('Profile', chart.profile.notation),
            _buildPdfRow('Definition', chart.definition.displayName),
          ]),
          pw.SizedBox(height: 16),

          // Birth Info Section
          _buildPdfSection('Birth Information', [
            _buildPdfRow('Date & Time', _formatDateTime(chart.birthDateTime)),
            _buildPdfRow('Location', chart.birthLocation.displayName),
            _buildPdfRow('Timezone', chart.timezone),
          ]),
          pw.SizedBox(height: 16),

          // Centers Section
          _buildPdfSection('Defined Centers', [
            pw.Text(
              chart.definedCenters.map((c) => c.displayName).join(', '),
              style: const pw.TextStyle(fontSize: 12),
            ),
          ]),
          pw.SizedBox(height: 8),
          _buildPdfSection('Undefined Centers', [
            pw.Text(
              chart.undefinedCenters.map((c) => c.displayName).join(', '),
              style: const pw.TextStyle(fontSize: 12),
            ),
          ]),
          pw.SizedBox(height: 16),

          // Active Channels Section
          if (chart.activeChannels.isNotEmpty) ...[
            _buildPdfSection('Active Channels', [
              for (final channel in chart.activeChannels)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Text(
                    '${channel.channel.gate1}-${channel.channel.gate2}: ${channel.channel.name}',
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ),
            ]),
            pw.SizedBox(height: 16),
          ],

          // Gates Section
          _buildPdfSection('Conscious Gates (Personality)', [
            pw.Text(
              chart.consciousGates.toList().join(', '),
              style: const pw.TextStyle(fontSize: 11),
            ),
          ]),
          pw.SizedBox(height: 8),
          _buildPdfSection('Unconscious Gates (Design)', [
            pw.Text(
              chart.unconsciousGates.toList().join(', '),
              style: const pw.TextStyle(fontSize: 11),
            ),
          ]),
          pw.SizedBox(height: 24),

          // Type Description
          _buildPdfSection('About Your Type: ${chart.type.displayName}', [
            pw.Text(
              'Strategy: ${chart.strategy}',
              style: const pw.TextStyle(fontSize: 11),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Signature: ${chart.type.signature}',
              style: const pw.TextStyle(fontSize: 11),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Not-Self Theme: ${chart.type.notSelfTheme}',
              style: const pw.TextStyle(fontSize: 11),
            ),
          ]),
          pw.SizedBox(height: 16),

          // Authority Description
          _buildPdfSection('Your Authority: ${chart.authority.displayName}', [
            pw.Text(
              chart.authority.description,
              style: const pw.TextStyle(fontSize: 11),
            ),
          ]),

          // Footer
          pw.SizedBox(height: 32),
          pw.Center(
            child: pw.Text(
              'Generated by Human Design App',
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey500,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );

    // Save and share
    final bytes = await pdf.save();
    final tempDir = await getTemporaryDirectory();
    final sanitizedName = chart.name.replaceAll(RegExp(r'[^\w\s-]'), '');
    final file = File('${tempDir.path}/${sanitizedName}_chart.pdf');
    await file.writeAsBytes(bytes);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: '${chart.name} - Human Design Chart Report',
      ),
    );
  }

  /// Print PDF directly
  static Future<void> printPdf({
    required HumanDesignChart chart,
    GlobalKey? bodygraphKey,
  }) async {
    Uint8List? bodygraphImage;
    if (bodygraphKey != null) {
      bodygraphImage = await captureWidgetAsImage(bodygraphKey, pixelRatio: 2.0);
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        final pdf = pw.Document();

        pdf.addPage(
          pw.MultiPage(
            pageFormat: format,
            margin: const pw.EdgeInsets.all(40),
            build: (pw.Context context) => [
              pw.Center(
                child: pw.Text(
                  '${chart.name} - Human Design Chart',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 24),
              if (bodygraphImage != null) ...[
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(bodygraphImage),
                    width: 250,
                    height: 350,
                  ),
                ),
                pw.SizedBox(height: 24),
              ],
              _buildPdfRow('Type', chart.type.displayName),
              _buildPdfRow('Strategy', chart.strategy),
              _buildPdfRow('Authority', chart.authority.displayName),
              _buildPdfRow('Profile', chart.profile.notation),
              _buildPdfRow('Definition', chart.definition.displayName),
            ],
          ),
        );

        return pdf.save();
      },
    );
  }

  static pw.Widget _buildPdfSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.indigo,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
