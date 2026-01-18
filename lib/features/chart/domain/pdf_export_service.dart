import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/constants/human_design_constants.dart';
import 'models/human_design_chart.dart';

/// Service for exporting Human Design charts to PDF
class PdfExportService {
  /// Generate a PDF document for the given chart
  Future<Uint8List> generateChartPdf(HumanDesignChart chart) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            _buildHeader(chart),
            pw.SizedBox(height: 20),
            _buildChartSummary(chart),
            pw.SizedBox(height: 20),
            _buildTypeSection(chart),
            pw.SizedBox(height: 20),
            _buildCentersSection(chart),
            pw.SizedBox(height: 20),
            _buildChannelsSection(chart),
            pw.SizedBox(height: 20),
            _buildGatesSection(chart),
            pw.SizedBox(height: 30),
            _buildFooter(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(HumanDesignChart chart) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Human Design Chart',
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.indigo800,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          chart.name,
          style: pw.TextStyle(
            fontSize: 20,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          children: [
            pw.Icon(pw.IconData(0xe878), size: 14, color: PdfColors.grey600),
            pw.SizedBox(width: 4),
            pw.Text(
              _formatDateTime(chart.birthDateTime),
              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
            ),
            pw.SizedBox(width: 16),
            pw.Icon(pw.IconData(0xe55f), size: 14, color: PdfColors.grey600),
            pw.SizedBox(width: 4),
            pw.Text(
              chart.birthLocation.displayName,
              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.Divider(color: PdfColors.grey300, thickness: 1),
      ],
    );
  }

  pw.Widget _buildChartSummary(HumanDesignChart chart) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.indigo50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Type', chart.type.displayName),
          _buildSummaryItem('Strategy', chart.strategy),
          _buildSummaryItem('Authority', chart.authority.displayName),
          _buildSummaryItem('Profile', chart.profile.notation),
          _buildSummaryItem('Definition', chart.definition.displayName),
        ],
      ),
    );
  }

  pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey600,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.indigo800,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTypeSection(HumanDesignChart chart) {
    final typeInfo = _getTypeDescription(chart.type);

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Your Type: ${chart.type.displayName}',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.indigo800,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            typeInfo,
            style: const pw.TextStyle(fontSize: 11, lineSpacing: 3),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            children: [
              _buildInfoChip('Strategy', chart.strategy),
              pw.SizedBox(width: 8),
              _buildInfoChip('Not-Self Theme', chart.type.notSelfTheme),
              pw.SizedBox(width: 8),
              _buildInfoChip('Signature', chart.type.signature),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInfoChip(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCentersSection(HumanDesignChart chart) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Energy Centers',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.indigo800,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Wrap(
          spacing: 8,
          runSpacing: 8,
          children: HumanDesignCenter.values.map((center) {
            final isDefined = chart.definedCenters.contains(center);
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: pw.BoxDecoration(
                color: isDefined ? PdfColors.amber100 : PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(4),
                border: pw.Border.all(
                  color: isDefined ? PdfColors.amber700 : PdfColors.grey300,
                ),
              ),
              child: pw.Text(
                center.displayName,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: isDefined ? pw.FontWeight.bold : pw.FontWeight.normal,
                  color: isDefined ? PdfColors.amber900 : PdfColors.grey600,
                ),
              ),
            );
          }).toList(),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Defined centers are colored. These represent consistent energy in your design.',
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500, fontStyle: pw.FontStyle.italic),
        ),
      ],
    );
  }

  pw.Widget _buildChannelsSection(HumanDesignChart chart) {
    if (chart.activeChannels.isEmpty) {
      return pw.Container();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Active Channels (${chart.activeChannels.length})',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.indigo800,
          ),
        ),
        pw.SizedBox(height: 12),
        ...chart.activeChannels.map((channelActivation) {
          final channel = channelActivation.channel;
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey200),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Text(
                      'Channel ${channel.gate1}-${channel.gate2}',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      channel.name,
                      style: pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  '${gates[channel.gate1]?.center.displayName ?? 'Unknown'} to ${gates[channel.gate2]?.center.displayName ?? 'Unknown'}',
                  style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  pw.Widget _buildGatesSection(HumanDesignChart chart) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Active Gates',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.indigo800,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Conscious Gates
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    color: PdfColors.grey900,
                    child: pw.Text(
                      'Conscious (Personality)',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        left: pw.BorderSide(color: PdfColors.grey300),
                        right: pw.BorderSide(color: PdfColors.grey300),
                        bottom: pw.BorderSide(color: PdfColors.grey300),
                      ),
                    ),
                    child: pw.Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: chart.consciousGates
                          .toList()
                          .map((gate) => _buildGateChip(gate, true))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 16),
            // Unconscious Gates
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    color: PdfColors.red700,
                    child: pw.Text(
                      'Unconscious (Design)',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        left: pw.BorderSide(color: PdfColors.grey300),
                        right: pw.BorderSide(color: PdfColors.grey300),
                        bottom: pw.BorderSide(color: PdfColors.grey300),
                      ),
                    ),
                    child: pw.Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: chart.unconsciousGates
                          .toList()
                          .map((gate) => _buildGateChip(gate, false))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildGateChip(int gateNumber, bool isConscious) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
        color: isConscious ? PdfColors.grey200 : PdfColors.red100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        gateNumber.toString(),
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: isConscious ? PdfColors.grey800 : PdfColors.red800,
        ),
      ),
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: 8),
        pw.Text(
          'Generated by Human Design App',
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
        ),
        pw.Text(
          'Chart calculated using Swiss Ephemeris',
          style: pw.TextStyle(fontSize: 8, color: PdfColors.grey400),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $hour:${dt.minute.toString().padLeft(2, '0')} $period';
  }

  String _getTypeDescription(HumanDesignType type) {
    switch (type) {
      case HumanDesignType.manifestor:
        return 'Manifestors are here to initiate and make things happen. With a defined motor connected to the Throat, you have the energy to start new things independently. Your strategy is to inform those who will be impacted before you act.';
      case HumanDesignType.generator:
        return 'Generators are the life force of the planet with sustainable, sacral energy. Your strategy is to wait to respond to life rather than initiating. When you follow what lights you up, you experience satisfaction.';
      case HumanDesignType.manifestingGenerator:
        return 'Manifesting Generators combine the initiating power of Manifestors with the sustainable energy of Generators. You are multi-passionate and work quickly. Wait to respond, then inform before acting.';
      case HumanDesignType.projector:
        return 'Projectors are here to guide and direct the energy of others. Without consistent access to generating energy, your strategy is to wait for recognition and invitation before sharing your wisdom.';
      case HumanDesignType.reflector:
        return 'Reflectors are rare beings with no defined centers, making you deeply connected to the lunar cycle. Your strategy is to wait 28 days before making major decisions, allowing you to gain clarity.';
    }
  }

  /// Share the PDF using the system share dialog
  Future<void> sharePdf(HumanDesignChart chart) async {
    final pdfBytes = await generateChartPdf(chart);
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: '${chart.name}_human_design.pdf',
    );
  }

  /// Print the PDF
  Future<void> printPdf(HumanDesignChart chart) async {
    final pdfBytes = await generateChartPdf(chart);
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
      name: chart.name,
    );
  }
}
