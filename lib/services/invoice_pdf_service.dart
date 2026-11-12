import 'dart:typed_data';
import 'package:flutter/material.dart' show BuildContext, MaterialPageRoute, Navigator;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/erp_models.dart';
import '../state/erp_controller.dart';
import '../ui/views/invoice_pdf_preview_screen.dart';

class InvoicePdfService {
  static String _clean(String input) {
    if (input.isEmpty) return '';
    return input
        .replaceAll('’', "'")
        .replaceAll('‘', "'")
        .replaceAll('“', '"')
        .replaceAll('”', '"')
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('•', '-')
        .replaceAll('×', 'x')
        .replaceAll(RegExp(r'[^\x20-\x7E\n\r\t]'), ' ')
        .trim();
  }

  static String _safeItemName(CartItem it) {
    if (it.nameEn.trim().isNotEmpty) {
      final c = _clean(it.nameEn);
      if (c.isNotEmpty) return c;
    }
    if (it.nameRo.trim().isNotEmpty) {
      final c = _clean(it.nameRo);
      if (c.isNotEmpty) return c;
    }
    return 'Paint Product (${it.code.isNotEmpty ? it.code : "#${it.prodId}"})';
  }

  static String _safeCustomerName(String raw) {
    final c = _clean(raw);
    if (c.isNotEmpty) return c;
    return 'Walk-in Cash Customer';
  }

  static String _formatPdfMoney(num amount) {
    final int rounded = amount.round();
    final String formatted = rounded.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return 'Rs. $formatted';
  }

