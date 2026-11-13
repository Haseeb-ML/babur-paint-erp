import 'package:flutter/material.dart';
import '../../models/erp_models.dart';
import '../../services/invoice_pdf_service.dart';
import '../../state/erp_controller.dart';
import '../modals/erp_modals.dart';

class AllInvoicesScreen extends StatefulWidget {
  final ErpController controller;
  const AllInvoicesScreen({super.key, required this.controller});

  @override
  State<AllInvoicesScreen> createState() => _AllInvoicesScreenState();
}

class _AllInvoicesScreenState extends State<AllInvoicesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedFilter = 'all'; // 'all', 'cash', 'udhar'

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  TextStyle _txt(
    ErpController ctrl, {
    double size = 12,
    FontWeight weight = FontWeight.normal,
    Color? color,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: ctrl.isRtl ? 1.5 : 1.3,
      fontFamilyFallback: const ['Inter', 'Segoe UI', 'Roboto', 'sans-serif'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.controller;
    return ListenableBuilder(
      listenable: ctrl,
      builder: (ctx, _) {
        final isDark = ctrl.isDarkMode;
        final isUrdu = ctrl.currentLang == 'ur';
        final isRo = ctrl.currentLang == 'ro';

        final query = _searchCtrl.text.trim().toLowerCase();
        final allInvoices = ctrl.invoices;

        final filtered = allInvoices.where((inv) {
          // Filter by mode
          if (_selectedFilter == 'cash' && inv.mode != 'Cash') return false;
          if (_selectedFilter == 'udhar' && inv.mode == 'Cash') return false;

          // Filter by search query
          if (query.isNotEmpty) {
            final matchNo = inv.invoiceNo.toLowerCase().contains(query);
            final matchCust = inv.customerName.toLowerCase().contains(query);
            final matchPhone = inv.customerPhone.toLowerCase().contains(query);
            final matchDate = inv.dateStr.toLowerCase().contains(query);
            final matchItem = inv.items.any((it) =>
                it.nameUr.toLowerCase().contains(query) ||
                it.nameRo.toLowerCase().contains(query) ||
                it.nameEn.toLowerCase().contains(query));
            return matchNo || matchCust || matchPhone || matchDate || matchItem;
          }
          return true;
        }).toList();

        // Financial totals
        final double totalBilled =
            allInvoices.fold(0.0, (s, it) => s + it.total);
        final double cashBilled = allInvoices
            .where((i) => i.mode == 'Cash')
            .fold(0.0, (s, it) => s + it.total);
        final double udharBilled = allInvoices
            .where((i) => i.mode != 'Cash')
            .fold(0.0, (s, it) => s + it.total);

        return Directionality(
          textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor:
                isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
            appBar: AppBar(
              backgroundColor: ctrl.palette.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              title: Text(
                isUrdu
                    ? 'تمام بلز اور رسیدیں (${allInvoices.length})'
                    : (isRo
                        ? 'Tamam Bills & Invoices (${allInvoices.length})'
                        : 'All Bills & Invoices (${allInvoices.length})'),
                style: _txt(ctrl, size: 15, weight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: Column(
              children: [
                // 1. Top Summary Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.white12 : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      _kpiItem(
                        ctrl,
                        label: isUrdu ? 'کل بلز رقم' : 'Total Billed',
                        val: ctrl.formatMoney(totalBilled),
                        sub: '${allInvoices.length} Bills',
                        col: ctrl.palette.primary,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _kpiItem(
                        ctrl,
                        label: isUrdu ? 'نقد وصول' : 'Cash Total',
                        val: ctrl.formatMoney(cashBilled),
                        sub: '${allInvoices.where((i) => i.mode == 'Cash').length} Cash',
                        col: const Color(0xFF10B981),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _kpiItem(
                        ctrl,
                        label: isUrdu ? 'ادھار بلز' : 'Udhar Total',
                        val: ctrl.formatMoney(udharBilled),
                        sub: '${allInvoices.where((i) => i.mode != 'Cash').length} Udhar',
                        col: const Color(0xFFF59E0B),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                // 2. Search & Filter Bar
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchCtrl,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          hintText: isUrdu
                              ? 'بل نمبر، گاہک کا نام یا فون سے تلاش کریں...'
                              : 'Search invoice #, customer name, phone...',
                          hintStyle:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          prefixIcon:
                              const Icon(Icons.search_rounded, size: 20),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor:
                              isDark ? const Color(0xFF1E293B) : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: isDark ? Colors.white12 : Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: isDark ? Colors.white12 : Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Filter chips
                      Row(
                        children: [
                          _filterChip(
                            label: isUrdu ? 'تمام (${allInvoices.length})' : 'All (${allInvoices.length})',
                            key: 'all',
                            isDark: isDark,
                            primaryCol: ctrl.palette.primary,
                          ),
                          const SizedBox(width: 8),
                          _filterChip(
                            label: isUrdu
                                ? 'نقد (${allInvoices.where((i) => i.mode == 'Cash').length})'
                                : 'Cash (${allInvoices.where((i) => i.mode == 'Cash').length})',
                            key: 'cash',
                            isDark: isDark,
                            primaryCol: const Color(0xFF10B981),
                          ),
                          const SizedBox(width: 8),
                          _filterChip(
                            label: isUrdu
                                ? 'ادھار (${allInvoices.where((i) => i.mode != 'Cash').length})'
                                : 'Udhar (${allInvoices.where((i) => i.mode != 'Cash').length})',
                            key: 'udhar',
                            isDark: isDark,
                            primaryCol: const Color(0xFFF59E0B),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Invoices List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.receipt_long_rounded,
                                  size: 52, color: Colors.grey.withValues(alpha: 0.4)),
                              const SizedBox(height: 10),
                              Text(
                                isUrdu
                                    ? 'کوئی بل نہیں ملا'
                                    : 'No invoices found matching criteria',
                                style: _txt(ctrl, size: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (context, idx) {
                            final inv = filtered[idx];
                            return _buildInvoiceCard(context, ctrl, inv, isDark, isUrdu);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _kpiItem(
    ErpController ctrl, {
    required String label,
    required String val,
    required String sub,
    required Color col,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: col.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: col.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _txt(ctrl, size: 10.5, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700)),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                val,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: col,
                ),
              ),
            ),
            Text(
              sub,
              style: TextStyle(
                fontSize: 9.5,
                color: isDark ? Colors.grey : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required String key,
    required bool isDark,
    required Color primaryCol,
  }) {
    final active = _selectedFilter == key;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = key),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? primaryCol
                : (isDark ? const Color(0xFF1E293B) : Colors.white),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active
                  ? primaryCol
                  : (isDark ? Colors.white12 : Colors.grey.shade300),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active
                  ? Colors.white
                  : (isDark ? Colors.grey.shade300 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(
    BuildContext context,
    ErpController ctrl,
    InvoiceRecord inv,
    bool isDark,
    bool isUrdu,
  ) {
    final isCash = inv.mode == 'Cash';
    final badgeCol = isCash ? const Color(0xFF10B981) : const Color(0xFFF59E0B);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ctrl.palette.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  inv.invoiceNo,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                    color: ctrl.palette.primary,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeCol.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: badgeCol.withValues(alpha: 0.3)),
                ),
                child: Text(
                  isCash
                      ? (isUrdu ? 'نقد بل' : 'Cash')
                      : (isUrdu ? 'ادھار بل' : 'Udhar'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeCol,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    inv.dateStr,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Customer Row & Total
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded,
                            size: 15, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            inv.customerName.isEmpty
                                ? (isUrdu ? 'عام گاہک (Walk-in)' : 'Walk-in Cash Customer')
                                : inv.customerName,
                            style: _txt(ctrl, size: 12.5, weight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (inv.customerPhone.isNotEmpty &&
                        inv.customerPhone != '0300-0000000') ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined,
                              size: 13, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            inv.customerPhone,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ctrl.formatMoney(inv.total),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: isCash
                          ? const Color(0xFF10B981)
                          : const Color(0xFF1E3A8A),
                    ),
                  ),
                  Text(
                    '${inv.items.length} ${isUrdu ? "آئٹمز" : "items"}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 16),

          // Items summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...inv.items.take(4).map((it) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '• ${it.getName(ctrl.currentLang)} ×${it.qty}',
                              style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white70 : Colors.black87),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ctrl.formatMoney(it.subtotal),
                            style: const TextStyle(
                                fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                if (inv.items.length > 4)
                  Text(
                    '+${inv.items.length - 4} ${isUrdu ? "مزید آئٹمز..." : "more items..."}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Actions Row
          Row(
            children: [
              // 1. View / Print Bill Button
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ctrl.palette.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () =>
                      ErpModals.openInvoiceDialog(context, ctrl, inv),
                  icon: const Icon(Icons.receipt_long_rounded, size: 14),
                  label: Text(
                    isUrdu ? 'رسید دیکھیں' : 'View Bill',
                    style: _txt(ctrl,
                        size: 11, weight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 2. Preview / Print Button
              IconButton.filledTonal(
                tooltip: isUrdu ? 'انوائس پریویو/پرنٹ' : 'Open Preview / Print',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7).withValues(alpha: 0.15),
                  foregroundColor: const Color(0xFF0284C7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () =>
                    InvoicePdfService.printInvoice(context, ctrl, inv),
                icon: const Icon(Icons.print_rounded, size: 16),
              ),
              const SizedBox(width: 4),

              // 3. Direct Share PDF Button (WhatsApp / System Share)
              IconButton.filledTonal(
                tooltip: isUrdu ? 'پی ڈی ایف شیئر کریں' : 'Share PDF',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366).withValues(alpha: 0.15),
                  foregroundColor: const Color(0xFF25D366),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () =>
                    InvoicePdfService.shareInvoicePdf(context, ctrl, inv),
                icon: const Icon(Icons.share_rounded, size: 16),
              ),
              const SizedBox(width: 4),

              // 3. Delete Bill Button
              IconButton.filledTonal(
                tooltip: isUrdu ? 'بل حذف کریں' : 'Delete Bill',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.redAccent.withValues(alpha: 0.12),
                  foregroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  ErpModals.confirmDelete(
                    context,
                    ctrl,
                    itemTitle: '${inv.invoiceNo} (${inv.customerName})',
                    onConfirm: () {
                      ctrl.deleteInvoice(inv.id);
                    },
                  );
                },
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

