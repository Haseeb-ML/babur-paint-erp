import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/erp_models.dart';
import '../../state/erp_controller.dart';
import '../../theme/app_themes.dart';

class ErpModals {
  static TextStyle _txt(ErpController ctrl,
      {double size = 13, FontWeight weight = FontWeight.normal, Color? color}) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: ctrl.isRtl ? 1.65 : 1.35,
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

  // ===========================================================================
  // 1. DELETE CONFIRMATION DIALOG (UNIVERSAL)
  // ===========================================================================
  static Future<void> confirmDelete(
    BuildContext context,
    ErpController ctrl, {
    required String itemTitle,
    required VoidCallback onConfirm,
  }) async {
    final isDark = ctrl.isDarkMode;
    await showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  ctrl.tr('confirmDeleteTitle'),
                  style: _txt(ctrl,
                      size: 14,
                      weight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B)),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemTitle,
                style: _txt(ctrl,
                    size: 13,
                    weight: FontWeight.bold,
                    color: ctrl.palette.primary),
              ),
              const SizedBox(height: 6),
              Text(
                ctrl.tr('confirmDeleteSub'),
                style: _txt(ctrl,
                    size: 12,
                    color: isDark ? Colors.white70 : Colors.black54),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(ctrl.tr('cancelBtn'),
                  style: _txt(ctrl, size: 12, weight: FontWeight.w600, color: Colors.grey)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                onConfirm();
              },
              icon: const Icon(Icons.delete_outline, size: 16),
              label: Text(ctrl.tr('yesDeleteBtn'),
                  style: _txt(ctrl, size: 12, weight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 2. THEME & LANGUAGE & BACKUP SELECTOR MODAL
  // ===========================================================================
  static void openThemeAndSettingsModal(BuildContext context, ErpController ctrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ListenableBuilder(
        listenable: ctrl,
        builder: (ctx, _) {
          final isDark = ctrl.isDarkMode;
          return Directionality(
            textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.86,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.palette_rounded, color: ctrl.palette.primary, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ctrl.tr('themeTitle'),
                            style: _txt(ctrl,
                                size: 15,
                                weight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF1E293B)),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                      ],
                    ),
                    const Divider(),
                    // 3 Languages Selector
                    Text(
                      ctrl.currentLang == 'ur'
                          ? 'زبان منتخب کریں (3 Languages):'
                          : 'Select Language (3 Languages):',
                      style: _txt(ctrl,
                          size: 12,
                          weight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _langBtn(ctrl, 'ur', 'اردو (RTL)'),
                        const SizedBox(width: 8),
                        _langBtn(ctrl, 'ro', 'Roman Urdu'),
                        const SizedBox(width: 8),
                        _langBtn(ctrl, 'en', 'English'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Light / Dark Toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        ctrl.currentLang == 'ur'
                            ? 'ڈارک موڈ (رات کی تھیم)'
                            : 'Dark Mode (Night Theme)',
                        style: _txt(ctrl,
                            size: 13,
                            weight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87),
                      ),
                      value: ctrl.isDarkMode,
                      activeThumbColor: ctrl.palette.accent,
                      onChanged: (_) => ctrl.toggleDarkMode(),
                    ),
                    const SizedBox(height: 6),
                    // 5 Paint Theme Palettes
                    ...List.generate(AppThemes.palettes.length, (idx) {
                      final p = AppThemes.palettes[idx];
                      final selected = ctrl.paletteIndex == idx;
                      return GestureDetector(
                        onTap: () => ctrl.setPaletteIndex(idx),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [p.headerStart, p.headerEnd]),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected ? p.accent : Colors.white24,
                              width: selected ? 2.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 11,
                                backgroundColor: p.accent,
                                child: selected
                                    ? const Icon(Icons.check, size: 14, color: Colors.black)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  p.getName(ctrl.currentLang),
                                  style: _txt(ctrl,
                                      size: 12.5, weight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                              openEditShopModal(context, ctrl);
                            },
                            icon: const Icon(Icons.edit_note_rounded, size: 18),
                            label: Text(
                              ctrl.currentLang == 'ur'
                                  ? 'دکان معلومات ترمیم'
                                  : 'Edit Shop Info',
                              style: _txt(ctrl, size: 11.5, weight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => ctrl.triggerCloudSync(),
                            icon: const Icon(Icons.cloud_sync_rounded, size: 18),
                            label: Text(
                              ctrl.currentLang == 'ur'
                                  ? 'آن لائن بیک اپ سنک'
                                  : 'Cloud Sync Now',
                              style: _txt(ctrl,
                                  size: 11.5, weight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          confirmDelete(
                            context,
                            ctrl,
                            itemTitle: ctrl.currentLang == 'ur'
                                ? 'گوبیز پینٹس کا اصل ڈیٹا ری سیٹ کریں'
                                : "Reset to Original Gobi's Catalog Data",
                            onConfirm: () => ctrl.resetToDefaultGobisData(),
                          );
                        },
                        icon: const Icon(Icons.restore_rounded, size: 16, color: Colors.orange),
                        label: Text(
                          ctrl.currentLang == 'ur'
                              ? 'گوبیز پینٹس کا ڈیفالٹ ڈیٹا دوبارہ بحال کریں'
                              : "Restore Default Gobi's Paints Catalog",
                          style: _txt(ctrl, size: 11.5, weight: FontWeight.w600, color: Colors.orange),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _langBtn(ErpController ctrl, String code, String label) {
    final active = ctrl.currentLang == code;
    return Expanded(
      child: InkWell(
        onTap: () => ctrl.setLanguage(code),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? ctrl.palette.primary : Colors.grey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? ctrl.palette.primary : Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: active
                  ? Colors.white
                  : (ctrl.isDarkMode ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 3. EDIT SHOP PROFILE / INVOICE HEADER MODAL
  // ===========================================================================
  static void openEditShopModal(BuildContext context, ErpController ctrl) {
    final nameCtrl = TextEditingController(text: ctrl.shopProfile.getName(ctrl.currentLang));
    final addrCtrl = TextEditingController(text: ctrl.shopProfile.address);
    final phoneCtrl = TextEditingController(text: ctrl.shopProfile.phone);
    final emailCtrl = TextEditingController(text: ctrl.shopProfile.email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = ctrl.isDarkMode;
        return Directionality(
          textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ctrl.tr('shopEditTitle'),
                            style: _txt(ctrl,
                                size: 15,
                                weight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF1E293B)),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _inputField(ctrl, nameCtrl, 'Shop Name / دکان کا نام'),
                    const SizedBox(height: 8),
                    _inputField(ctrl, addrCtrl, 'Address / پتہ'),
                    const SizedBox(height: 8),
                    _inputField(ctrl, phoneCtrl, 'Phone / فون نمبر'),
                    const SizedBox(height: 8),
                    _inputField(ctrl, emailCtrl, 'Email / ای میل'),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ctrl.palette.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          final n = nameCtrl.text.trim();
                          final a = addrCtrl.text.trim();
                          final p = phoneCtrl.text.trim();
                          final e = emailCtrl.text.trim();
                          ctrl.updateShopProfile(ShopProfile(
                            nameUr: n.isEmpty ? ctrl.shopProfile.nameUr : n,
                            nameRo: n.isEmpty ? ctrl.shopProfile.nameRo : n,
                            nameEn: n.isEmpty ? ctrl.shopProfile.nameEn : n,
                            subUr: '$a • $p',
                            subRo: '$a • $p',
                            subEn: '$a • $p',
                            address: a,
                            phone: p,
                            email: e,
                          ));
                          Navigator.pop(ctx);
                        },
                        child: Text(ctrl.tr('btnStkSave'),
                            style: _txt(ctrl, size: 13, weight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // 4. POS CART & INVOICE CHECKOUT MODAL (WITH BABUR & BROTHERS RECEIPT)
  // ===========================================================================
  static void openPosCartModal(BuildContext context, ErpController ctrl) {
    final custNameCtrl = TextEditingController(text: ctrl.tr('walkInCust'));
    final custPhoneCtrl = TextEditingController(text: '0300-0000000');
    final discountCtrl = TextEditingController(text: '0');
    int? selectedPainterId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => ListenableBuilder(
          listenable: ctrl,
          builder: (ctx, _) {
            final isDark = ctrl.isDarkMode;
            final double disc = double.tryParse(discountCtrl.text) ?? 0;
            final double grand = (ctrl.cartTotal - disc) > 0 ? (ctrl.cartTotal - disc) : 0;

            return Directionality(
              textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(ctx).size.height * 0.88,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/logo.jpeg',
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const Icon(Icons.receipt_long, color: Colors.amber),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                ctrl.tr('modalCartTitle'),
                                style: _txt(ctrl,
                                    size: 14,
                                    weight: FontWeight.bold,
                                    color: isDark ? Colors.amber[300] : ctrl.palette.primary),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(Icons.close_rounded, size: 20),
                            ),
                          ],
                        ),
                        const Divider(),
                        if (ctrl.posCart.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              ctrl.tr('cartEmpty'),
                              style: _txt(ctrl, size: 13, color: Colors.grey),
                            ),
                          )
                        else
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: ctrl.posCart.length,
                              itemBuilder: (_, idx) {
                                final c = ctrl.posCart[idx];
                                final sub = c.price * c.qty;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF1E293B)
                                        : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark ? Colors.white12 : Colors.black12,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              c.getName(ctrl.currentLang),
                                              style: _txt(ctrl,
                                                  size: 12,
                                                  weight: FontWeight.bold,
                                                  color: isDark ? Colors.white : Colors.black87),
                                            ),
                                            Text(
                                              '${ctrl.formatMoney(c.price)} × ${c.qty} = ${ctrl.formatMoney(sub)}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF2563EB),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _qtySmallBtn(
                                              icon: Icons.remove,
                                              color: Colors.redAccent,
                                              onTap: () => ctrl.changeCartQty(idx, -1),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                '${c.qty}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark ? Colors.white : Colors.black87,
                                                ),
                                              ),
                                            ),
                                            _qtySmallBtn(
                                              icon: Icons.add,
                                              color: ctrl.palette.primary,
                                              onTap: () => ctrl.changeCartQty(idx, 1),
                                            ),
                                            const SizedBox(width: 4),
                                            _qtySmallBtn(
                                              icon: Icons.delete_outline,
                                              color: Colors.grey,
                                              onTap: () => ctrl.removeCartItem(idx),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(ctrl.tr('lblCartCust'),
                                        style: _txt(ctrl, size: 12, weight: FontWeight.w600)),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: _compactInput(ctrl, custNameCtrl),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(ctrl.tr('lblCartPainter'),
                                        style: _txt(ctrl, size: 12, weight: FontWeight.w600)),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: isDark ? Colors.white24 : Colors.black26),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<int?>(
                                          value: selectedPainterId,
                                          isExpanded: true,
                                          dropdownColor:
                                              isDark ? const Color(0xFF0F172A) : Colors.white,
                                          items: [
                                            DropdownMenuItem<int?>(
                                              value: null,
                                              child: Text(ctrl.tr('directNoPainter'),
                                                  style: _txt(ctrl, size: 11.5)),
                                            ),
                                            ...ctrl.painters.map(
                                              (p) => DropdownMenuItem<int?>(
                                                value: p.id,
                                                child: Text(
                                                  '${p.getName(ctrl.currentLang)} (5%)',
                                                  style: _txt(ctrl, size: 11.5),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                          onChanged: (v) =>
                                              setModalState(() => selectedPainterId = v),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(ctrl.tr('lblCartDiscount'),
                                        style: _txt(ctrl, size: 12, weight: FontWeight.w600)),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: _compactInput(
                                      ctrl,
                                      discountCtrl,
                                      isNumber: true,
                                      onChanged: (_) => setModalState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ctrl.tr('lblCartGrand'),
                                    style: _txt(ctrl, size: 13, weight: FontWeight.bold),
                                  ),
                                  Text(
                                    ctrl.formatMoney(grand),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: isDark ? Colors.cyanAccent : ctrl.palette.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (ctrl.posCart.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                openInvoicePreviewDialog(
                                  context,
                                  ctrl,
                                  customerName: custNameCtrl.text,
                                  discount: disc,
                                );
                              },
                              icon: const Icon(Icons.print_rounded, size: 17),
                              label: Text(ctrl.tr('printInvoiceBtn'),
                                  style: _txt(ctrl, size: 12, weight: FontWeight.bold)),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF059669),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  ctrl.completePosCheckout(
                                    mode: 'Cash',
                                    customerName: custNameCtrl.text,
                                    customerPhone: custPhoneCtrl.text,
                                    painterId: selectedPainterId,
                                    discount: disc,
                                  );
                                  Navigator.pop(ctx);
                                },
                                child: Text(
                                  ctrl.tr('btnCartCash'),
                                  style: _txt(ctrl,
                                      size: 12, weight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF59E0B),
                                  foregroundColor: const Color(0xFF0F172A),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  ctrl.completePosCheckout(
                                    mode: 'Udhar',
                                    customerName: custNameCtrl.text,
                                    customerPhone: custPhoneCtrl.text,
                                    painterId: selectedPainterId,
                                    discount: disc,
                                  );
                                  Navigator.pop(ctx);
                                },
                                child: Text(
                                  ctrl.tr('btnCartUdhar'),
                                  style: _txt(ctrl,
                                      size: 12,
                                      weight: FontWeight.bold,
                                      color: const Color(0xFF0F172A)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // 5. OFFICIAL BABUR & BROTHERS HARDWARE INVOICE RECEIPT DIALOG
  // ===========================================================================
  static void openInvoicePreviewDialog(
    BuildContext context,
    ErpController ctrl, {
    required String customerName,
    required double discount,
  }) {
    final grand = (ctrl.cartTotal - discount) > 0 ? (ctrl.cartTotal - discount) : 0;
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            width: 340,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090D16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/logo.jpeg',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'BABUR & BROTHERS HARDWARE',
                                style: TextStyle(
                                  color: Color(0xFFF59E0B),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.5,
                                ),
                              ),
                              Text(
                                ctrl.shopProfile.address,
                                style: const TextStyle(color: Colors.white70, fontSize: 10.5),
                              ),
                              Text(
                                '${ctrl.shopProfile.phone} • ${ctrl.shopProfile.email}',
                                style: const TextStyle(color: Colors.amberAccent, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Customer: $customerName',
                          style: const TextStyle(
                              fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const Text('Gobi\'s Official Dealer',
                          style: TextStyle(fontSize: 10.5, color: Colors.black54)),
                    ],
                  ),
                  const Divider(color: Colors.black26),
                  ...ctrl.posCart.map((c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${c.getName(ctrl.currentLang)} ×${c.qty}',
                                style: const TextStyle(fontSize: 11.5, color: Colors.black87),
                              ),
                            ),
                            Text(
                              ctrl.formatMoney(c.price * c.qty),
                              style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      )),
                  const Divider(color: Colors.black26),
                  if (discount > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount:',
                            style: TextStyle(fontSize: 11.5, color: Colors.redAccent)),
                        Text('-${ctrl.formatMoney(discount)}',
                            style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent)),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ctrl.tr('lblCartGrand'),
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text(ctrl.formatMoney(grand),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E3A8A))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final lines = [
                  '*BABUR & BROTHERS HARDWARE*',
                  ctrl.shopProfile.address,
                  'Tel: ${ctrl.shopProfile.phone}',
                  'Customer: $customerName',
                  '------------------------',
                  ...ctrl.posCart.map(
                      (c) => '${c.getName(ctrl.currentLang)} x${c.qty} = ${ctrl.formatMoney(c.price * c.qty)}'),
                  '------------------------',
                  'TOTAL: ${ctrl.formatMoney(grand)}',
                ].join('\n');
                Clipboard.setData(ClipboardData(text: lines));
                Navigator.pop(ctx);
                ctrl.showToast(ctrl.currentLang == 'ur'
                    ? 'بل واٹس ایپ کے لیے کاپی ہو گیا!'
                    : 'Invoice copied for WhatsApp share!');
              },
              icon: const Icon(Icons.share_rounded, size: 16),
              label: const Text('Copy for WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 6. ROOM PAINT COVERAGE ESTIMATOR MODAL
  // ===========================================================================
  static void openEstimatorModal(BuildContext context, ErpController ctrl) {
    final wCtrl = TextEditingController(text: '14');
    final lCtrl = TextEditingController(text: '16');
    final hCtrl = TextEditingController(text: '11');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final isDark = ctrl.isDarkMode;
          final double w = double.tryParse(wCtrl.text) ?? 14;
          final double l = double.tryParse(lCtrl.text) ?? 16;
          final double h = double.tryParse(hCtrl.text) ?? 11;

          final wallArea = 2 * (w + l) * h;
          final ceilingArea = w * l;
          final int netPaintArea = ((wallArea + ceilingArea) * 0.88).round().clamp(100, 99999);
          final double litersNeeded = netPaintArea / 65.0;
          final int gallonsNeeded = (litersNeeded / 3.64).ceil().clamp(1, 999);
          final int puttyDrums = (netPaintArea / 450.0).ceil().clamp(1, 999);
          final double estimatedBill = (gallonsNeeded * 4468.0) + (puttyDrums * 4395.0);

          return Directionality(
            textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ctrl.tr('modalEstTitle'),
                              style: _txt(ctrl,
                                  size: 14,
                                  weight: FontWeight.bold,
                                  color: isDark ? Colors.cyanAccent : ctrl.palette.primary),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(Icons.close_rounded, size: 20),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: _labeledNumberBox(
                                ctrl, ctrl.tr('lblEstW'), wCtrl, () => setModalState(() {})),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _labeledNumberBox(
                                ctrl, ctrl.tr('lblEstL'), lCtrl, () => setModalState(() {})),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _labeledNumberBox(
                                ctrl, ctrl.tr('lblEstH'), hCtrl, () => setModalState(() {})),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                        ),
                        child: Column(
                          children: [
                            _estRow(
                              ctrl,
                              ctrl.tr('lblEstArea'),
                              ctrl.currentLang == 'ur'
                                  ? '$netPaintArea مربع فٹ'
                                  : '$netPaintArea sq.ft',
                              Colors.blue,
                            ),
                            const SizedBox(height: 6),
                            _estRow(
                              ctrl,
                              ctrl.tr('lblEstLiters'),
                              ctrl.currentLang == 'ur'
                                  ? '$gallonsNeeded گیلن (${litersNeeded.toStringAsFixed(1)} لیٹر)'
                                  : '$gallonsNeeded Gallons (${litersNeeded.toStringAsFixed(1)} L)',
                              Colors.amber[700]!,
                            ),
                            const SizedBox(height: 6),
                            _estRow(
                              ctrl,
                              ctrl.tr('lblEstPutty'),
                              ctrl.currentLang == 'ur'
                                  ? '$puttyDrums ڈرم ہرکولیس وال پٹین'
                                  : '$puttyDrums Drums Hercules Wall Putty',
                              const Color(0xFF059669),
                            ),
                            const Divider(height: 16),
                            _estRow(
                              ctrl,
                              ctrl.tr('lblEstCost'),
                              ctrl.formatMoney(estimatedBill),
                              isDark ? Colors.amberAccent : ctrl.palette.primary,
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ctrl.palette.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            ctrl.addEstimatePackageToPos(width: w, length: l, height: h);
                            Navigator.pop(ctx);
                          },
                          child: Text(
                            ctrl.tr('btnEstAdd'),
                            style: _txt(ctrl, size: 12.5, weight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _estRow(ErpController ctrl, String label, String val, Color valColor,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: _txt(ctrl,
                size: 12,
                weight: isBold ? FontWeight.bold : FontWeight.normal,
                color: ctrl.isDarkMode ? Colors.white70 : Colors.black87),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          val,
          style: _txt(ctrl, size: isBold ? 14 : 12.5, weight: FontWeight.w800, color: valColor),
        ),
      ],
    );
  }

  // ===========================================================================
  // 7. ADD OR EDIT PRODUCT / STOCK MODAL
  // ===========================================================================
  static void openProductModal(BuildContext context, ErpController ctrl, {PaintProduct? existing}) {
    final codeCtrl = TextEditingController(text: existing?.code ?? '');
    final nameCtrl = TextEditingController(text: existing?.getName(ctrl.currentLang) ?? '');
    final sizeCtrl = TextEditingController(text: existing?.getSize(ctrl.currentLang) ?? 'گیلن (3.64 لیٹر)');
    final costCtrl = TextEditingController(text: existing != null ? '${existing.costPrice.round()}' : '3800');
    final priceCtrl = TextEditingController(text: existing != null ? '${existing.salePrice.round()}' : '4468');
    final qtyCtrl = TextEditingController(text: existing != null ? '${existing.stock}' : '12');
    final minCtrl = TextEditingController(text: existing != null ? '${existing.minStock}' : '4');

    String brand = existing?.brand ?? 'Gobis';
    String series = existing?.series ?? 'Decorative';
    String cat = existing?.cat ?? 'Emulsion';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final isDark = ctrl.isDarkMode;
          return Directionality(
            textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ctrl.tr('modalStkTitle'),
                              style: _txt(ctrl,
                                  size: 14,
                                  weight: FontWeight.bold,
                                  color: isDark ? Colors.cyanAccent : ctrl.palette.primary),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(Icons.close_rounded, size: 20),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: _inputField(ctrl, codeCtrl, ctrl.tr('stkCodePh')),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 6,
                            child: _inputField(ctrl, nameCtrl, ctrl.tr('stkNamePh')),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _dropdownBox(
                              ctrl,
                              value: series,
                              items: const [
                                'Decorative',
                                'Carman NC',
                                'Silverline',
                                'BigBang 2K',
                                'Tusker 2K',
                                'NC Thinner',
                                'Stoving',
                                'Epoxy & Ind',
                                'Timberline',
                                'Ancillaries'
                              ],
                              onChanged: (v) => setModalState(() => series = v!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _dropdownBox(
                              ctrl,
                              value: cat,
                              items: const [
                                'Emulsion',
                                'Weather',
                                'Enamel',
                                'NC2K',
                                'Wood',
                                'StovingEpoxy',
                                'Hardware'
                              ],
                              onChanged: (v) => setModalState(() => cat = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _inputField(ctrl, sizeCtrl, 'Packing Size (e.g. Qtr / Gln / Drm)'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _inputField(ctrl, costCtrl, ctrl.tr('stkCostPh'), isNumber: true),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _inputField(ctrl, priceCtrl, ctrl.tr('stkPricePh'), isNumber: true),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _inputField(ctrl, qtyCtrl, ctrl.tr('stkQtyPh'), isNumber: true),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _inputField(ctrl, minCtrl, 'Min Alert Stock', isNumber: true),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ctrl.palette.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            final name = nameCtrl.text.trim();
                            if (name.isEmpty) return;
                            ctrl.saveOrUpdateProduct(
                              existingId: existing?.id,
                              code: codeCtrl.text.trim(),
                              brand: brand,
                              series: series,
                              cat: cat,
                              name: name,
                              sizeLabel: sizeCtrl.text.trim().isEmpty ? 'Gallon' : sizeCtrl.text.trim(),
                              costPrice: double.tryParse(costCtrl.text) ?? 3500,
                              salePrice: double.tryParse(priceCtrl.text) ?? 4200,
                              stock: int.tryParse(qtyCtrl.text) ?? 10,
                              minStock: int.tryParse(minCtrl.text) ?? 4,
                              colorHex: existing?.colorHex ?? '#93C5FD',
                            );
                            Navigator.pop(ctx);
                          },
                          child: Text(
                            ctrl.tr('btnStkSave'),
                            style: _txt(ctrl, size: 13, weight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // 8. ADD OR EDIT SHADE CARD MODAL
  // ===========================================================================
  static void openShadeModal(BuildContext context, ErpController ctrl, {ShadeItem? existing}) {
    final codeCtrl = TextEditingController(text: existing?.code ?? 'CS-105');
    final nameCtrl = TextEditingController(text: existing?.getName(ctrl.currentLang) ?? '');
    final basePriceCtrl =
        TextEditingController(text: existing != null ? '${existing.baseGallonPrice.round()}' : '4468');
    final tintPriceCtrl =
        TextEditingController(text: existing != null ? '${existing.tintCostGallon.round()}' : '250');
    final formulaCtrl = TextEditingController(
      text: existing != null && existing.pigments.isNotEmpty
          ? existing.pigments.first.getName(ctrl.currentLang)
          : 'ییلو آکسائیڈ پیسٹ',
    );
    final mlCtrl = TextEditingController(
      text: existing != null && existing.pigments.isNotEmpty
          ? '${existing.pigments.first.ml.round()}'
          : '18',
    );
    String series = existing?.series ?? 'WeatherGuard';
    String selectedHex = existing?.hex ?? '#93C572';

    const List<String> presetHexes = [
      '#F5E6C8',
      '#E6CFAF',
      '#C88557',
      '#9A6B56',
      '#6E7D8B',
      '#A7DCEB',
      '#67C5E8',
      '#D6EDC8',
      '#F4C8CF',
      '#FBE134',
      '#C81D25',
      '#007C66',
      '#12466B',
      '#4A4846',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final isDark = ctrl.isDarkMode;
          return Directionality(
            textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ctrl.tr('modalCshTitle'),
                              style: _txt(ctrl,
                                  size: 14,
                                  weight: FontWeight.bold,
                                  color: isDark ? Colors.amberAccent : ctrl.palette.primary),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(Icons.close_rounded, size: 20),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: _inputField(ctrl, codeCtrl, ctrl.tr('cshCodePh')),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 6,
                            child: _dropdownBox(
                              ctrl,
                              value: series,
                              items: const ['WeatherGuard', 'Emulsion', 'Enamel'],
                              onChanged: (v) => setModalState(() => series = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _inputField(ctrl, nameCtrl, ctrl.tr('cshNamePh')),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _inputField(ctrl, basePriceCtrl, 'Base Gallon Price', isNumber: true),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _inputField(ctrl, tintPriceCtrl, 'Tint Cost (Rs)', isNumber: true),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: _inputField(ctrl, formulaCtrl, ctrl.tr('cshFormulaPh')),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: _inputField(ctrl, mlCtrl, 'ml Shot', isNumber: true),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(ctrl.tr('lblCshPick'),
                          style: _txt(ctrl, size: 12, weight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: presetHexes.map((hx) {
                          final active = selectedHex.toUpperCase() == hx.toUpperCase();
                          return GestureDetector(
                            onTap: () => setModalState(() => selectedHex = hx),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: AppThemes.parseHex(hx),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: active ? ctrl.palette.primary : Colors.black26,
                                  width: active ? 3 : 1,
                                ),
                              ),
                              child: active
                                  ? const Icon(Icons.check, size: 16, color: Colors.black)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ctrl.palette.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            final nm = nameCtrl.text.trim().isEmpty
                                ? 'Custom Shade'
                                : nameCtrl.text.trim();
                            ctrl.saveOrUpdateShade(
                              existingId: existing?.id,
                              code: codeCtrl.text.trim(),
                              series: series,
                              name: nm,
                              hex: selectedHex,
                              baseGallonPrice: double.tryParse(basePriceCtrl.text) ?? 4468,
                              tintCostGallon: double.tryParse(tintPriceCtrl.text) ?? 250,
                              formulaDesc: formulaCtrl.text.trim().isEmpty
                                  ? 'Pigment Paste'
                                  : formulaCtrl.text.trim(),
                              formulaMl: double.tryParse(mlCtrl.text) ?? 18,
                            );
                            Navigator.pop(ctx);
                          },
                          child: Text(
                            ctrl.tr('btnCshSave'),
                            style: _txt(ctrl, size: 13, weight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // 9. UDHAR PAYMENT RECOVERY & HISTORY MODAL (WITH DELETE ON HISTORY)
  // ===========================================================================
  static void openUdharPayModal(BuildContext context, ErpController ctrl, int custId) {
    final amtCtrl = TextEditingController();
    String method = ctrl.currentLang == 'ur' ? 'نقد وصولی' : 'Cash';

    final cInit = ctrl.customers.where((x) => x.id == custId).firstOrNull;
    if (cInit != null && cInit.remaining > 0) {
      amtCtrl.text = '${cInit.remaining.round()}';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => ListenableBuilder(
          listenable: ctrl,
          builder: (ctx, _) {
            final c = ctrl.customers.where((x) => x.id == custId).firstOrNull;
            if (c == null) return const SizedBox.shrink();
            final isDark = ctrl.isDarkMode;
            final rem = c.remaining;

            final methods = ctrl.currentLang == 'ur'
                ? ['نقد وصولی', 'جاز کیش / ایزی پیسہ', 'بینک ٹرانسفر']
                : ['Cash', 'JazzCash / EasyPaisa', 'Bank Transfer'];
            if (!methods.contains(method)) method = methods.first;

            return Directionality(
              textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(ctx).size.height * 0.88,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.getName(ctrl.currentLang),
                                    style: _txt(ctrl,
                                        size: 14,
                                        weight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87),
                                  ),
                                  Text(
                                    c.getWork(ctrl.currentLang),
                                    style: _txt(ctrl, size: 11.5, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(Icons.close_rounded, size: 20),
                            ),
                          ],
                        ),
                        const Divider(),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.amber),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ctrl.tr('lblUpayRem'),
                                      style: _txt(ctrl, size: 11.5, weight: FontWeight.w600)),
                                  Text(
                                    ctrl.formatMoney(rem),
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: isDark ? Colors.amberAccent : Colors.amber[900],
                                    ),
                                  ),
                                ],
                              ),
                              if (rem > 0)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF059669),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    ctrl.submitCustomerUdharRecovery(
                                      custId: c.id,
                                      amount: rem,
                                      method: method,
                                    );
                                    amtCtrl.clear();
                                  },
                                  child: Text(ctrl.tr('btnUpayFull'),
                                      style: _txt(ctrl,
                                          size: 11.5, weight: FontWeight.bold, color: Colors.white)),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ctrl.tr('lblUpayInput'),
                                  style: _txt(ctrl, size: 12, weight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: _inputField(ctrl, amtCtrl, 'Amount', isNumber: true),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 5,
                                    child: _dropdownBox(
                                      ctrl,
                                      value: method,
                                      items: methods,
                                      onChanged: (v) => setModalState(() => method = v!),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ctrl.palette.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 11),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    final amt = double.tryParse(amtCtrl.text) ?? 0;
                                    if (amt <= 0) return;
                                    ctrl.submitCustomerUdharRecovery(
                                      custId: c.id,
                                      amount: amt,
                                      method: method,
                                    );
                                    amtCtrl.clear();
                                  },
                                  child: Text(ctrl.tr('btnUpaySubmit'),
                                      style: _txt(ctrl,
                                          size: 12, weight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(ctrl.tr('lblUpayHist'),
                            style: _txt(ctrl, size: 12, weight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        ...c.history.map((h) {
                          final isPaid = h.type == 'paid';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? const Color(0xFF059669).withValues(alpha: 0.1)
                                  : Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isPaid
                                    ? const Color(0xFF059669).withValues(alpha: 0.4)
                                    : Colors.amber.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    h.getDesc(ctrl.currentLang),
                                    style: _txt(ctrl, size: 11.5, weight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  ctrl.formatMoney(h.amount),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isPaid ? const Color(0xFF059669) : Colors.amber[800],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                InkWell(
                                  onTap: () => ctrl.deleteCustomerHistoryEntry(c.id, h.id),
                                  child: const Icon(Icons.delete_outline,
                                      size: 17, color: Colors.redAccent),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // 10. ADD OR EDIT CUSTOMER KHATA MODAL
  // ===========================================================================
  static void openCustomerModal(BuildContext context, ErpController ctrl,
      {UdharCustomer? existing}) {
    final nameCtrl = TextEditingController(text: existing?.getName(ctrl.currentLang) ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final workCtrl = TextEditingController(text: existing?.getWork(ctrl.currentLang) ?? '');
    final givenCtrl =
        TextEditingController(text: existing != null ? '${existing.totalGiven.round()}' : '');
    final paidCtrl =
        TextEditingController(text: existing != null ? '${existing.totalPaid.round()}' : '0');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = ctrl.isDarkMode;
        return Directionality(
          textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ctrl.tr('modalNudTitle'),
                            style: _txt(ctrl,
                                size: 14,
                                weight: FontWeight.bold,
                                color: Colors.amber[700]),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                      ],
                    ),
                    const Divider(),
                    _inputField(ctrl, nameCtrl, ctrl.tr('nudNamePh')),
                    const SizedBox(height: 8),
                    _inputField(ctrl, phoneCtrl, ctrl.tr('nudPhonePh')),
                    const SizedBox(height: 8),
                    _inputField(ctrl, workCtrl, ctrl.tr('nudWorkPh')),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField(ctrl, givenCtrl, ctrl.tr('nudAmtPh'), isNumber: true),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _inputField(ctrl, paidCtrl, ctrl.tr('nudPaidPh'), isNumber: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          final nm = nameCtrl.text.trim();
                          final gv = double.tryParse(givenCtrl.text) ?? 0;
                          if (nm.isEmpty || gv <= 0) return;
                          ctrl.saveOrUpdateCustomer(
                            existingId: existing?.id,
                            name: nm,
                            phone: phoneCtrl.text.trim(),
                            work: workCtrl.text.trim().isEmpty
                                ? 'Paint & Hardware Supply'
                                : workCtrl.text.trim(),
                            totalGiven: gv,
                            totalPaid: double.tryParse(paidCtrl.text) ?? 0,
                          );
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          ctrl.tr('btnNudSave'),
                          style: _txt(ctrl,
                              size: 13, weight: FontWeight.bold, color: const Color(0xFF0F172A)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // 11. ADD OR EDIT SUPPLIER MODAL
  // ===========================================================================
  static void openSupplierModal(BuildContext context, ErpController ctrl,
      {SupplierAccount? existing}) {
    final compCtrl = TextEditingController(text: existing?.getCompany(ctrl.currentLang) ?? '');
    final supCtrl = TextEditingController(text: existing?.getLastSupply(ctrl.currentLang) ?? '');
    final totalCtrl =
        TextEditingController(text: existing != null ? '${existing.totalBill.round()}' : '');
    final paidCtrl =
        TextEditingController(text: existing != null ? '${existing.paidBill.round()}' : '0');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = ctrl.isDarkMode;
        return Directionality(
          textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ctrl.tr('btnKhNewSupp'),
                            style: _txt(ctrl,
                                size: 14, weight: FontWeight.bold, color: ctrl.palette.primary),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                      ],
                    ),
                    const Divider(),
                    _inputField(ctrl, compCtrl, 'Supplier / Company Name'),
                    const SizedBox(height: 8),
                    _inputField(ctrl, supCtrl, 'Supplied Stock Details'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField(ctrl, totalCtrl, 'Total Bill', isNumber: true),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _inputField(ctrl, paidCtrl, 'Paid Amount', isNumber: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ctrl.palette.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          final nm = compCtrl.text.trim();
                          final tb = double.tryParse(totalCtrl.text) ?? 0;
                          if (nm.isEmpty || tb <= 0) return;
                          ctrl.saveOrUpdateSupplier(
                            existingId: existing?.id,
                            company: nm,
                            lastSupply: supCtrl.text.trim().isEmpty
                                ? "Gobi's Paint Stock"
                                : supCtrl.text.trim(),
                            totalBill: tb,
                            paidBill: double.tryParse(paidCtrl.text) ?? 0,
                          );
                          Navigator.pop(ctx);
                        },
                        child: Text(ctrl.tr('btnNudSave'),
                            style: _txt(ctrl, size: 13, weight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // 12. ADD OR EDIT CASHBOOK (EXPENSE / INCOME) MODAL
  // ===========================================================================
  static void openCashEntryModal(BuildContext context, ErpController ctrl,
      {CashLedgerEntry? existing}) {
    final noteCtrl = TextEditingController(text: existing?.getDesc(ctrl.currentLang) ?? '');
    final amtCtrl =
        TextEditingController(text: existing != null ? '${existing.amount.round()}' : '');
    String type = existing?.type ?? 'expense';
    final cats = ctrl.currentLang == 'ur'
        ? [
            'کمپنی مال خریداری',
            'کلر مکسنگ مشین پیسٹ',
            'دکان کرایہ اور بجلی بل',
            'لوڈنگ اور رکشہ کرایہ',
            'پوائنٹ آف سیل نقد بل'
          ]
        : [
            'Paint Stock Purchase',
            'Tinting Machine Colorants',
            'Shop Rent & Electricity',
            'Loading & Delivery',
            'POS Counter Sale'
          ];
    String cat = existing?.getCat(ctrl.currentLang) ?? cats.first;
    if (!cats.contains(cat)) cats.insert(0, cat);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final isDark = ctrl.isDarkMode;
          return Directionality(
            textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ctrl.tr('modalExpTitle'),
                              style: _txt(ctrl,
                                  size: 14, weight: FontWeight.bold, color: Colors.redAccent),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(Icons.close_rounded, size: 20),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: Text(ctrl.currentLang == 'ur' ? 'خرچ (Expense)' : 'Expense'),
                              selected: type == 'expense',
                              onSelected: (_) => setModalState(() => type = 'expense'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: Text(ctrl.currentLang == 'ur' ? 'آمدن (Income)' : 'Income'),
                              selected: type == 'income',
                              onSelected: (_) => setModalState(() => type = 'income'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _dropdownBox(
                        ctrl,
                        value: cat,
                        items: cats,
                        onChanged: (v) => setModalState(() => cat = v!),
                      ),
                      const SizedBox(height: 8),
                      _inputField(ctrl, noteCtrl, ctrl.tr('expNotePh')),
                      const SizedBox(height: 8),
                      _inputField(ctrl, amtCtrl, ctrl.tr('expAmtPh'), isNumber: true),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                type == 'expense' ? Colors.redAccent : const Color(0xFF059669),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            final amt = double.tryParse(amtCtrl.text) ?? 0;
                            if (amt <= 0) return;
                            ctrl.saveOrUpdateCashEntry(
                              existingId: existing?.id,
                              type: type,
                              category: cat,
                              note: noteCtrl.text.trim().isEmpty ? cat : noteCtrl.text.trim(),
                              amount: amt,
                            );
                            Navigator.pop(ctx);
                          },
                          child: Text(ctrl.tr('btnExpSave'),
                              style:
                                  _txt(ctrl, size: 13, weight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // 13. PAINTER TOKEN REDEEM & ADD/EDIT PAINTER MODALS
  // ===========================================================================
  static void openTokenScanModal(BuildContext context, ErpController ctrl) {
    final codeCtrl = TextEditingController(text: 'GB-8841');
    final amtCtrl = TextEditingController(text: '500');
    int selectedPainterId = ctrl.painters.isNotEmpty ? ctrl.painters.first.id : 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final isDark = ctrl.isDarkMode;
          return Directionality(
            textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ctrl.tr('modalTokTitle'),
                              style: _txt(ctrl,
                                  size: 14, weight: FontWeight.bold, color: ctrl.palette.primary),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(Icons.close_rounded, size: 20),
                          ),
                        ],
                      ),
                      const Divider(),
                      if (ctrl.painters.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDark ? Colors.white24 : Colors.black26),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: selectedPainterId,
                              isExpanded: true,
                              items: ctrl.painters
                                  .map((p) => DropdownMenuItem<int>(
                                        value: p.id,
                                        child: Text(p.getName(ctrl.currentLang),
                                            style: _txt(ctrl, size: 12.5)),
                                      ))
                                  .toList(),
                              onChanged: (v) => setModalState(() => selectedPainterId = v!),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      _inputField(ctrl, codeCtrl, 'Token Code (e.g. GB-8841)'),
                      const SizedBox(height: 8),
                      _inputField(ctrl, amtCtrl, 'Token Cash Value (Rs)', isNumber: true),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ctrl.palette.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            ctrl.redeemPainterToken(
                              painterId: selectedPainterId,
                              tokenCode: codeCtrl.text.trim(),
                              amount: double.tryParse(amtCtrl.text) ?? 500,
                            );
                            Navigator.pop(ctx);
                          },
                          child: Text(ctrl.tr('btnTokSave'),
                              style:
                                  _txt(ctrl, size: 13, weight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static void openPainterModal(BuildContext context, ErpController ctrl,
      {PainterAccount? existing}) {
    final nameCtrl = TextEditingController(text: existing?.getName(ctrl.currentLang) ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '0300-1234567');
    final specCtrl = TextEditingController(
        text: existing?.getSpecialty(ctrl.currentLang) ?? 'Gobi\'s Weather Guard & Wood Polish');
    final commCtrl = TextEditingController(
        text: existing != null ? '${existing.unpaidCommission.round()}' : '0');
    final tokCtrl =
        TextEditingController(text: existing != null ? '${existing.tokensRedeemed}' : '1');
    final salesCtrl = TextEditingController(
        text: existing != null ? '${existing.referredSales.round()}' : '25000');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = ctrl.isDarkMode;
        return Directionality(
          textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ctrl.tr('pntMainTitle'),
                            style: _txt(ctrl,
                                size: 14, weight: FontWeight.bold, color: ctrl.palette.primary),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                      ],
                    ),
                    const Divider(),
                    _inputField(ctrl, nameCtrl, 'Painter Name / پینٹر کا نام'),
                    const SizedBox(height: 8),
                    _inputField(ctrl, phoneCtrl, 'Mobile Number'),
                    const SizedBox(height: 8),
                    _inputField(ctrl, specCtrl, 'Specialty / مہارت'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField(ctrl, commCtrl, 'Unpaid Commission', isNumber: true),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _inputField(ctrl, tokCtrl, 'Tokens Count', isNumber: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ctrl.palette.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          final nm = nameCtrl.text.trim();
                          if (nm.isEmpty) return;
                          ctrl.saveOrUpdatePainter(
                            existingId: existing?.id,
                            name: nm,
                            phone: phoneCtrl.text.trim(),
                            specialty: specCtrl.text.trim(),
                            unpaidCommission: double.tryParse(commCtrl.text) ?? 0,
                            tokensRedeemed: int.tryParse(tokCtrl.text) ?? 0,
                            referredSales: double.tryParse(salesCtrl.text) ?? 0,
                          );
                          Navigator.pop(ctx);
                        },
                        child: Text(ctrl.tr('btnNudSave'),
                            style: _txt(ctrl, size: 13, weight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // REUSABLE FORM HELPERS
  // ===========================================================================
  static Widget _inputField(
    ErpController ctrl,
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
  }) {
    final isDark = ctrl.isDarkMode;
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: _txt(ctrl,
          size: 12.5,
          weight: isNumber ? FontWeight.bold : FontWeight.normal,
          color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: _txt(ctrl, size: 11.5, color: Colors.grey),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black26),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black26),
        ),
      ),
    );
  }

  static Widget _compactInput(
    ErpController ctrl,
    TextEditingController controller, {
    bool isNumber = false,
    ValueChanged<String>? onChanged,
  }) {
    final isDark = ctrl.isDarkMode;
    return SizedBox(
      height: 34,
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onChanged: onChanged,
        style: _txt(ctrl,
            size: 12,
            weight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          filled: true,
          fillColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black26),
          ),
        ),
      ),
    );
  }

  static Widget _labeledNumberBox(
    ErpController ctrl,
    String label,
    TextEditingController controller,
    VoidCallback onChanged,
  ) {
    final isDark = ctrl.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: _txt(ctrl, size: 11, color: isDark ? Colors.white70 : Colors.black54)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (_) => onChanged(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.amberAccent : ctrl.palette.primary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  static Widget _dropdownBox(
    ErpController ctrl, {
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final isDark = ctrl.isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white24 : Colors.black26),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          items: items
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e, style: _txt(ctrl, size: 12)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  static Widget _qtySmallBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }
}
