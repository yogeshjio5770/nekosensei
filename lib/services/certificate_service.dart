import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/lesson_models.dart';

class CertificateService {
  Future<Uint8List> generateCertificatePdf({
    required CertificateModel certificate,
    required String verificationUrl,
  }) async {
    final pdf = pw.Document();
    final levelInfo = AppConstants.certificateLevels[certificate.levelId];
    final levelColor = PdfColor.fromInt(levelInfo?.color ?? 0xFF4F46E5);

    final qrImage = await _generateQrImage(verificationUrl);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: levelColor, width: 3),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  AppConstants.appName,
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey600,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Japanese Language Completion Certificate',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: levelColor,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  levelInfo?.title ?? certificate.levelTitle,
                  style: pw.TextStyle(
                    fontSize: 18,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 32),
                pw.Text(
                  'This certifies that',
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  certificate.studentName,
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'has successfully completed the ${certificate.levelTitle} level '
                  'with a score of ${certificate.finalScore}/100',
                  style: const pw.TextStyle(fontSize: 14),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Spacer(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Certificate ID: ${certificate.id}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          'Issued: ${_formatDate(certificate.issuedAt)}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          'Verify: $verificationUrl',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                    if (qrImage != null)
                      pw.Image(qrImage, width: 80, height: 80),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Container(
                          width: 150,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              top: pw.BorderSide(color: PdfColors.grey),
                            ),
                          ),
                          padding: const pw.EdgeInsets.only(top: 4),
                          child: pw.Text(
                            'Lead Instructor',
                            style: const pw.TextStyle(fontSize: 10),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<pw.MemoryImage?> _generateQrImage(String data) async {
    try {
      final painter = QrPainter(
        data: data,
        version: QrVersions.auto,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
      );

      final picRecorder = ui.PictureRecorder();
      final canvas = Canvas(picRecorder);
      painter.paint(canvas, const Size(200, 200));
      final picture = picRecorder.endRecording();
      final image = await picture.toImage(200, 200);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      return pw.MemoryImage(byteData.buffer.asUint8List());
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> printCertificate(Uint8List pdfBytes) async {
    await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
  }

  Future<void> shareCertificate(Uint8List pdfBytes, String fileName) async {
    await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
  }
}
