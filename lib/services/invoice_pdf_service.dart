import 'dart:typed_data';
import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/erp_models.dart';
import '../state/erp_controller.dart';

class InvoicePdfService {
  static String _formatPdfMoney(num amount) {
    final int rounded = amount.round();
    final String formatted = rounded.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return 'Rs. $formatted';
  }

  /// Generates a professional branded PDF receipt for Babur & Brothers Paint Store
  static Future<Uint8List> generateInvoicePdf(
    ErpController ctrl,
    InvoiceRecord inv,
  ) async {
    final doc = pw.Document();

    // Try to load shop logo
    pw.MemoryImage? logoImage;
    try {
      final logoBytes = await rootBundle.load('assets/images/logo.jpeg');
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {}

    final primaryColor = PdfColor.fromHex('#1E3A8A'); // Deep Navy
    final secondaryColor = PdfColor.fromHex('#059669'); // Emerald Green
    final lightBg = PdfColor.fromHex('#F8FAFC');
    final borderColor = PdfColor.fromHex('#E2E8F0');

    final totalQty = inv.items.fold<int>(0, (s, i) => s + i.qty);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // 1. Header with Logo & Shop Info
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 12),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (logoImage != null)
                      pw.Container(
                        width: 55,
                        height: 55,
                        margin: const pw.EdgeInsets.only(right: 12),
                        child: pw.Image(logoImage),
                      ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'BABUR & BROTHERS HARDWARE & PAINT STORE',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            "Official Authorized Dealer: Gobi's Paints Pakistan",
                            style: pw.TextStyle(
                              fontSize: 9.5,
                              color: PdfColors.grey700,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Bhera Road, Nawaz Plaza, Malikwal (Ph: ${ctrl.shopPhone})',
                            style: const pw.TextStyle(
                              fontSize: 8.5,
                              color: PdfColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: inv.mode == 'Cash'
                            ? secondaryColor
                            : PdfColor.fromHex('#F59E0B'),
                        borderRadius:
                            const pw.BorderRadius.all(pw.Radius.circular(6)),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Text(
                            'TAX INVOICE',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.Text(
                            inv.mode.toUpperCase(),
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // 2. Bill Meta Information (Invoice No, Customer, Date)
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: lightBg,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(6)),
                  border: pw.Border.all(color: borderColor),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              pw.TextSpan(
                                text: 'Invoice No: ',
                                style: pw.TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: pw.FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              pw.TextSpan(
                                text: inv.invoiceNo,
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              const pw.TextSpan(
                                text: 'Date & Time: ',
                                style: pw.TextStyle(
                                  fontSize: 9,
                                  color: PdfColors.grey700,
                                ),
                              ),
                              pw.TextSpan(
                                text: inv.dateStr,
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              pw.TextSpan(
                                text: 'Customer: ',
                                style: pw.TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: pw.FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              pw.TextSpan(
                                text: inv.customerName.isEmpty
                                    ? 'Walk-in Cash Customer'
                                    : inv.customerName,
                                style: pw.TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        if (inv.customerPhone.isNotEmpty &&
                            inv.customerPhone != '0300-0000000')
                          pw.RichText(
                            text: pw.TextSpan(
                              children: [
                                const pw.TextSpan(
                                  text: 'Phone: ',
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    color: PdfColors.grey700,
                                  ),
                                ),
                                pw.TextSpan(
                                  text: inv.customerPhone,
                                  style: const pw.TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),

              // 3. Products Table
              pw.Table(
                border: pw.TableBorder.all(
                  color: borderColor,
                  width: 0.5,
                ),
                columnWidths: {
                  0: const pw.FixedColumnWidth(24), // #
                  1: const pw.FlexColumnWidth(5), // Description
                  2: const pw.FlexColumnWidth(2), // Code
                  3: const pw.FixedColumnWidth(36), // Qty
                  4: const pw.FlexColumnWidth(2.2), // Rate
                  5: const pw.FlexColumnWidth(2.5), // Amount
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: primaryColor),
                    children: [
                      _headerCell('#', align: pw.TextAlign.center),
                      _headerCell('ITEM DESCRIPTION & PACK SIZE'),
                      _headerCell('CODE', align: pw.TextAlign.center),
                      _headerCell('QTY', align: pw.TextAlign.center),
                      _headerCell('RATE (PKR)', align: pw.TextAlign.right),
                      _headerCell('AMOUNT (PKR)', align: pw.TextAlign.right),
                    ],
                  ),
                  // Table Body
                  ...inv.items.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final it = entry.value;
                    final isEven = idx % 2 == 0;
                    final itemName = it.nameEn.isNotEmpty
                        ? it.nameEn
                        : (it.nameRo.isNotEmpty ? it.nameRo : it.nameUr);
                    return pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: isEven ? PdfColors.white : lightBg,
                      ),
                      children: [
                        _cell('${idx + 1}', align: pw.TextAlign.center),
                        _cell(itemName, isBold: true),
                        _cell(it.code.isNotEmpty ? it.code : '-',
                            align: pw.TextAlign.center),
                        _cell('${it.qty}', align: pw.TextAlign.center),
                        _cell(_formatPdfMoney(it.price),
                            align: pw.TextAlign.right),
                        _cell(_formatPdfMoney(it.subtotal),
                            align: pw.TextAlign.right, isBold: true),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 10),

              // 4. Summary & Totals
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Terms and Notes
                  pw.Expanded(
                    flex: 6,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: borderColor),
                        borderRadius:
                            const pw.BorderRadius.all(pw.Radius.circular(4)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'TERMS & CONDITIONS:',
                            style: pw.TextStyle(
                              fontSize: 7.5,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            '1. Goods once sold will not be returned without original receipt.\n'
                            '2. Computer tinting & custom mixed colors are strictly non-refundable.\n'
                            '3. Please inspect all cans for seal integrity prior to application.',
                            style: const pw.TextStyle(
                              fontSize: 7,
                              color: PdfColors.grey700,
                              lineSpacing: 1.5,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Total Items: ${inv.items.length}  |  Total Cans / Units: $totalQty',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 14),

                  // Financial Totals
                  pw.Expanded(
                    flex: 5,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        color: lightBg,
                        border: pw.Border.all(color: borderColor),
                        borderRadius:
                            const pw.BorderRadius.all(pw.Radius.circular(6)),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Subtotal:',
                                  style: const pw.TextStyle(fontSize: 8.5)),
                              pw.Text(_formatPdfMoney(inv.subtotal),
                                  style: const pw.TextStyle(fontSize: 8.5)),
                            ],
                          ),
                          if (inv.discount > 0) ...[
                            pw.SizedBox(height: 3),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text('Discount:',
                                    style: pw.TextStyle(
                                        fontSize: 8.5,
                                        color: PdfColor.fromHex('#DC2626'))),
                                pw.Text('-${_formatPdfMoney(inv.discount)}',
                                    style: pw.TextStyle(
                                        fontSize: 8.5,
                                        color: PdfColor.fromHex('#DC2626'))),
                              ],
                            ),
                          ],
                          pw.Divider(color: borderColor, height: 8),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Grand Total:',
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              pw.Text(
                                _formatPdfMoney(inv.total),
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // 5. Footer & Signatures
              pw.Container(
                padding: const pw.EdgeInsets.only(top: 8),
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(color: borderColor, width: 0.5),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Thank you for your business! Powered by Babur Brothers ERP',
                      style: const pw.TextStyle(
                        fontSize: 7.5,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 120,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(
                                  color: PdfColors.black, width: 0.8),
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.Text(
                          'Authorized Signature / Stamp',
                          style: const pw.TextStyle(
                              fontSize: 7.5, color: PdfColors.grey700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  static pw.Widget _headerCell(String text,
      {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 7.5,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }

  static pw.Widget _cell(String text,
      {pw.TextAlign align = pw.TextAlign.left, bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4.5),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 8.5,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  /// Shares the invoice as a genuine PDF file via WhatsApp, Email, or System Share
  static Future<void> shareInvoicePdf(
    BuildContext context,
    ErpController ctrl,
    InvoiceRecord inv,
  ) async {
    try {
      ctrl.showToast(ctrl.currentLang == 'ur'
          ? 'پی ڈی ایف انوائس تیار ہو رہی ہے...'
          : 'Generating PDF Invoice...');

      final pdfBytes = await generateInvoicePdf(ctrl, inv);

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'Invoice_${inv.invoiceNo}_Babur_Brothers.pdf',
      );
    } catch (e) {
      ctrl.showToast(ctrl.currentLang == 'ur'
          ? 'پی ڈی ایف شیئرنگ میں خرابی'
          : 'Failed to share PDF: $e');
    }
  }

  /// Opens the Print & Save PDF Preview dialog
  static Future<void> printInvoice(
    BuildContext context,
    ErpController ctrl,
    InvoiceRecord inv,
  ) async {
    try {
      await Printing.layoutPdf(
        name: 'Invoice_${inv.invoiceNo}_Babur_Brothers.pdf',
        onLayout: (PdfPageFormat format) async =>
            await generateInvoicePdf(ctrl, inv),
      );
    } catch (e) {
      ctrl.showToast(ctrl.currentLang == 'ur'
          ? 'پرنٹنگ میں خرابی'
          : 'Failed to print: $e');
    }
  }
}