  /// Opens the full in-app interactive PDF Preview & Print screen
  static void openInvoicePdfPreview(
    BuildContext context,
    ErpController ctrl,
    InvoiceRecord inv,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvoicePdfPreviewScreen(
          controller: ctrl,
          invoice: inv,
        ),
      ),
    );
  }

  /// Generates a professional branded PDF receipt for Babur & Brothers Paint Store
  /// Supports both standard A4 Tax Invoice and 80mm POS Thermal Roll
  static Future<Uint8List> generateInvoicePdf(
    ErpController ctrl,
    InvoiceRecord inv, {
    PdfPageFormat? format,
  }) async {
    final pageFormat = format ?? PdfPageFormat.a4;
    final isThermal = pageFormat.width < 350;

    if (isThermal) {
      return _generateThermalPdf(ctrl, inv, pageFormat);
    } else {
      return _generateA4Pdf(ctrl, inv, pageFormat);
    }
  }

  // ===========================================================================
  // 1. A4 TAX INVOICE GENERATOR (MultiPage with zero-overflow safety)
  // ===========================================================================
  static Future<Uint8List> _generateA4Pdf(
    ErpController ctrl,
    InvoiceRecord inv,
    PdfPageFormat pageFormat,
  ) async {
    final doc = pw.Document();

    // Safe shop logo load
    pw.MemoryImage? logoImage;
    try {
      final logoBytes = await rootBundle.load('assets/images/logo.jpeg');
      final bytes = logoBytes.buffer.asUint8List(
        logoBytes.offsetInBytes,
        logoBytes.lengthInBytes,
      );
      if (bytes.isNotEmpty) {
        logoImage = pw.MemoryImage(bytes);
      }
    } catch (_) {
      logoImage = null;
    }

    final primaryColor = PdfColor.fromHex('#1E3A8A'); // Deep Navy
    final secondaryColor = PdfColor.fromHex('#059669'); // Emerald Green
    final lightBg = PdfColor.fromHex('#F8FAFC');
    final borderColor = PdfColor.fromHex('#CBD5E1');

    final totalQty = inv.items.fold<int>(0, (s, i) => s + i.qty);
    final safeCustName = _safeCustomerName(inv.customerName);
    final safeCustPhone = _clean(inv.customerPhone);
    final safeInvNo = _clean(inv.invoiceNo);
    final safeDate = _clean(inv.dateStr);
    final safePhone = _clean(ctrl.shopPhone);

    doc.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        build: (pw.Context context) {
          return [
            // 1. Header with Logo & Shop Info
            pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 10),
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
                      width: 50,
                      height: 50,
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
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          "Official Authorized Dealer: Gobi's Paints Pakistan",
                          style: pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey700,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Bhera Road, Nawaz Plaza, Malikwal (Ph: $safePhone)',
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: pw.BoxDecoration(
                      color: inv.mode == 'Cash' ? secondaryColor : PdfColor.fromHex('#F59E0B'),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'TAX INVOICE',
                          style: pw.TextStyle(
                            fontSize: 9.5,
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
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: lightBg,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
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
                              text: safeInvNo,
                              style: pw.TextStyle(
                                fontSize: 9.5,
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
                                fontSize: 8.5,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.TextSpan(
                              text: safeDate,
                              style: const pw.TextStyle(fontSize: 8.5),
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
                              text: safeCustName,
                              style: pw.TextStyle(
                                fontSize: 9.5,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (safeCustPhone.isNotEmpty && safeCustPhone != '0300-0000000') ...[
                        pw.SizedBox(height: 2),
                        pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              const pw.TextSpan(
                                text: 'Phone: ',
                                style: pw.TextStyle(
                                  fontSize: 8.5,
                                  color: PdfColors.grey700,
                                ),
                              ),
                              pw.TextSpan(
                                text: safeCustPhone,
                                style: const pw.TextStyle(fontSize: 8.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10),

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
                  final itemName = _safeItemName(it);
                  final itemCode = _clean(it.code);
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: isEven ? PdfColors.white : lightBg,
                    ),
                    children: [
                      _cell('${idx + 1}', align: pw.TextAlign.center),
                      _cell(itemName, isBold: true),
                      _cell(itemCode.isNotEmpty ? itemCode : '-', align: pw.TextAlign.center),
                      _cell('${it.qty}', align: pw.TextAlign.center),
                      _cell(_formatPdfMoney(it.price), align: pw.TextAlign.right),
                      _cell(_formatPdfMoney(it.subtotal), align: pw.TextAlign.right, isBold: true),
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
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
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
                  flex: 4,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: lightBg,
                      border: pw.Border.all(color: borderColor),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Subtotal:', style: const pw.TextStyle(fontSize: 8.5)),
                            pw.Text(_formatPdfMoney(inv.subtotal),
                                style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        if (inv.discount > 0) ...[
                          pw.SizedBox(height: 3),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Discount:',
                                  style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.redAccent)),
                              pw.Text('-${_formatPdfMoney(inv.discount)}',
                                  style: pw.TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.redAccent)),
                            ],
                          ),
                        ],
                        pw.Divider(color: borderColor, height: 8),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Grand Total:',
                              style: pw.TextStyle(
                                fontSize: 10,
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
            pw.SizedBox(height: 14),

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
                            bottom: pw.BorderSide(color: PdfColors.black, width: 0.8),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        'Authorized Signature / Stamp',
                        style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return doc.save();
  }

  // ===========================================================================
  // 2. 80mm POS THERMAL ROLL GENERATOR
  // ===========================================================================
  static Future<Uint8List> _generateThermalPdf(
    ErpController ctrl,
    InvoiceRecord inv,
    PdfPageFormat pageFormat,
  ) async {
    final doc = pw.Document();

    final safeCustName = _safeCustomerName(inv.customerName);
    final safeInvNo = _clean(inv.invoiceNo);
    final safeDate = _clean(inv.dateStr);
    final safeMode = _clean(inv.mode);
    final safePhone = _clean(ctrl.shopPhone);

    final safeHeight = (pageFormat.height.isFinite && pageFormat.height > 100)
        ? pageFormat.height
        : (220.0 + (inv.items.length * 38.0) + 160.0);
    final finiteFormat = PdfPageFormat(
      pageFormat.width < 100 ? (80 * PdfPageFormat.mm) : pageFormat.width,
      safeHeight,
      marginAll: 4 * PdfPageFormat.mm,
    );

    doc.addPage(
      pw.Page(
        pageFormat: finiteFormat,
        margin: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Store Header
              pw.Center(
                child: pw.Text(
                  'BABUR & BROTHERS',
                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'HARDWARE & PAINT STORE',
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  "Official Dealer: Gobi's Paints Pakistan",
                  style: const pw.TextStyle(fontSize: 7.5),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'Bhera Road, Nawaz Plaza, Malikwal',
                  style: const pw.TextStyle(fontSize: 7),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'Tel: $safePhone',
                  style: const pw.TextStyle(fontSize: 7),
                ),
              ),
              pw.Divider(height: 8, thickness: 0.5),

              // Invoice Info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Inv: $safeInvNo',
                      style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Mode: $safeMode',
                      style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Text('Date: $safeDate', style: const pw.TextStyle(fontSize: 7)),
              pw.Text('Cust: $safeCustName', style: const pw.TextStyle(fontSize: 7)),
              pw.Divider(height: 8, thickness: 0.5),

              // Items
              ...inv.items.map((it) {
                final name = _safeItemName(it);
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(name,
                          style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold)),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('${it.qty} x ${_formatPdfMoney(it.price)}',
                              style: const pw.TextStyle(fontSize: 7)),
                          pw.Text(_formatPdfMoney(it.subtotal),
                              style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              pw.Divider(height: 8, thickness: 0.5),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal:', style: const pw.TextStyle(fontSize: 7.5)),
                  pw.Text(_formatPdfMoney(inv.subtotal),
                      style: const pw.TextStyle(fontSize: 7.5)),
                ],
              ),
              if (inv.discount > 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Discount:', style: const pw.TextStyle(fontSize: 7.5)),
                    pw.Text('-${_formatPdfMoney(inv.discount)}',
                        style: const pw.TextStyle(fontSize: 7.5)),
                  ],
                ),
              pw.SizedBox(height: 2),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TOTAL:',
                      style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold)),
                  pw.Text(_formatPdfMoney(inv.total),
                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(height: 8, thickness: 0.5),

              // Footer Note
              pw.Center(
                child: pw.Text(
                  'Thank you for shopping with us!',
                  style: const pw.TextStyle(fontSize: 7),
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'JazakAllah Khair',
                  style: const pw.TextStyle(fontSize: 6.5),
                ),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  static pw.Widget _headerCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
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

  /// Shares the invoice as a genuine PDF document file (WhatsApp, Drive, Gmail, etc.)
  static Future<void> shareInvoicePdf(
    BuildContext context,
    ErpController ctrl,
    InvoiceRecord inv,
  ) async {
    final safeInvNo = inv.invoiceNo.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    try {
      ctrl.showToast(ctrl.currentLang == 'ur'
          ? 'پی ڈی ایف انوائس تیار ہو رہی ہے...'
          : 'Generating PDF Invoice...');

      final pdfBytes = await generateInvoicePdf(ctrl, inv);

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'Invoice_${safeInvNo}_Babur_Brothers.pdf',
        subject: 'Invoice ${inv.invoiceNo} - Babur & Brothers Paint Store',
      );
    } catch (e) {
      ctrl.showToast(ctrl.currentLang == 'ur'
          ? 'پی ڈی ایف شیئرنگ میں خرابی: $e'
          : 'Failed to share PDF: $e');
    }
  }

  /// Directly opens the native system Print / Save as PDF manager
  static Future<void> printInvoice(
    BuildContext context,
    ErpController ctrl,
    InvoiceRecord inv,
  ) async {
    final safeInvNo = inv.invoiceNo.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    try {
      ctrl.showToast(ctrl.currentLang == 'ur'
          ? 'پرنٹر لوڈ ہو رہا ہے...'
          : 'Loading Printer...');

      await Printing.layoutPdf(
        name: 'Invoice_${safeInvNo}_Babur_Brothers.pdf',
        onLayout: (PdfPageFormat format) async =>
            await generateInvoicePdf(ctrl, inv, format: format),
      );
    } catch (e) {
      ctrl.showToast(ctrl.currentLang == 'ur'
          ? 'پرنٹنگ میں خرابی: $e'
          : 'Failed to print: $e');
    }
  }
}
