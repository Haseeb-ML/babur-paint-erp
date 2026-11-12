import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../models/erp_models.dart';
import '../../services/invoice_pdf_service.dart';
import '../../state/erp_controller.dart';

class InvoicePdfPreviewScreen extends StatelessWidget {
  final ErpController controller;
  final InvoiceRecord invoice;

  const InvoicePdfPreviewScreen({
    super.key,
    required this.controller,
    required this.invoice,
  });

  TextStyle _txt(
    ErpController ctrl, {
    double size = 12.5,
    FontWeight weight = FontWeight.normal,
    Color? color,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      fontFamilyFallback: const [
        'Inter',
        'Segoe UI',
        'Roboto',
        'sans-serif',
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    final isDark = ctrl.isDarkMode;
    final isUrdu = ctrl.currentLang == 'ur';

    final safeInvNo = invoice.invoiceNo.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    final fileName = 'Invoice_${safeInvNo}_Babur_Brothers.pdf';

    return Directionality(
      textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        appBar: AppBar(
          title: Text(
            isUrdu
                ? 'انوائس پرنٹ اور پی ڈی ایف (${invoice.invoiceNo})'
                : 'Invoice PDF & Print (${invoice.invoiceNo})',
            style: _txt(ctrl, size: 14, weight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: ctrl.palette.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          actions: [
            // WhatsApp Share Action Button in AppBar
            IconButton(
              tooltip: isUrdu ? 'واٹس ایپ پر پی ڈی ایف بھیجیں' : 'Share PDF on WhatsApp',
              icon: const Icon(Icons.share_rounded, color: Colors.white),
              onPressed: () => InvoicePdfService.shareInvoicePdf(context, ctrl, invoice),
            ),
          ],
        ),
        body: PdfPreview(
          build: (format) => InvoicePdfService.generateInvoicePdf(ctrl, invoice, format: format),
          canChangePageFormat: true,
          canChangeOrientation: false,
          canDebug: false,
          pdfFileName: fileName,
          maxPageWidth: 700,
          pageFormats: const {
            'A4 Tax Invoice': PdfPageFormat.a4,
            '80mm Thermal POS': PdfPageFormat(
              80 * PdfPageFormat.mm,
              220 * PdfPageFormat.mm,
              marginLeft: 4 * PdfPageFormat.mm,
              marginRight: 4 * PdfPageFormat.mm,
              marginTop: 6 * PdfPageFormat.mm,
              marginBottom: 6 * PdfPageFormat.mm,
            ),
          },
          initialPageFormat: PdfPageFormat.a4,
          onError: (ctx, err) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF1E3A8A), size: 54),
                  const SizedBox(height: 14),
                  Text(
                    isUrdu ? 'انوائس PDF تیار ہے' : 'Invoice PDF is Ready',
                    style: _txt(ctrl, size: 15, weight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isUrdu
                        ? 'آپ نیچے دیے گئے بٹن سے واٹس ایپ پر بھیج سکتے ہیں یا پرنٹ کر سکتے ہیں۔'
                        : 'You can share directly to WhatsApp or send to your printer using the buttons below.',
                    style: const TextStyle(fontSize: 11.5, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () => InvoicePdfService.shareInvoicePdf(ctx, ctrl, invoice),
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: Text(
                      isUrdu ? 'واٹس ایپ پر PDF بھیجیں' : 'Share PDF on WhatsApp',
                      style: _txt(ctrl, size: 12.5, weight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          loadingWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: ctrl.palette.primary),
                const SizedBox(height: 14),
                Text(
                  isUrdu ? 'انوائس تیار ہو رہی ہے...' : 'Generating Invoice PDF...',
                  style: _txt(ctrl, size: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            PdfPreviewAction(
              icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
              onPressed: (ctx, build, pageFormat) async {
                await InvoicePdfService.shareInvoicePdf(ctx, ctrl, invoice);
              },
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                    onPressed: () => InvoicePdfService.shareInvoicePdf(context, ctrl, invoice),
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                    label: Text(
                      isUrdu ? 'واٹس ایپ پر پی ڈی ایف بھیجیں' : 'WhatsApp PDF Share',
                      style: _txt(ctrl, size: 12, weight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => InvoicePdfService.printInvoice(context, ctrl, invoice),
                  icon: const Icon(Icons.print_rounded, size: 18),
                  label: Text(
                    isUrdu ? 'پرنٹ' : 'Print',
                    style: _txt(ctrl, size: 12, weight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

