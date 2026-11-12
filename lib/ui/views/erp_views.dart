import 'package:flutter/material.dart';
import '../../models/erp_models.dart';
import '../../state/erp_controller.dart';
import '../../theme/app_themes.dart';
import '../modals/erp_modals.dart';

class ErpViews {
  static TextStyle _txt(
    ErpController ctrl, {
    double size = 12.5,
    FontWeight weight = FontWeight.normal,
    Color? color,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: ctrl.isRtl ? 1.62 : 1.32,
      fontFamilyFallback: const [
        'Jameel Noori Nastaleeq',
        'Noto Nastaliq Urdu',
        'Inter',
        'Segoe UI',
        'Roboto',
        'sans-serif'
      ],
    );
  }

  static TextStyle _num({
    double size = 13,
    FontWeight weight = FontWeight.bold,
    Color? color,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.25,
      fontFamily: 'Inter',
    );
  }

  static Widget _editDeleteButtons({
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    bool isDark = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.edit_outlined, size: 15, color: Colors.blue),
          ),
        ),
        const SizedBox(width: 5),
        InkWell(
          onTap: onDelete,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.delete_outline_rounded, size: 15, color: Colors.redAccent),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // MODULE 1: EXECUTIVE DASHBOARD
  // ===========================================================================
  static Widget buildDashboardView(BuildContext context, ErpController ctrl) {
    final isDark = ctrl.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textMain = isDark ? Colors.white : const Color(0xFF1E293B);

    final brandsData = [
      {
        'nameUr': 'گوبیز ڈیکوریٹو (ہرکولیس، گولڈ، پریمیم)',
        'nameRo': "Gobi's Decorative (Hercules, Gold, Premium)",
        'nameEn': "Gobi's Decorative (Hercules, Gold, Premium)",
        'sales': 38500,
        'pct': 0.46,
        'color': ctrl.palette.primary,
      },
      {
        'nameUr': 'گوبیز کارمین NC، سلور لائن اور 2K آٹو',
        'nameRo': "Gobi's Carman NC, Silverline & 2K Auto",
        'nameEn': "Gobi's Carman NC, Silverline & 2K Auto",
        'sales': 24800,
        'pct': 0.30,
        'color': const Color(0xFFF59E0B),
      },
      {
        'nameUr': 'ٹمبر لائن، سٹوونگ، ایپوکسی اور ہارڈویئر',
        'nameRo': 'Timberline, Stoving, Epoxy & Hardware',
        'nameEn': 'Timberline, Stoving, Epoxy & Hardware',
        'sales': 19550,
        'pct': 0.24,
        'color': const Color(0xFF059669),
      },
    ];

    final lowStocks = ctrl.lowStockItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. 6 Module Quick Cards Grid (3x2)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderCol),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ctrl.tr('dashModTitle'),
                      style: _txt(ctrl, size: 13.5, weight: FontWeight.bold, color: textMain),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: ctrl.palette.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ctrl.palette.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      ctrl.tr('dashModBadge'),
                      style: _txt(ctrl,
                          size: 10.5, weight: FontWeight.bold, color: ctrl.palette.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _dashModBtn(
                      ctrl,
                      icon: Icons.calculate_outlined,
                      label: ctrl.tr('mPos'),
                      color: const Color(0xFF2563EB),
                      onTap: () => ctrl.switchTab('pos'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _dashModBtn(
                      ctrl,
                      icon: Icons.color_lens_outlined,
                      label: ctrl.tr('mTint'),
                      color: const Color(0xFF4F46E5),
                      onTap: () => ctrl.switchTab('tinting'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _dashModBtn(
                      ctrl,
                      icon: Icons.inventory_2_outlined,
                      label: ctrl.tr('mInv'),
                      color: const Color(0xFF059669),
                      onTap: () => ctrl.switchTab('inventory'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _dashModBtn(
                      ctrl,
                      icon: Icons.menu_book_rounded,
                      label: ctrl.tr('mKhata'),
                      color: const Color(0xFFD97706),
                      onTap: () => ctrl.switchTab('khata'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _dashModBtn(
                      ctrl,
                      icon: Icons.confirmation_number_outlined,
                      label: ctrl.tr('mPainter'),
                      color: const Color(0xFF9333EA),
                      onTap: () => ctrl.switchTab('painters'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _dashModBtn(
                      ctrl,
                      icon: Icons.aspect_ratio_rounded,
                      label: ctrl.tr('mCalc'),
                      color: const Color(0xFF0D9488),
                      onTap: () => ErpModals.openEstimatorModal(context, ctrl),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 2. Gobi's Series-Wise Paint Sales Bars
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderCol),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ctrl.tr('dashBrandTitle'),
                      style: _txt(ctrl, size: 13.5, weight: FontWeight.bold, color: textMain),
                    ),
                  ),
                  InkWell(
                    onTap: () => ctrl.switchTab('pos'),
                    child: Text(
                      ctrl.tr('dashBrandSub'),
                      style: _txt(ctrl,
                          size: 12, weight: FontWeight.bold, color: ctrl.palette.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...brandsData.map((b) {
                final title = ctrl.currentLang == 'ur'
                    ? b['nameUr'] as String
                    : (ctrl.currentLang == 'ro'
                        ? b['nameRo'] as String
                        : b['nameEn'] as String);
                final sales = b['sales'] as int;
                final pct = b['pct'] as double;
                final col = b['color'] as Color;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: _txt(ctrl, size: 12, weight: FontWeight.w600, color: textMain),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${ctrl.formatMoney(sales)} (${(pct * 100).round()}%)',
                            style: _num(
                              size: 11.5,
                              weight: FontWeight.w800,
                              color: isDark ? Colors.amberAccent : ctrl.palette.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 7,
                          backgroundColor:
                              isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(col),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 3. Low Stock Alert Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF3B2506) : const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFFB45309) : const Color(0xFFFCD34D),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ctrl.tr('dashLowTitle'),
                      style: _txt(
                        ctrl,
                        size: 13,
                        weight: FontWeight.bold,
                        color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF78350F),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      foregroundColor: const Color(0xFF0F172A),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => ctrl.switchTab('inventory'),
                    child: Text(
                      ctrl.tr('dashOrderBtn'),
                      style: _txt(ctrl,
                          size: 11, weight: FontWeight.bold, color: const Color(0xFF0F172A)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (lowStocks.isEmpty)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    ctrl.tr('allStocksGood'),
                    style: _txt(ctrl, size: 12, color: const Color(0xFF059669)),
                  ),
                )
              else
                ...lowStocks.take(4).map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isDark ? const Color(0xFF475569) : const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.getName(ctrl.currentLang),
                                  style:
                                      _txt(ctrl, size: 12, weight: FontWeight.bold, color: textMain),
                                ),
                                Text(
                                  '${ctrl.tr('stockLbl')} ${item.stock} (${item.getSize(ctrl.currentLang)})',
                                  style: _txt(ctrl,
                                      size: 11, weight: FontWeight.w600, color: Colors.redAccent),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ctrl.palette.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => ctrl.quickRestockItem(item.id),
                            child: Text(
                              ctrl.tr('restockBtn'),
                              style: _txt(ctrl,
                                  size: 11, weight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 4. Recent Income & Expenses Feed (With Add, Edit, Delete)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderCol),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ctrl.tr('dashRecentTitle'),
                      style: _txt(ctrl, size: 13.5, weight: FontWeight.bold, color: textMain),
                    ),
                  ),
                  InkWell(
                    onTap: () => ErpModals.openCashEntryModal(context, ctrl),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.35)),
                      ),
                      child: Text(
                        ctrl.tr('btnAddExpDash'),
                        style: _txt(ctrl,
                            size: 11, weight: FontWeight.bold, color: Colors.redAccent),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...ctrl.cashLedger.take(5).map((entry) =>
                  _buildCashLedgerRow(context, ctrl, entry, isDark, textMain)),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _dashModBtn(
    ErpController ctrl, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = ctrl.isDarkMode;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155).withValues(alpha: 0.6) : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF475569) : color.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _txt(
                ctrl,
                size: 11.5,
                weight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCashLedgerRow(
    BuildContext context,
    ErpController ctrl,
    CashLedgerEntry entry,
    bool isDark,
    Color textMain,
  ) {
    final isInc = entry.type == 'income';
    final col = isInc ? const Color(0xFF059669) : Colors.redAccent;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.7) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: col.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.getDesc(ctrl.currentLang),
                  style: _txt(ctrl, size: 12, weight: FontWeight.bold, color: textMain),
                ),
                Text(
                  '${entry.getCat(ctrl.currentLang)} • ${entry.getDate(ctrl.currentLang)}',
                  style: _txt(ctrl, size: 11, color: col),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isInc ? '+' : '-'}${ctrl.formatMoney(entry.amount)}',
                style: _num(size: 12, weight: FontWeight.w900, color: col),
              ),
              const SizedBox(height: 4),
              _editDeleteButtons(
                isDark: isDark,
                onEdit: () => ErpModals.openCashEntryModal(context, ctrl, existing: entry),
                onDelete: () => ErpModals.confirmDelete(
                  context,
                  ctrl,
                  itemTitle: entry.getDesc(ctrl.currentLang),
                  onConfirm: () => ctrl.deleteCashEntry(entry.id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MODULE 2: POS & BILLING (WITH FULL GOBI'S CATALOG + EDIT/DELETE)
  // ===========================================================================
  static Widget buildPosView(
    BuildContext context,
    ErpController ctrl,
    TextEditingController searchCtrl,
  ) {
    final isDark = ctrl.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textMain = isDark ? Colors.white : const Color(0xFF1E293B);

    final seriesTabs = [
      {'id': 'ALL', 'label': ctrl.tr('pbrandALL')},
      {'id': 'Decorative', 'label': ctrl.tr('pbrandDecorative')},
      {'id': 'Carman NC', 'label': ctrl.tr('pbrandCarman')},
      {'id': 'Silverline', 'label': ctrl.tr('pbrandSilverline')},
      {'id': 'Stoving', 'label': ctrl.tr('pbrandStoving')},
      {'id': 'Timberline', 'label': ctrl.tr('pbrandTimberline')},
      {'id': 'Ancillaries', 'label': ctrl.tr('pbrandHardware')},
    ];

    final q = searchCtrl.text.trim().toLowerCase();
    final filtered = ctrl.inventory.where((item) {
      if (ctrl.posSeriesFilter != 'ALL') {
        if (ctrl.posSeriesFilter == 'Silverline') {
          if (!['Silverline', 'BigBang 2K', 'Tusker 2K', 'NC Thinner'].contains(item.series)) {
            return false;
          }
        } else if (ctrl.posSeriesFilter == 'Stoving') {
          if (!['Stoving', 'Epoxy & Ind'].contains(item.series)) return false;
        } else if (item.series != ctrl.posSeriesFilter) {
          return false;
        }
      }
      if (q.isEmpty) return true;
      return item.nameUr.toLowerCase().contains(q) ||
          item.nameRo.toLowerCase().contains(q) ||
          item.nameEn.toLowerCase().contains(q) ||
          item.code.toLowerCase().contains(q) ||
          item.sizeEn.toLowerCase().contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Current Bill Banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ctrl.palette.headerStart, ctrl.palette.headerEnd],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ctrl.tr('posBannerSub'),
                          style: _txt(ctrl, size: 11.5, color: Colors.white70),
                        ),
                        Text(
                          ctrl.formatMoney(ctrl.cartTotal),
                          style: _num(size: 18, weight: FontWeight.w900, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => ErpModals.openEstimatorModal(context, ctrl),
                    child: Text(
                      ctrl.tr('posBtnEst'),
                      style: _txt(ctrl, size: 11.5, weight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => ErpModals.openInvoicesHistoryModal(context, ctrl),
                      icon: const Icon(Icons.receipt_long_rounded, size: 15, color: Color(0xFFFBBF24)),
                      label: Text(
                        '${ctrl.tr('invoicesHistoryBtn')} (${ctrl.invoices.length})',
                        style: _txt(ctrl, size: 11, weight: FontWeight.bold, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBBF24),
                        foregroundColor: const Color(0xFF0F172A),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => ErpModals.openPosCartModal(context, ctrl),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                      label: Text(
                        '${ctrl.tr('posBtnCheckout')} (${ctrl.cartItemCount})',
                        style: _txt(ctrl,
                            size: 11.5, weight: FontWeight.w800, color: const Color(0xFF0F172A)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // 2. Series Filter Chips + Add New Product Button
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...seriesTabs.map((t) {
                final id = t['id']!;
                final active = ctrl.posSeriesFilter == id;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 6),
                  child: InkWell(
                    onTap: () => ctrl.setPosSeriesFilter(id),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: active ? ctrl.palette.primary : cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: active ? ctrl.palette.primary : borderCol,
                        ),
                      ),
                      child: Text(
                        t['label']!,
                        style: _txt(
                          ctrl,
                          size: 11.5,
                          weight: active ? FontWeight.bold : FontWeight.w600,
                          color: active ? Colors.white : textMain,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              InkWell(
                onTap: () => ErpModals.openProductModal(context, ctrl),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+ ${ctrl.tr('btnNewStock')}',
                    style: _txt(ctrl,
                        size: 11.5, weight: FontWeight.bold, color: const Color(0xFF0F172A)),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => ErpModals.openBarcodeScannerModal(context, ctrl),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.qr_code_scanner_rounded, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        ctrl.tr('btnScanBarcode'),
                        style: _txt(ctrl,
                            size: 11, weight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // 3. Search Bar with Instant Barcode Scanner & Gun Input
        TextField(
          controller: searchCtrl,
          onChanged: (_) => ctrl.refresh(),
          onSubmitted: (val) {
            if (val.trim().isNotEmpty) {
              final added = ctrl.scanAndAddToCart(val.trim());
              if (added) {
                searchCtrl.clear();
                ctrl.refresh();
              }
            }
          },
          style: _txt(ctrl, size: 12.5, color: textMain),
          decoration: InputDecoration(
            hintText: '${ctrl.tr('posSearchPh')} (یا بارکوڈ اسکین کریں)',
            hintStyle: _txt(ctrl, size: 12, color: Colors.grey),
            prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Colors.grey),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (searchCtrl.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      searchCtrl.clear();
                      ctrl.refresh();
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner_rounded,
                      size: 20, color: Color(0xFFF59E0B)),
                  tooltip: ctrl.tr('btnScanBarcode'),
                  onPressed: () => ErpModals.openBarcodeScannerModal(context, ctrl),
                ),
                const SizedBox(width: 4),
              ],
            ),
            filled: true,
            fillColor: cardBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderCol),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderCol),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 4. Products List (With Add to Bill + Edit + Delete)
        ...filtered.map((item) {
          final profitPerUnit = (item.salePrice - item.costPrice).round();
          return Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderCol),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppThemes.parseHex(item.colorHex),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          item.code.isNotEmpty ? item.code : item.getBrandLabel(ctrl.currentLang),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.getName(ctrl.currentLang),
                            style: _txt(ctrl, size: 12.5, weight: FontWeight.bold, color: textMain),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.getSize(ctrl.currentLang),
                                  style: _txt(
                                    ctrl,
                                    size: 10.5,
                                    weight: FontWeight.bold,
                                    color: isDark ? Colors.amberAccent : const Color(0xFF334155),
                                  ),
                                ),
                              ),
                              Text(
                                '${ctrl.tr('stockLbl')} ${item.stock}',
                                style: _txt(
                                  ctrl,
                                  size: 11,
                                  weight: FontWeight.bold,
                                  color: item.stock <= item.minStock
                                      ? Colors.redAccent
                                      : ctrl.palette.primary,
                                ),
                              ),
                              Text(
                                '${ctrl.tr('profitLbl')} +${ctrl.formatMoney(profitPerUnit)}',
                                style: _txt(
                                  ctrl,
                                  size: 11,
                                  weight: FontWeight.bold,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          ctrl.formatMoney(item.salePrice),
                          style: _num(
                            size: 13.5,
                            weight: FontWeight.w900,
                            color: isDark ? Colors.amberAccent : ctrl.palette.primary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ctrl.palette.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => ctrl.addToPosCart(item),
                          child: Text(
                            ctrl.tr('addBillBtn'),
                            style:
                                _txt(ctrl, size: 11, weight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        item.gstAmount > 0
                            ? '${ctrl.tr('rpLbl')} ${item.retailPrice.toStringAsFixed(0)} • ${ctrl.tr('gstLbl')} ${item.gstAmount.toStringAsFixed(0)}'
                            : '${ctrl.tr('costLbl')} ${ctrl.formatMoney(item.costPrice)} • Series: ${item.series}',
                        style: _txt(ctrl, size: 10.5, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _editDeleteButtons(
                      isDark: isDark,
                      onEdit: () => ErpModals.openProductModal(context, ctrl, existing: item),
                      onDelete: () => ErpModals.confirmDelete(
                        context,
                        ctrl,
                        itemTitle: item.getName(ctrl.currentLang),
                        onConfirm: () => ctrl.deleteProduct(item.id),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ===========================================================================
  // MODULE 3: COLOR MIXING & GOBI'S HERCULES SHADE CARDS (94 SHADES)
  // ===========================================================================
  static Widget buildTintingView(BuildContext context, ErpController ctrl) {
    final isDark = ctrl.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textMain = isDark ? Colors.white : const Color(0xFF1E293B);

    final shade = ctrl.selectedShade;
    final mult = ctrl.tintSizeMultiplier;
    final finalBase = (shade.baseGallonPrice * mult).round();
    final finalTint = (shade.tintCostGallon * mult).round();
    final totalPrice = finalBase + finalTint;
    final shadeCol = AppThemes.parseHex(shade.hex);

    final filteredShades = ctrl.shades.where((s) {
      if (ctrl.shadeSeriesFilter == 'ALL') return true;
      return s.series == ctrl.shadeSeriesFilter;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Computerized Color Mixing Studio Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderCol),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ctrl.tr('tintMainTitle'),
                          style: _txt(ctrl, size: 13.5, weight: FontWeight.bold, color: textMain),
                        ),
                        Text(
                          ctrl.tr('tintMainSub'),
                          style: _txt(ctrl, size: 11.5, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ctrl.palette.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Text('✺',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.amberAccent : ctrl.palette.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Live Shade Preview Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [shadeCol, Color.lerp(shadeCol, Colors.white, 0.35)!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black26),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'CODE: ${shade.code}',
                              style: _num(size: 11, weight: FontWeight.w900, color: Colors.black87),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            shade.getName(ctrl.currentLang),
                            style: _txt(ctrl,
                                size: 15, weight: FontWeight.w900, color: const Color(0xFF0F172A)),
                          ),
                          Text(
                            shade.getBase(ctrl.currentLang),
                            style: _txt(ctrl,
                                size: 11.5,
                                weight: FontWeight.w600,
                                color: const Color(0xFF1E293B)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            ctrl.tr('tintPriceLbl'),
                            style: _txt(ctrl,
                                size: 10, weight: FontWeight.bold, color: Colors.amberAccent),
                          ),
                          Text(
                            ctrl.formatMoney(totalPrice),
                            style: _num(size: 14, weight: FontWeight.w900, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Packing Size Selector
              Text(
                ctrl.tr('lblTintSize'),
                style: _txt(ctrl, size: 12, weight: FontWeight.bold, color: textMain),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _packSizeBtn(ctrl, 'Quarter', ctrl.tr('tsizeQuarter')),
                  const SizedBox(width: 6),
                  _packSizeBtn(ctrl, 'Gallon', ctrl.tr('tsizeGallon')),
                  const SizedBox(width: 6),
                  _packSizeBtn(ctrl, 'Drum', ctrl.tr('tsizeDrum')),
                ],
              ),
              const SizedBox(height: 12),

              // Pigment Formula Bars
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderCol),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            ctrl.tr('lblPigmentTitle'),
                            style: _txt(
                              ctrl,
                              size: 12,
                              weight: FontWeight.bold,
                              color: isDark ? Colors.amberAccent : textMain,
                            ),
                          ),
                        ),
                        Text(
                          '+${ctrl.formatMoney(finalTint)}',
                          style: _num(
                            size: 12,
                            weight: FontWeight.bold,
                            color: isDark ? Colors.cyanAccent : ctrl.palette.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...shade.pigments.map((p) {
                      final shotMl = (p.ml * mult).toStringAsFixed(1);
                      final pct = ((p.ml * 3) / 100.0).clamp(0.15, 1.0);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    p.getName(ctrl.currentLang),
                                    style: _txt(ctrl,
                                        size: 11.5, weight: FontWeight.w600, color: textMain),
                                  ),
                                ),
                                Text(
                                  '$shotMl ${ctrl.tr('mlShotWord')}',
                                  style: _txt(
                                    ctrl,
                                    size: 11.5,
                                    weight: FontWeight.bold,
                                    color: isDark ? Colors.amberAccent : ctrl.palette.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 7,
                                backgroundColor:
                                    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppThemes.parseHex(p.colorHex),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Mix & Add + Custom Shade Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ctrl.palette.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => ctrl.dispenseAndAddToPos(),
                      child: Text(
                        ctrl.tr('btnMixAdd'),
                        style: _txt(ctrl, size: 12, weight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        side: BorderSide(color: borderCol),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => ErpModals.openShadeModal(context, ctrl),
                      child: Text(
                        '+ ${ctrl.tr('btnCustomShade')}',
                        style: _txt(
                          ctrl,
                          size: 12,
                          weight: FontWeight.bold,
                          color: isDark ? Colors.amberAccent : textMain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 2. Gobi's Hercules Official 94-Shade Fan-Deck Catalog
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderCol),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ctrl.tr('tintFandeckTitle'),
                style: _txt(ctrl, size: 13.5, weight: FontWeight.bold, color: textMain),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _shadeSeriesChip(ctrl, 'ALL', ctrl.tr('shadeAll')),
                    const SizedBox(width: 6),
                    _shadeSeriesChip(ctrl, 'WeatherGuard', ctrl.tr('shadeWG')),
                    const SizedBox(width: 6),
                    _shadeSeriesChip(ctrl, 'Emulsion', ctrl.tr('shadeEmul')),
                    const SizedBox(width: 6),
                    _shadeSeriesChip(ctrl, 'Enamel', ctrl.tr('shadeEnam')),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredShades.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 82,
                ),
                itemBuilder: (_, i) {
                  final s = filteredShades[i];
                  final active = s.id == shade.id;
                  return InkWell(
                    onTap: () => ctrl.selectShadeById(s.id),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: active ? ctrl.palette.primary : borderCol,
                          width: active ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppThemes.parseHex(s.hex),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black26),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.code,
                                      style: _num(
                                        size: 10.5,
                                        weight: FontWeight.bold,
                                        color: isDark ? Colors.amberAccent : ctrl.palette.primary,
                                      ),
                                    ),
                                    Text(
                                      s.getName(ctrl.currentLang),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: _txt(ctrl,
                                          size: 11.5, weight: FontWeight.bold, color: textMain),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  s.series,
                                  style: const TextStyle(fontSize: 9.5, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        ErpModals.openShadeModal(context, ctrl, existing: s),
                                    child: const Icon(Icons.edit_outlined,
                                        size: 14, color: Colors.blue),
                                  ),
                                  const SizedBox(width: 6),
                                  InkWell(
                                    onTap: () => ErpModals.confirmDelete(
                                      context,
                                      ctrl,
                                      itemTitle: '${s.code} - ${s.getName(ctrl.currentLang)}',
                                      onConfirm: () => ctrl.deleteShade(s.id),
                                    ),
                                    child: const Icon(Icons.delete_outline,
                                        size: 14, color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _packSizeBtn(ErpController ctrl, String sizeKey, String label) {
    final active = ctrl.selectedTintPack == sizeKey;
    final isDark = ctrl.isDarkMode;
    return Expanded(
      child: InkWell(
        onTap: () => ctrl.setTintPackSize(sizeKey),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? ctrl.palette.primary
                : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? ctrl.palette.primary : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _txt(
              ctrl,
              size: 11,
              weight: FontWeight.bold,
              color: active ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _shadeSeriesChip(ErpController ctrl, String key, String label) {
    final active = ctrl.shadeSeriesFilter == key;
    return InkWell(
      onTap: () => ctrl.setShadeSeriesFilter(key),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? ctrl.palette.primary
              : (ctrl.isDarkMode ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: _txt(
            ctrl,
            size: 11,
            weight: FontWeight.bold,
            color: active ? Colors.white : (ctrl.isDarkMode ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // MODULE 4: STOCK & GODOWN (INVENTORY)
  // ===========================================================================
  static Widget buildInventoryView(BuildContext context, ErpController ctrl) {
    final isDark = ctrl.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textMain = isDark ? Colors.white : const Color(0xFF1E293B);

    final filters = [
      {'id': 'ALL', 'label': ctrl.tr('ifltALL')},
      {'id': 'LOW', 'label': ctrl.tr('ifltLOW')},
      {'id': 'Emulsion', 'label': ctrl.tr('ifltEmulsion')},
      {'id': 'Weather', 'label': ctrl.tr('ifltWeather')},
      {'id': 'Enamel', 'label': ctrl.tr('ifltEnamel')},
      {'id': 'NC2K', 'label': ctrl.tr('ifltNC2K')},
      {'id': 'Wood', 'label': ctrl.tr('ifltWood')},
      {'id': 'StovingEpoxy', 'label': ctrl.tr('ifltStovingEpoxy')},
      {'id': 'Hardware', 'label': ctrl.tr('ifltHardware')},
    ];

    final filtered = ctrl.inventory.where((item) {
      if (ctrl.invCatFilter == 'ALL') return true;
      if (ctrl.invCatFilter == 'LOW') return item.stock <= item.minStock;
      return item.cat == ctrl.invCatFilter;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Warehouse Summary Header Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ctrl.palette.headerStart, ctrl.palette.headerEnd],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ctrl.tr('invValLbl'),
                          style: _txt(ctrl, size: 11, color: Colors.white70),
                        ),
                        Text(
                          ctrl.formatMoney(ctrl.inventoryWorth),
                          style: _num(
                              size: 16, weight: FontWeight.w900, color: const Color(0xFFFBBF24)),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          padding: const EdgeInsets.all(7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.white24),
                          ),
                        ),
                        onPressed: () => ErpModals.openBarcodeScannerModal(context, ctrl),
                        tooltip: ctrl.tr('btnScanBarcode'),
                        icon: const Icon(Icons.qr_code_scanner_rounded, size: 16, color: Color(0xFFFBBF24)),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBBF24),
                          foregroundColor: const Color(0xFF0F172A),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => ErpModals.openProductModal(context, ctrl),
                        child: Text(
                          ctrl.currentLang == 'ur'
                              ? '+ نیا مال'
                              : (ctrl.currentLang == 'ro' ? '+ Naya Maal' : '+ Add Stock'),
                          style: _txt(ctrl,
                              size: 10.5, weight: FontWeight.w800, color: const Color(0xFF0F172A)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 18),
              Row(
                children: [
                  Expanded(
                    child: _invKpiMini(
                      ctrl,
                      ctrl.tr('invStatItems'),
                      '${ctrl.inventory.length}',
                      Colors.white,
                    ),
                  ),
                  Expanded(
                    child: _invKpiMini(
                      ctrl,
                      ctrl.tr('invStatUnits'),
                      '${ctrl.totalStockUnits}',
                      const Color(0xFF6EE7B7),
                    ),
                  ),
                  Expanded(
                    child: _invKpiMini(
                      ctrl,
                      ctrl.tr('invStatLow'),
                      '${ctrl.lowStockItems.length}',
                      const Color(0xFFFBBF24),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // 2. Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((f) {
              final id = f['id']!;
              final active = ctrl.invCatFilter == id;
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 6),
                child: InkWell(
                  onTap: () => ctrl.setInvCatFilter(id),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: active ? ctrl.palette.primary : cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: active ? ctrl.palette.primary : borderCol,
                      ),
                    ),
                    child: Text(
                      f['label']!,
                      style: _txt(
                        ctrl,
                        size: 11.5,
                        weight: active ? FontWeight.bold : FontWeight.w600,
                        color: active
                            ? Colors.white
                            : (id == 'LOW' ? Colors.redAccent : textMain),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),

        // 3. Inventory Items List (With Restock, Edit, Delete)
        ...filtered.map((item) {
          final isLow = item.stock <= item.minStock;
          return Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isLow ? Colors.redAccent.withValues(alpha: 0.65) : borderCol,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppThemes.parseHex(item.colorHex),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Text(
                        item.code.isNotEmpty ? item.code : item.getBrandLabel(ctrl.currentLang),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.getName(ctrl.currentLang),
                            style: _txt(ctrl, size: 12.5, weight: FontWeight.bold, color: textMain),
                          ),
                          Text(
                            '${item.series} • ${item.getSize(ctrl.currentLang)}',
                            style: _txt(ctrl, size: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isLow
                            ? Colors.red.withValues(alpha: 0.15)
                            : ctrl.palette.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${item.stock}',
                        style: _num(
                          size: 12.5,
                          weight: FontWeight.w900,
                          color: isLow ? Colors.redAccent : ctrl.palette.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text(
                            '${ctrl.tr('costLbl')} ${ctrl.formatMoney(item.costPrice)}',
                            style: _txt(ctrl, size: 11.5, color: Colors.grey),
                          ),
                          Text(
                            '${ctrl.tr('saleLbl')} ${ctrl.formatMoney(item.salePrice)}',
                            style: _txt(
                              ctrl,
                              size: 11.5,
                              weight: FontWeight.bold,
                              color: isDark ? Colors.amberAccent : ctrl.palette.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ctrl.palette.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => ctrl.quickRestockItem(item.id),
                          child: Text(
                            ctrl.tr('restockBtn'),
                            style: _txt(ctrl, size: 10.5, weight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.qr_code_rounded, size: 20, color: Color(0xFFF59E0B)),
                          tooltip: ctrl.tr('barcodeLabelTitle'),
                          visualDensity: VisualDensity.compact,
                          onPressed: () => ErpModals.openBarcodeLabelDialog(context, ctrl, item),
                        ),
                        const SizedBox(width: 4),
                        _editDeleteButtons(
                          isDark: isDark,
                          onEdit: () =>
                              ErpModals.openProductModal(context, ctrl, existing: item),
                          onDelete: () => ErpModals.confirmDelete(
                            context,
                            ctrl,
                            itemTitle: item.getName(ctrl.currentLang),
                            onConfirm: () => ctrl.deleteProduct(item.id),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  static Widget _invKpiMini(ErpController ctrl, String label, String val, Color valCol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _txt(ctrl, size: 10.5, color: Colors.white70)),
        Text(val, style: _num(size: 13.5, weight: FontWeight.bold, color: valCol)),
      ],
    );
  }

  // ===========================================================================
  // MODULE 5: KHATA & UDHAR (CUSTOMERS, SUPPLIERS, CASHBOOK)
  // ===========================================================================
  static Widget buildKhataView(BuildContext context, ErpController ctrl) {
    final isDark = ctrl.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textMain = isDark ? Colors.white : const Color(0xFF1E293B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 3 Sub-Tabs Switcher
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderCol),
          ),
          child: Row(
            children: [
              _khataSubBtn(ctrl, 'cust', ctrl.tr('ktabCust')),
              const SizedBox(width: 4),
              _khataSubBtn(ctrl, 'supp', ctrl.tr('ktabSupp')),
              const SizedBox(width: 4),
              _khataSubBtn(ctrl, 'cash', ctrl.tr('ktabCash')),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // SUB-TAB 1: CUSTOMER CREDIT
        if (ctrl.khataSubTab == 'cust') ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ctrl.tr('khCustLbl'),
                        style: _txt(ctrl,
                            size: 11.5, weight: FontWeight.bold, color: const Color(0xFF0F172A)),
                      ),
                      Text(
                        ctrl.formatMoney(ctrl.totalUdharPending),
                        style: _num(
                            size: 20, weight: FontWeight.w900, color: const Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => ErpModals.openCustomerModal(context, ctrl),
                  child: Text(
                    '+ ${ctrl.tr('btnKhNewUdhar')}',
                    style: _txt(ctrl, size: 11.5, weight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...ctrl.customers.map((c) {
            final rem = c.remaining;
            final isPaid = rem <= 0;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isPaid
                      ? const Color(0xFF059669).withValues(alpha: 0.5)
                      : const Color(0xFFF59E0B).withValues(alpha: 0.6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.getName(ctrl.currentLang),
                              style:
                                  _txt(ctrl, size: 13, weight: FontWeight.bold, color: textMain),
                            ),
                            Text(
                              '${c.getWork(ctrl.currentLang)} • ${c.phone}',
                              style: _txt(ctrl, size: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (isPaid)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            ctrl.tr('paidBadge'),
                            style: _txt(ctrl,
                                size: 11, weight: FontWeight.bold, color: const Color(0xFF059669)),
                          ),
                        )
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ctrl.palette.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => ErpModals.openUdharPayModal(context, ctrl, c.id),
                          child: Text(
                            ctrl.tr('receiveBtn'),
                            style:
                                _txt(ctrl, size: 11, weight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _khataStatCol(
                          ctrl,
                          ctrl.tr('totalBillLbl'),
                          ctrl.formatMoney(c.totalGiven),
                          textMain,
                        ),
                      ),
                      Expanded(
                        child: _khataStatCol(
                          ctrl,
                          ctrl.tr('paidAmtLbl'),
                          ctrl.formatMoney(c.totalPaid),
                          const Color(0xFF059669),
                        ),
                      ),
                      Expanded(
                        child: _khataStatCol(
                          ctrl,
                          ctrl.tr('remAmtLbl'),
                          ctrl.formatMoney(rem),
                          isPaid ? const Color(0xFF059669) : const Color(0xFFD97706),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_rounded, size: 17, color: Color(0xFF25D366)),
                        tooltip: 'Share via WhatsApp',
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          final text = [
                            '*${ctrl.shopProfile.nameRo.toUpperCase()}*',
                            ctrl.shopProfile.address,
                            'Helpline: ${ctrl.shopProfile.phone}',
                            '--------------------------------',
                            'Customer: ${c.getName(ctrl.currentLang)}',
                            'Total Bill: ${ctrl.formatMoney(c.totalGiven)}',
                            'Paid: ${ctrl.formatMoney(c.totalPaid)}',
                            '*REMAINING BALANCE: ${ctrl.formatMoney(rem)}*',
                            '--------------------------------',
                            'Khata Hisab Reminder. Shukriya!',
                          ].join('\n');
                          ErpModals.shareViaWhatsApp(
                            context,
                            ctrl,
                            phone: c.phone,
                            text: text,
                          );
                        },
                      ),
                      _editDeleteButtons(
                        isDark: isDark,
                        onEdit: () => ErpModals.openCustomerModal(context, ctrl, existing: c),
                        onDelete: () => ErpModals.confirmDelete(
                          context,
                          ctrl,
                          itemTitle: c.getName(ctrl.currentLang),
                          onConfirm: () => ctrl.deleteCustomer(c.id),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],

        // SUB-TAB 2: PAINT SUPPLIERS (ALLIED PAINT GOBI'S DEPOT)
        if (ctrl.khataSubTab == 'supp') ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ctrl.palette.headerStart, ctrl.palette.headerEnd],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ctrl.tr('khSuppLbl'),
                        style: _txt(ctrl, size: 11.5, color: Colors.white70),
                      ),
                      Text(
                        ctrl.formatMoney(ctrl.totalSupplierPayable),
                        style: _num(
                            size: 20, weight: FontWeight.w900, color: const Color(0xFFFBBF24)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBBF24),
                    foregroundColor: const Color(0xFF0F172A),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => ErpModals.openSupplierModal(context, ctrl),
                  child: Text(
                    '+ ${ctrl.tr('btnKhNewSupp')}',
                    style: _txt(ctrl,
                        size: 11.5, weight: FontWeight.bold, color: const Color(0xFF0F172A)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...ctrl.suppliers.map((s) {
            final rem = s.remaining;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderCol),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.getCompany(ctrl.currentLang),
                              style:
                                  _txt(ctrl, size: 13, weight: FontWeight.bold, color: textMain),
                            ),
                            Text(
                              s.getLastSupply(ctrl.currentLang),
                              style: _txt(ctrl, size: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ctrl.palette.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => ctrl.paySupplierInstallment(s.id),
                        child: Text(
                          ctrl.tr('payDealerBtn'),
                          style: _txt(ctrl, size: 11, weight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            Text(
                              '${ctrl.tr('totalBillLbl')} ${ctrl.formatMoney(s.totalBill)}',
                              style: _txt(ctrl, size: 11.5, weight: FontWeight.bold, color: textMain),
                            ),
                            Text(
                              '${ctrl.tr('remAmtLbl')} ${ctrl.formatMoney(rem)}',
                              style: _txt(ctrl,
                                  size: 11.5,
                                  weight: FontWeight.bold,
                                  color: const Color(0xFFD97706)),
                            ),
                          ],
                        ),
                      ),
                      _editDeleteButtons(
                        isDark: isDark,
                        onEdit: () => ErpModals.openSupplierModal(context, ctrl, existing: s),
                        onDelete: () => ErpModals.confirmDelete(
                          context,
                          ctrl,
                          itemTitle: s.getCompany(ctrl.currentLang),
                          onConfirm: () => ctrl.deleteSupplier(s.id),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],

        // SUB-TAB 3: CASHBOOK P&L (ROZNAMCHA)
        if (ctrl.khataSubTab == 'cash') ...[
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderCol),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ctrl.tr('khCashTitle'),
                        style: _txt(ctrl, size: 13, weight: FontWeight.bold, color: textMain),
                      ),
                      Text(
                        ctrl.tr('khCashSub'),
                        style: _txt(ctrl, size: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => ErpModals.openCashEntryModal(context, ctrl),
                  child: Text(
                    ctrl.tr('btnKhExp'),
                    style: _txt(ctrl, size: 11, weight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...ctrl.cashLedger
              .map((e) => _buildCashLedgerRow(context, ctrl, e, isDark, textMain)),
        ],
      ],
    );
  }

  static Widget _khataSubBtn(ErpController ctrl, String key, String label) {
    final active = ctrl.khataSubTab == key;
    return Expanded(
      child: InkWell(
        onTap: () => ctrl.setKhataSubTab(key),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? ctrl.palette.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: _txt(
              ctrl,
              size: 11.5,
              weight: active ? FontWeight.bold : FontWeight.w600,
              color: active
                  ? Colors.white
                  : (ctrl.isDarkMode ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _khataStatCol(
      ErpController ctrl, String label, String val, Color valCol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _txt(ctrl, size: 10, color: Colors.grey)),
        Text(val, style: _num(size: 12, weight: FontWeight.w800, color: valCol)),
      ],
    );
  }

  // ===========================================================================
  // MODULE 6: PAINTERS & TOKENS LOYALTY SYSTEM
  // ===========================================================================
  static Widget buildPaintersView(BuildContext context, ErpController ctrl) {
    final isDark = ctrl.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderCol = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textMain = isDark ? Colors.white : const Color(0xFF1E293B);

    double totalUnpaid = 0;
    double totalRefSales = 0;
    for (final p in ctrl.painters) {
      totalUnpaid += p.unpaidCommission;
      totalRefSales += p.referredSales;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ctrl.palette.headerStart, const Color(0xFF312E81)],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ctrl.tr('pntMainTitle'),
                          style:
                              _txt(ctrl, size: 13.5, weight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          ctrl.tr('pntMainSub'),
                          style: _txt(ctrl, size: 11, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBBF24),
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => ErpModals.openTokenScanModal(context, ctrl),
                        child: Text(
                          ctrl.tr('btnScanToken'),
                          style: _txt(ctrl,
                              size: 11, weight: FontWeight.w800, color: const Color(0xFF0F172A)),
                        ),
                      ),
                      const SizedBox(height: 5),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white38),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => ErpModals.openPainterModal(context, ctrl),
                        child: Text(
                          ctrl.tr('btnAddPainter'),
                          style: _txt(ctrl, size: 10.5, weight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 18),
              Row(
                children: [
                  Expanded(
                    child: _invKpiMini(
                      ctrl,
                      ctrl.tr('pntLblUnpaid'),
                      ctrl.formatMoney(totalUnpaid),
                      const Color(0xFFFBBF24),
                    ),
                  ),
                  Expanded(
                    child: _invKpiMini(
                      ctrl,
                      ctrl.tr('pntLblSales'),
                      ctrl.formatMoney(totalRefSales),
                      const Color(0xFF6EE7B7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...ctrl.painters.map((p) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderCol),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.getName(ctrl.currentLang),
                            style: _txt(ctrl, size: 13, weight: FontWeight.bold, color: textMain),
                          ),
                          Text(
                            '${p.getSpecialty(ctrl.currentLang)} • ${p.phone}',
                            style: _txt(ctrl, size: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.purple.withValues(alpha: 0.35)),
                      ),
                      child: Text(
                        '${p.tokensRedeemed} ${ctrl.tr('tokensWord')}',
                        style: _txt(ctrl, size: 11, weight: FontWeight.bold, color: Colors.purple),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ctrl.tr('pntLblUnpaid'),
                              style: _txt(ctrl, size: 10.5, color: Colors.grey)),
                          Text(
                            ctrl.formatMoney(p.unpaidCommission),
                            style: _num(
                              size: 13,
                              weight: FontWeight.w900,
                              color: isDark ? Colors.amberAccent : ctrl.palette.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (p.unpaidCommission > 0)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ctrl.palette.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => ctrl.payPainterCommission(p.id),
                            child: Text(
                              ctrl.tr('payCommBtn'),
                              style: _txt(ctrl,
                                  size: 11, weight: FontWeight.bold, color: Colors.white),
                            ),
                          )
                        else
                          Text(
                            ctrl.tr('settledWord'),
                            style: _txt(ctrl,
                                size: 11.5,
                                weight: FontWeight.bold,
                                color: const Color(0xFF059669)),
                          ),
                        const SizedBox(width: 8),
                        _editDeleteButtons(
                          isDark: isDark,
                          onEdit: () => ErpModals.openPainterModal(context, ctrl, existing: p),
                          onDelete: () => ErpModals.confirmDelete(
                            context,
                            ctrl,
                            itemTitle: p.getName(ctrl.currentLang),
                            onConfirm: () => ctrl.deletePainter(p.id),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

