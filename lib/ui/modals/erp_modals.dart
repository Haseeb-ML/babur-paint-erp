import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/gobis_shade_cards.dart';
import '../../models/erp_models.dart';
import '../../services/invoice_pdf_service.dart';
import '../../state/erp_controller.dart';
import '../../theme/app_themes.dart';
import '../views/invoices_screen.dart';

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
    bool discountIsPercent = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => ListenableBuilder(
          listenable: ctrl,
          builder: (ctx, _) {
            final isDark = ctrl.isDarkMode;
            final double rawInput = double.tryParse(discountCtrl.text) ?? 0;
            final double disc = discountIsPercent
                ? (ctrl.cartTotal * (rawInput.clamp(0, 100)) / 100.0)
                : rawInput;
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
                                    child: Text(ctrl.tr('lblCartPhone'),
                                        style: _txt(ctrl, size: 12, weight: FontWeight.w600)),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: _compactInput(
                                      ctrl,
                                      custPhoneCtrl,
                                      isNumber: true,
                                      hint: '03001234567',
                                    ),
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(ctrl.tr('lblCartDiscount'),
                                            style: _txt(ctrl, size: 12, weight: FontWeight.w600)),
                                        if (disc > 0)
                                          Text(
                                            discountIsPercent
                                                ? '${rawInput.toStringAsFixed(rawInput == rawInput.roundToDouble() ? 0 : 1)}% = -${ctrl.formatMoney(disc)}'
                                                : '-${ctrl.formatMoney(disc)}',
                                            style: const TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF10B981),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () => setModalState(() {
                                            discountIsPercent = true;
                                            discountCtrl.text = '0';
                                          }),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: discountIsPercent ? ctrl.palette.primary : Colors.transparent,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '%',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: discountIsPercent ? Colors.white : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => setModalState(() {
                                            discountIsPercent = false;
                                            discountCtrl.text = '0';
                                          }),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: !discountIsPercent ? ctrl.palette.primary : Colors.transparent,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'Rs',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: !discountIsPercent ? Colors.white : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    flex: 4,
                                    child: _compactInput(
                                      ctrl,
                                      discountCtrl,
                                      isNumber: true,
                                      onChanged: (_) => setModalState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              if (discountIsPercent) ...[
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [0, 2, 5, 10, 15].map((pct) {
                                    final isSelected = (double.tryParse(discountCtrl.text) ?? -1) == pct;
                                    return InkWell(
                                      onTap: () => setModalState(() {
                                        discountCtrl.text = '$pct';
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? ctrl.palette.primary
                                              : (isDark ? const Color(0xFF0F172A) : Colors.white),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelected
                                                ? ctrl.palette.primary
                                                : Colors.grey.withValues(alpha: 0.35),
                                          ),
                                        ),
                                        child: Text(
                                          '$pct%',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : (isDark ? Colors.white70 : Colors.black87),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
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
                                  final inv = ctrl.completePosCheckout(
                                    mode: 'Cash',
                                    customerName: custNameCtrl.text,
                                    customerPhone: custPhoneCtrl.text,
                                    painterId: selectedPainterId,
                                    discount: disc,
                                  );
                                  Navigator.pop(ctx);
                                  if (inv != null) {
                                    openInvoiceDialog(context, ctrl, inv);
                                  }
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
                                  final inv = ctrl.completePosCheckout(
                                    mode: 'Udhar',
                                    customerName: custNameCtrl.text,
                                    customerPhone: custPhoneCtrl.text,
                                    painterId: selectedPainterId,
                                    discount: disc,
                                  );
                                  Navigator.pop(ctx);
                                  if (inv != null) {
                                    openInvoiceDialog(context, ctrl, inv);
                                  }
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
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
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
                            width: 44,
                            height: 44,
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
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                ctrl.shopProfile.address,
                                style: const TextStyle(color: Colors.white70, fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  '${ctrl.shopProfile.phone} • ${ctrl.shopProfile.email}',
                                  style: const TextStyle(color: Colors.amberAccent, fontSize: 9.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Customer: $customerName',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Text(
                          'Gobi\'s Official Dealer',
                          style: TextStyle(fontSize: 10, color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
              child: Text(ctrl.currentLang == 'ur' ? 'بند کریں' : 'Close'),
            ),
            OutlinedButton.icon(
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
              icon: const Icon(Icons.copy_rounded, size: 15),
              label: Text(ctrl.currentLang == 'ur' ? 'کاپی' : 'Copy Text'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                final now = DateTime.now();
                final dateStr =
                    '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
                final previewInv = InvoiceRecord(
                  id: now.millisecondsSinceEpoch,
                  invoiceNo: 'DRAFT',
                  customerName: customerName.isEmpty ? 'Walk-in Cash Customer' : customerName,
                  customerPhone: '',
                  mode: 'Cash',
                  items: List.from(ctrl.posCart),
                  subtotal: ctrl.cartTotal,
                  discount: discount,
                  total: grand.toDouble(),
                  dateStr: dateStr,
                  timestamp: now.millisecondsSinceEpoch,
                );
                InvoicePdfService.openInvoicePdfPreview(context, ctrl, previewInv);
              },
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
              label: Text(ctrl.currentLang == 'ur' ? 'پرنٹ / پی ڈی ایف' : 'Print / PDF'),
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
    final barcodeCtrl = TextEditingController(text: existing?.barcode ?? existing?.code ?? '');
    final nameCtrl = TextEditingController(text: existing?.getName(ctrl.currentLang) ?? '');
    final sizeCtrl = TextEditingController(text: existing?.getSize(ctrl.currentLang) ?? 'گیلن (3.64 لیٹر)');
    final costCtrl = TextEditingController(text: existing != null ? '${existing.costPrice.round()}' : '3800');
    final priceCtrl = TextEditingController(text: existing != null ? '${existing.salePrice.round()}' : '4468');
    final qtyCtrl = TextEditingController(text: existing != null ? '${existing.stock}' : '12');
    final minCtrl = TextEditingController(text: existing != null ? '${existing.minStock}' : '4');
    final shadeCodeCtrl = TextEditingController(text: existing?.shadeCode ?? '');
    final shadeNameCtrl = TextEditingController(text: existing?.shadeName ?? '');

    String brand = existing?.brand ?? 'Gobis';
    String series = existing?.series ?? 'Decorative';
    String cat = existing?.cat ?? 'Emulsion';

    final seriesItems = [
      'Gold',
      'Hercules',
      'Protector',
      'Decorative',
      'Carman NC',
      'Silverline',
      'BigBang 2K',
      'Tusker 2K',
      'NC Thinner',
      'Stoving',
      'Epoxy & Ind',
      'Timberline',
      'Ancillaries',
    ];
    if (!seriesItems.contains(series)) seriesItems.add(series);
    final catItems = [
      'Emulsion',
      'Weather',
      'Enamel',
      'NC2K',
      'Wood',
      'StovingEpoxy',
      'Hardware',
    ];
    if (!catItems.contains(cat)) catItems.add(cat);

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
                            child: _inputField(ctrl, barcodeCtrl, 'Barcode (EAN-13 / Code-128)'),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            tooltip: 'Scan with Camera',
                            style: IconButton.styleFrom(
                              backgroundColor: ctrl.palette.primary.withValues(alpha: 0.12),
                              foregroundColor: ctrl.palette.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () async {
                              final scanned = await _scanSingleBarcode(context, ctrl);
                              if (scanned != null && scanned.isNotEmpty) {
                                barcodeCtrl.text = scanned;
                                setModalState(() {});
                              }
                            },
                            icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
                          ),
                          const SizedBox(width: 6),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF59E0B),
                              foregroundColor: const Color(0xFF0F172A),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              final gen = '8964000${(DateTime.now().millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0')}';
                              barcodeCtrl.text = gen;
                              setModalState(() {});
                            },
                            icon: const Icon(Icons.auto_fix_high, size: 16),
                            label: Text(ctrl.tr('autoGenerateBarcode'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
                              items: seriesItems,
                              onChanged: (v) => setModalState(() => series = v!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _dropdownBox(
                              ctrl,
                              value: cat,
                              items: catItems,
                              onChanged: (v) => setModalState(() => cat = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: _inputField(ctrl, shadeCodeCtrl, 'Shade # (e.g. 1400)'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 6,
                            child: _inputField(ctrl, shadeNameCtrl, 'Shade Colour (e.g. White)'),
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
                      if (existing != null) ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                  side: const BorderSide(color: Colors.redAccent),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  confirmDelete(
                                    context,
                                    ctrl,
                                    itemTitle: existing.getName(ctrl.currentLang),
                                    onConfirm: () {
                                      Navigator.pop(ctx);
                                      ctrl.deleteProduct(existing.id);
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete_outline, size: 16),
                                label: Text(
                                  ctrl.currentLang == 'ur' ? 'حذف کریں' : 'Delete',
                                  style: _txt(ctrl,
                                      size: 12,
                                      weight: FontWeight.bold,
                                      color: Colors.redAccent),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ctrl.palette.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  final name = nameCtrl.text.trim();
                                  if (name.isEmpty) return;
                                  ctrl.saveOrUpdateProduct(
                                    existingId: existing.id,
                                    code: codeCtrl.text.trim(),
                                    barcode: barcodeCtrl.text.trim(),
                                    brand: brand,
                                    series: series,
                                    cat: cat,
                                    name: name,
                                    sizeLabel: sizeCtrl.text.trim().isEmpty
                                        ? 'Gallon'
                                        : sizeCtrl.text.trim(),
                                    costPrice: double.tryParse(costCtrl.text) ?? 3500,
                                    salePrice: double.tryParse(priceCtrl.text) ?? 4200,
                                    stock: int.tryParse(qtyCtrl.text) ?? 10,
                                    minStock: int.tryParse(minCtrl.text) ?? 4,
                                    colorHex: existing.colorHex,
                                    shadeCode: shadeCodeCtrl.text.trim(),
                                    shadeName: shadeNameCtrl.text.trim(),
                                  );
                                  Navigator.pop(ctx);
                                },
                                child: Text(
                                  ctrl.currentLang == 'ur' ? 'اپڈیٹ کریں' : 'Update Product',
                                  style: _txt(ctrl,
                                      size: 13,
                                      weight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
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
                                existingId: null,
                                code: codeCtrl.text.trim(),
                                barcode: barcodeCtrl.text.trim(),
                                brand: brand,
                                series: series,
                                cat: cat,
                                name: name,
                                sizeLabel: sizeCtrl.text.trim().isEmpty ? 'Gallon' : sizeCtrl.text.trim(),
                                costPrice: double.tryParse(costCtrl.text) ?? 3500,
                                salePrice: double.tryParse(priceCtrl.text) ?? 4200,
                                stock: int.tryParse(qtyCtrl.text) ?? 10,
                                minStock: int.tryParse(minCtrl.text) ?? 4,
                                colorHex: '#93C5FD',
                                shadeCode: shadeCodeCtrl.text.trim(),
                                shadeName: shadeNameCtrl.text.trim(),
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
                      if (existing != null) ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                  side: const BorderSide(color: Colors.redAccent),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  confirmDelete(
                                    context,
                                    ctrl,
                                    itemTitle:
                                        '${existing.code} - ${existing.getName(ctrl.currentLang)}',
                                    onConfirm: () {
                                      Navigator.pop(ctx);
                                      ctrl.deleteShade(existing.id);
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete_outline, size: 16),
                                label: Text(
                                  ctrl.currentLang == 'ur' ? 'حذف' : 'Delete',
                                  style: _txt(ctrl,
                                      size: 12,
                                      weight: FontWeight.bold,
                                      color: Colors.redAccent),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ctrl.palette.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  final nm = nameCtrl.text.trim().isEmpty
                                      ? 'Custom Shade'
                                      : nameCtrl.text.trim();
                                  ctrl.saveOrUpdateShade(
                                    existingId: existing.id,
                                    code: codeCtrl.text.trim(),
                                    series: series,
                                    name: nm,
                                    hex: selectedHex,
                                    baseGallonPrice:
                                        double.tryParse(basePriceCtrl.text) ?? 4468,
                                    tintCostGallon:
                                        double.tryParse(tintPriceCtrl.text) ?? 250,
                                    formulaDesc: formulaCtrl.text.trim().isEmpty
                                        ? 'Pigment Paste'
                                        : formulaCtrl.text.trim(),
                                    formulaMl: double.tryParse(mlCtrl.text) ?? 18,
                                  );
                                  Navigator.pop(ctx);
                                },
                                child: Text(
                                  ctrl.currentLang == 'ur' ? 'اپڈیٹ شیڈ' : 'Update Shade',
                                  style: _txt(ctrl,
                                      size: 13,
                                      weight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
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
                                existingId: null,
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
                    if (existing != null) ...[
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                side: const BorderSide(color: Colors.redAccent),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                confirmDelete(
                                  context,
                                  ctrl,
                                  itemTitle: existing.getName(ctrl.currentLang),
                                  onConfirm: () {
                                    Navigator.pop(ctx);
                                    ctrl.deleteCustomer(existing.id);
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete_outline, size: 16),
                              label: Text(
                                ctrl.currentLang == 'ur' ? 'حذف' : 'Delete',
                                style: _txt(ctrl,
                                    size: 12,
                                    weight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF59E0B),
                                foregroundColor: const Color(0xFF0F172A),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                final nm = nameCtrl.text.trim();
                                final gv = double.tryParse(givenCtrl.text) ?? 0;
                                if (nm.isEmpty || gv <= 0) return;
                                ctrl.saveOrUpdateCustomer(
                                  existingId: existing.id,
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
                                ctrl.currentLang == 'ur' ? 'اپڈیٹ گاہک' : 'Update Customer',
                                style: _txt(ctrl,
                                    size: 13,
                                    weight: FontWeight.bold,
                                    color: const Color(0xFF0F172A)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
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
                              existingId: null,
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
                    if (existing != null) ...[
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                side: const BorderSide(color: Colors.redAccent),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                confirmDelete(
                                  context,
                                  ctrl,
                                  itemTitle: existing.getCompany(ctrl.currentLang),
                                  onConfirm: () {
                                    Navigator.pop(ctx);
                                    ctrl.deleteSupplier(existing.id);
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete_outline, size: 16),
                              label: Text(
                                ctrl.currentLang == 'ur' ? 'حذف' : 'Delete',
                                style: _txt(ctrl,
                                    size: 12,
                                    weight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ctrl.palette.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                final nm = compCtrl.text.trim();
                                final tb = double.tryParse(totalCtrl.text) ?? 0;
                                if (nm.isEmpty || tb <= 0) return;
                                ctrl.saveOrUpdateSupplier(
                                  existingId: existing.id,
                                  company: nm,
                                  lastSupply: supCtrl.text.trim().isEmpty
                                      ? "Gobi's Paint Stock"
                                      : supCtrl.text.trim(),
                                  totalBill: tb,
                                  paidBill: double.tryParse(paidCtrl.text) ?? 0,
                                );
                                Navigator.pop(ctx);
                              },
                              child: Text(
                                ctrl.currentLang == 'ur' ? 'اپڈیٹ سپلائر' : 'Update Supplier',
                                style: _txt(ctrl,
                                    size: 13,
                                    weight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
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
                              existingId: null,
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
                      if (existing != null) ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                  side: const BorderSide(color: Colors.redAccent),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  confirmDelete(
                                    context,
                                    ctrl,
                                    itemTitle: existing.getDesc(ctrl.currentLang),
                                    onConfirm: () {
                                      Navigator.pop(ctx);
                                      ctrl.deleteCashEntry(existing.id);
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete_outline, size: 16),
                                label: Text(
                                  ctrl.currentLang == 'ur' ? 'حذف' : 'Delete',
                                  style: _txt(ctrl,
                                      size: 12,
                                      weight: FontWeight.bold,
                                      color: Colors.redAccent),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: type == 'expense'
                                      ? Colors.redAccent
                                      : const Color(0xFF059669),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () {
                                  final amt = double.tryParse(amtCtrl.text) ?? 0;
                                  if (amt <= 0) return;
                                  ctrl.saveOrUpdateCashEntry(
                                    existingId: existing.id,
                                    type: type,
                                    category: cat,
                                    note: noteCtrl.text.trim().isEmpty
                                        ? cat
                                        : noteCtrl.text.trim(),
                                    amount: amt,
                                  );
                                  Navigator.pop(ctx);
                                },
                                child: Text(
                                  ctrl.currentLang == 'ur' ? 'اپڈیٹ اندراج' : 'Update Entry',
                                  style: _txt(ctrl,
                                      size: 13,
                                      weight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
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
                                existingId: null,
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
                    if (existing != null) ...[
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.redAccent,
                                side: const BorderSide(color: Colors.redAccent),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                confirmDelete(
                                  context,
                                  ctrl,
                                  itemTitle: existing.getName(ctrl.currentLang),
                                  onConfirm: () {
                                    Navigator.pop(ctx);
                                    ctrl.deletePainter(existing.id);
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete_outline, size: 16),
                              label: Text(
                                ctrl.currentLang == 'ur' ? 'حذف' : 'Delete',
                                style: _txt(ctrl,
                                    size: 12,
                                    weight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ctrl.palette.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                final nm = nameCtrl.text.trim();
                                if (nm.isEmpty) return;
                                ctrl.saveOrUpdatePainter(
                                  existingId: existing.id,
                                  name: nm,
                                  phone: phoneCtrl.text.trim(),
                                  specialty: specCtrl.text.trim(),
                                  unpaidCommission:
                                      double.tryParse(commCtrl.text) ?? 0,
                                  tokensRedeemed: int.tryParse(tokCtrl.text) ?? 0,
                                  referredSales:
                                      double.tryParse(salesCtrl.text) ?? 0,
                                );
                                Navigator.pop(ctx);
                              },
                              child: Text(
                                ctrl.currentLang == 'ur' ? 'اپڈیٹ پینٹر' : 'Update Painter',
                                style: _txt(ctrl,
                                    size: 13,
                                    weight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
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
                              existingId: null,
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
    String? hint,
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
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
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

  // ===========================================================================
  // 15. WHATSAPP BILL & REMINDER SHARING HELPER
  // ===========================================================================
  static Future<void> shareViaWhatsApp(
    BuildContext context,
    ErpController ctrl, {
    String? phone,
    String? message,
    String? text,
  }) async {
    final body = message ?? text ?? '';
    final encodedMsg = Uri.encodeComponent(body);

    // Always copy bill text to clipboard immediately
    await Clipboard.setData(ClipboardData(text: body));

    // To prevent the "The phone number isn't on WhatsApp" error and allow sharing
    // with ANY contact, group, or customer, open WhatsApp directly with the text.
    // WhatsApp will open its native contact chooser screen.
    final List<String> urlsToTry = [
      'whatsapp://send?text=$encodedMsg',
      'https://api.whatsapp.com/send?text=$encodedMsg',
    ];

    bool launched = false;
    for (final u in urlsToTry) {
      try {
        final uri = Uri.parse(u);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          launched = true;
          break;
        }
      } catch (_) {}
    }

    if (!launched) {
      try {
        final directUri = Uri.parse('whatsapp://send?text=$encodedMsg');
        await launchUrl(directUri, mode: LaunchMode.externalApplication);
        launched = true;
      } catch (_) {}
    }

    ctrl.showToast(ctrl.currentLang == 'ur'
        ? 'بل کاپی ہو گیا! واٹس ایپ میں کسی کو بھی شیئر کریں'
        : 'Bill copied! Share to any contact on WhatsApp');
  }

  // ===========================================================================
  // 16. INVOICE POPUP / THERMAL BILL DIALOG (ON CHECKOUT & HISTORY)
  // ===========================================================================
  static void openInvoiceDialog(BuildContext context, ErpController ctrl, InvoiceRecord inv) {
    final isDark = ctrl.isDarkMode;
    final cardBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

    // Build plain text invoice for clipboard / WhatsApp
    final buffer = StringBuffer();
    buffer.writeln('================================');
    buffer.writeln(ctrl.shopName);
    buffer.writeln('بابر اینڈ برادرز ہارڈویئر اینڈ پینٹ سٹور');
    buffer.writeln('فون: ${ctrl.shopPhone}');
    buffer.writeln('================================');
    buffer.writeln('بل نمبر / Invoice: ${inv.invoiceNo}');
    buffer.writeln('تاریخ / Date: ${inv.dateStr}');
    buffer.writeln('گاہک / Customer: ${inv.customerName.isEmpty ? "Walk-in Customer" : inv.customerName}');
    if (inv.customerPhone.isNotEmpty) {
      buffer.writeln('رابطہ / Phone: ${inv.customerPhone}');
    }
    buffer.writeln('ادائیگی کی قسم / Mode: ${inv.mode}');
    buffer.writeln('--------------------------------');
    for (var i = 0; i < inv.items.length; i++) {
      final item = inv.items[i];
      buffer.writeln('${i + 1}. ${item.getName(ctrl.currentLang)}');
      buffer.writeln('   ${item.qty} x ${ctrl.formatMoney(item.price)} = ${ctrl.formatMoney(item.subtotal)}');
    }
    buffer.writeln('--------------------------------');
    buffer.writeln('ٹوٹل / Subtotal: ${ctrl.formatMoney(inv.subtotal)}');
    if (inv.discount > 0) {
      buffer.writeln('رعایت / Discount: ${ctrl.formatMoney(inv.discount)}');
    }
    buffer.writeln('خالص بل / Total: ${ctrl.formatMoney(inv.total)}');
    buffer.writeln('================================');
    buffer.writeln('تشریف آوری کا شکریہ! جزاک اللہ خیراً');

    final invoiceText = buffer.toString();

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420, maxHeight: 580),
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.receipt_long_rounded,
                            size: 22, color: Color(0xFF10B981)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ctrl.currentLang == 'ur' ? 'کامیاب بل جاری ہوا' : 'Invoice Generated',
                              style: _txt(ctrl, size: 14, weight: FontWeight.bold),
                            ),
                            Text(
                              inv.invoiceNo,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey, fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: ctrl.currentLang == 'ur' ? 'بل حذف کریں' : 'Delete Invoice',
                        onPressed: () {
                          confirmDelete(
                            context,
                            ctrl,
                            itemTitle: '${inv.invoiceNo} (${inv.customerName})',
                            onConfirm: () {
                              Navigator.pop(ctx);
                              ctrl.deleteInvoice(inv.id);
                            },
                          );
                        },
                        icon: const Icon(Icons.delete_outline_rounded,
                            size: 20, color: Colors.redAccent),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded, size: 20),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    ctrl.shopName,
                                    style: _txt(ctrl, size: 13, weight: FontWeight.w900),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'بابر اینڈ برادرز ہارڈویئر اینڈ پینٹ سٹور',
                                    style: _txt(ctrl, size: 11.5, weight: FontWeight.bold, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    ctrl.shopPhone,
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 14),
                            // Customer and Invoice metadata
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.person_rounded, size: 14, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              '${ctrl.currentLang == "ur" ? "گاہک" : "Cust"}: ${inv.customerName.isEmpty ? (ctrl.currentLang == "ur" ? "عام نقد گاہک" : "Walk-in Customer") : inv.customerName}',
                                              style: _txt(ctrl, size: 11.5, weight: FontWeight.bold),
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
                                            const Icon(Icons.phone_rounded, size: 12, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                inv.customerPhone,
                                                style: const TextStyle(fontSize: 10.5, color: Colors.grey),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today_rounded, size: 11, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              inv.dateStr,
                                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: (inv.mode == 'Cash'
                                            ? const Color(0xFF10B981)
                                            : const Color(0xFFF59E0B))
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: (inv.mode == 'Cash'
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFFF59E0B))
                                          .withValues(alpha: 0.35),
                                    ),
                                  ),
                                  child: Text(
                                    inv.mode == 'Cash'
                                        ? (ctrl.currentLang == 'ur' ? 'نقد بل' : 'Cash')
                                        : (ctrl.currentLang == 'ur' ? 'ادھار بل' : 'Credit / Udhar'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: inv.mode == 'Cash'
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFF59E0B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 14),

                            // Table Header Row
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF334155).withValues(alpha: 0.5) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      ctrl.currentLang == 'ur' ? 'تفصیل آئٹم و پیکنگ' : 'Item Description & Size',
                                      style: _txt(ctrl, size: 10, weight: FontWeight.bold, color: Colors.grey.shade600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    ctrl.currentLang == 'ur' ? 'تعداد × ریٹ = رقم' : 'Qty × Rate = Amount',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Items List: Full Name with Size & Pricing (No Ellipsis Truncation)
                            ...inv.items.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final it = entry.value;
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                                      width: 0.7,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Line 1: Full Item Name with Pack Size (untruncated)
                                    Text(
                                      '${idx + 1}. ${it.getName(ctrl.currentLang)}',
                                      style: _txt(ctrl, size: 12, weight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 3),
                                    // Line 2: Code badge (if any) + Qty x Price and Line Subtotal
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: AlignmentDirectional.centerStart,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (it.code.isNotEmpty)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                              margin: const EdgeInsets.only(right: 6),
                                              decoration: BoxDecoration(
                                                color: isDark ? Colors.white12 : Colors.grey.shade200,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                it.code,
                                                style: const TextStyle(
                                                  fontSize: 9.5,
                                                  fontFamily: 'monospace',
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          Text(
                                            '${it.qty} × ${ctrl.formatMoney(it.price)}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Text(
                                            '= ${ctrl.formatMoney(it.subtotal)}',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w900,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 6),

                            // Total Items count & Total quantity
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.02),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${ctrl.currentLang == "ur" ? "کل آئٹمز" : "Total Items"}: ${inv.items.length}',
                                      style: const TextStyle(fontSize: 10.5, color: Colors.grey, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      '${ctrl.currentLang == "ur" ? "کل تعداد" : "Total Qty"}: ${inv.items.fold<int>(0, (s, i) => s + i.qty)}',
                                      style: const TextStyle(fontSize: 10.5, color: Colors.grey, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 12),

                            // Subtotal (always shown)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ctrl.currentLang == 'ur' ? 'سب ٹوٹل' : 'Subtotal',
                                  style: _txt(ctrl, size: 11, color: Colors.grey),
                                ),
                                Text(
                                  ctrl.formatMoney(inv.subtotal),
                                  style: _txt(ctrl, size: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                            if (inv.discount > 0) ...[
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ctrl.currentLang == 'ur' ? 'رعایت / ڈسکاؤنٹ' : 'Discount',
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.redAccent),
                                  ),
                                  Text(
                                    '-${ctrl.formatMoney(inv.discount)}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ],
                            const Divider(height: 10),

                            // Net Grand Total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    ctrl.tr('lblCartGrand'),
                                    style: _txt(ctrl, size: 12.5, weight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  ctrl.formatMoney(inv.total),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? Colors.cyanAccent : ctrl.palette.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                ctrl.currentLang == 'ur'
                                    ? 'تشریف آوری کا شکریہ! جزاک اللہ خیراً'
                                    : 'Thank you for shopping with Babur & Brothers!',
                                style: const TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // 1. WhatsApp PDF Share Button
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            InvoicePdfService.shareInvoicePdf(context, ctrl, inv);
                          },
                          icon: const Icon(Icons.picture_as_pdf_rounded, size: 15),
                          label: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              ctrl.currentLang == 'ur' ? 'واٹس ایپ PDF' : 'WhatsApp PDF',
                              style: _txt(ctrl, size: 11, weight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // 2. Direct Print Button (Native System Print Dialog)
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            InvoicePdfService.printInvoice(context, ctrl, inv);
                          },
                          icon: const Icon(Icons.print_rounded, size: 15),
                          label: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              ctrl.currentLang == 'ur' ? 'پرنٹ' : 'Print',
                              style: _txt(ctrl, size: 11, weight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),

                      // 3. Copy Text Button
                      IconButton(
                        tooltip: ctrl.currentLang == 'ur' ? 'ٹیکسٹ کاپی کریں' : 'Copy Text',
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                          ),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: invoiceText));
                          ctrl.showToast(ctrl.currentLang == 'ur' ? 'بل کاپی ہو گیا' : 'Copied');
                        },
                        icon: const Icon(Icons.copy_rounded, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  // ===========================================================================
  // 17. INVOICE HISTORY MODAL
  // ===========================================================================
  static void openInvoicesHistoryModal(BuildContext context, ErpController ctrl) {
    final isDark = ctrl.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ListenableBuilder(
        listenable: ctrl,
        builder: (ctx, _) => Directionality(
          textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Container(
            height: MediaQuery.of(ctx).size.height * 0.78,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ctrl.palette.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.history_rounded, size: 22, color: ctrl.palette.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        ctrl.currentLang == 'ur' ? 'حالیہ انوائسز اور بلز' : 'Recent Invoices',
                        style: _txt(ctrl, size: 14, weight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      tooltip: ctrl.currentLang == 'ur' ? 'مکمل صفحہ کھولیں' : 'Open Full Page',
                      icon: const Icon(Icons.open_in_new_rounded, size: 20),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => AllInvoicesScreen(controller: ctrl),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ],
                ),
                const Divider(height: 16),
                if (ctrl.invoicesHistory.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        ctrl.currentLang == 'ur' ? 'ابھی کوئی بل موجود نہیں' : 'No invoices generated yet',
                        style: _txt(ctrl, size: 12, color: Colors.grey),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: ctrl.invoicesHistory.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (ctx, idx) {
                        final inv = ctrl.invoicesHistory[idx];
                        final isCash = inv.mode == 'Cash';
                        return Card(
                          elevation: 0,
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            leading: CircleAvatar(
                              backgroundColor: (isCash ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                                  .withValues(alpha: 0.15),
                              child: Icon(
                                isCash ? Icons.attach_money_rounded : Icons.pending_actions_rounded,
                                color: isCash ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                size: 18,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  inv.invoiceNo,
                                  style: const TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (isCash ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    inv.mode,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                      color: isCash ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              '${inv.customerName.isEmpty ? "Walk-in" : inv.customerName} • ${inv.dateStr}',
                              style: const TextStyle(fontSize: 10.5, color: Colors.grey),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      ctrl.formatMoney(inv.total),
                                      style: _txt(ctrl, size: 12, weight: FontWeight.w900),
                                    ),
                                    Text(
                                      '${inv.items.length} items',
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    confirmDelete(
                                      context,
                                      ctrl,
                                      itemTitle: '${inv.invoiceNo} (${inv.customerName})',
                                      onConfirm: () => ctrl.deleteInvoice(inv.id),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 16,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              openInvoiceDialog(context, ctrl, inv);
                            },
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 18. BARCODE SCANNER MODAL (FOR INSTANT POS BILLING)
  // ===========================================================================
  static Color _parseHexColor(String hex) {
    final clean = hex.replaceAll('#', '').trim();
    if (clean.length == 6) {
      return Color(int.tryParse('FF$clean', radix: 16) ?? 0xFF93C5FD);
    }
    return const Color(0xFF93C5FD);
  }

  static bool get _supportsLiveCamera {
    final isTestBinding =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (isTestBinding) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  static Future<String?> _scanSingleBarcode(
      BuildContext context, ErpController ctrl) async {
    if (!_supportsLiveCamera) {
      ctrl.showToast('Camera scanning works on Android/iOS devices');
      return null;
    }
    final scannerCtrl = MobileScannerController();
    bool handled = false;
    final result = await showDialog<String>(
      context: context,
      builder: (dlgCtx) => AlertDialog(
        title: Text(ctrl.tr('barcodeScannerTitle'),
            style: _txt(ctrl, size: 14, weight: FontWeight.bold)),
        content: SizedBox(
          width: 300,
          height: 240,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: MobileScanner(
              controller: scannerCtrl,
              onDetect: (capture) {
                if (handled) return;
                for (final b in capture.barcodes) {
                  final raw = b.rawValue?.trim() ?? '';
                  if (raw.isNotEmpty) {
                    handled = true;
                    Navigator.pop(dlgCtx, raw);
                    break;
                  }
                }
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlgCtx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    scannerCtrl.dispose();
    return result;
  }

  static void openBarcodeScannerModal(BuildContext context, ErpController ctrl,
      {bool isStockIn = false}) {
    final barcodeCtrl = TextEditingController();
    final costCtrl = TextEditingController(text: '3800');
    final priceCtrl = TextEditingController(text: '4500');
    final scannerCtrl = _supportsLiveCamera ? MobileScannerController() : null;

    bool stockInMode = isStockIn;
    bool useCamera = _supportsLiveCamera;
    bool torchOn = false;
    int stockInQty = 1;
    PaintProduct? lastScanned;
    int scanCount = 0;
    String? unknownBarcode;
    String lastDetectedCode = '';
    DateTime lastDetectedAt = DateTime.fromMillisecondsSinceEpoch(0);

    // Unknown barcode linking state
    bool linkExistingMode = false;
    int? selectedExistingId =
        ctrl.inventory.isNotEmpty ? ctrl.inventory.first.id : null;
    String selectedSeries = GobisShadeCards.seriesList.first;
    String selectedCategory =
        GobisShadeCards.categoriesForSeries(selectedSeries).first;
    List<ShadeCardEntry> availableShades =
        GobisShadeCards.shadesFor(selectedSeries, selectedCategory);
    ShadeCardEntry? selectedShade =
        availableShades.isNotEmpty ? availableShades.first : null;
    String selectedSize = '3.64L (Gallon)';
    const sizeOptions = [
      '0.91L (Quarter)',
      '3.64L (Gallon)',
      '14.56L (Drum)',
      '1 Litre',
      '4 Litre',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final isDark = ctrl.isDarkMode;
          final cardBg =
              isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

          void handleScan(String raw) {
            final code = raw.trim();
            if (code.isEmpty) return;

            if (stockInMode) {
              final updated = ctrl.scanStockIn(code, qty: stockInQty);
              if (updated != null) {
                setModalState(() {
                  lastScanned = updated;
                  unknownBarcode = null;
                  scanCount += stockInQty;
                  barcodeCtrl.clear();
                });
              } else {
                setModalState(() {
                  lastScanned = null;
                  unknownBarcode = code;
                  barcodeCtrl.clear();
                });
                ctrl.showToast(ctrl.currentLang == 'ur'
                    ? 'نیا بارکوڈ! نیچے کیٹیگری اور شیڈ منتخب کریں'
                    : 'New barcode! Select Category & Shade below to link');
              }
            } else {
              final product = ctrl.findProductByBarcode(code);
              if (product != null) {
                ctrl.addToPosCart(product);
                setModalState(() {
                  lastScanned = product;
                  unknownBarcode = null;
                  scanCount++;
                  barcodeCtrl.clear();
                });
              } else {
                setModalState(() {
                  lastScanned = null;
                });
                ctrl.showToast(ctrl.tr('barcodeNotFound'));
              }
            }
          }

          return Directionality(
            textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(ctx).size.height * 0.86,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.qr_code_scanner_rounded,
                              size: 22, color: Color(0xFFF59E0B)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stockInMode
                                    ? (ctrl.currentLang == 'ur'
                                        ? 'سٹاک ان بارکوڈ اسکینر'
                                        : 'Stock-In Barcode Scanner')
                                    : ctrl.tr('barcodeScannerTitle'),
                                style: _txt(ctrl,
                                    size: 14, weight: FontWeight.bold),
                              ),
                              Text(
                                stockInMode
                                    ? (ctrl.currentLang == 'ur'
                                        ? 'کین اسکین کریں، خودکار کیٹیگری اور رنگ میں سٹاک جمع ہوگا'
                                        : 'Scan cans to add stock by Series, Category & Shade')
                                    : (ctrl.currentLang == 'ur'
                                        ? 'کیمرہ یا بارکوڈ گن سے اسکین کریں'
                                        : 'Scan with camera, barcode gun, or type code'),
                                style: _txt(ctrl,
                                    size: 10.5, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        if (scanCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0xFF10B981)),
                            ),
                            child: Text(
                              stockInMode
                                  ? '+$scanCount Stock'
                                  : (ctrl.currentLang == 'ur'
                                      ? '$scanCount آئٹم شامل'
                                      : '$scanCount scanned'),
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Mode Switcher: POS Billing vs Stock-In
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isDark ? Colors.white12 : Colors.black12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() {
                                stockInMode = false;
                                unknownBarcode = null;
                              }),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: !stockInMode
                                      ? ctrl.palette.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Text(
                                  ctrl.currentLang == 'ur'
                                      ? 'POS بلنگ'
                                      : 'POS Billing',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: !stockInMode
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() {
                                stockInMode = true;
                              }),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: stockInMode
                                      ? const Color(0xFF10B981)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Text(
                                  ctrl.currentLang == 'ur'
                                      ? 'سٹاک ان (Stock-In)'
                                      : 'Stock-In (Add Qty)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: stockInMode
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Scrollable content body
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Live Camera or Laser Box
                            if (useCamera && scannerCtrl != null)
                              Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: stockInMode
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFFF59E0B),
                                      width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: [
                                      MobileScanner(
                                        controller: scannerCtrl,
                                        onDetect: (capture) {
                                          for (final b in capture.barcodes) {
                                            final raw =
                                                b.rawValue?.trim() ?? '';
                                            if (raw.isEmpty) continue;
                                            final now = DateTime.now();
                                            if (raw == lastDetectedCode &&
                                                now
                                                        .difference(
                                                            lastDetectedAt)
                                                        .inMilliseconds <
                                                    1400) {
                                              continue;
                                            }
                                            lastDetectedCode = raw;
                                            lastDetectedAt = now;
                                            handleScan(raw);
                                            break;
                                          }
                                        },
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.black54,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Icon(
                                                  torchOn
                                                      ? Icons.flash_on_rounded
                                                      : Icons.flash_off_rounded,
                                                  color: Colors.amber,
                                                  size: 18,
                                                ),
                                                onPressed: () {
                                                  scannerCtrl.toggleTorch();
                                                  setModalState(() =>
                                                      torchOn = !torchOn);
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.black54,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(
                                                  Icons.keyboard_rounded,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                                onPressed: () => setModalState(
                                                    () => useCamera = false),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: double.infinity,
                                          color: Colors.black54,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Text(
                                            stockInMode
                                                ? 'Point camera at paint can barcode (+$stockInQty)'
                                                : 'Point camera at barcode to add to POS bill',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF090D16),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: const Color(0xFF334155)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.barcode_reader,
                                            color: Color(0xFFF59E0B), size: 24),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '||| | | |||| || | || ||| || |||',
                                              style: TextStyle(
                                                fontFamily: 'monospace',
                                                fontSize: 15,
                                                letterSpacing: 2,
                                                color: Colors.white
                                                    .withValues(alpha: 0.85),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (scannerCtrl != null) ...[
                                          const SizedBox(width: 8),
                                          TextButton.icon(
                                            onPressed: () => setModalState(
                                                () => useCamera = true),
                                            icon: const Icon(
                                                Icons.camera_alt_rounded,
                                                size: 16,
                                                color: Colors.amberAccent),
                                            label: const Text('Camera',
                                                style: TextStyle(
                                                    color: Colors.amberAccent,
                                                    fontSize: 11)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      ctrl.currentLang == 'ur'
                                          ? 'اسکینر تیار ہے — بارکوڈ گن یا ٹائپ سے اسکین کریں'
                                          : 'Scanner Ready — Use USB barcode gun or type below',
                                      style: const TextStyle(
                                          fontSize: 10.5,
                                          color: Colors.amberAccent),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 10),

                            // Stock-In Qty Stepper
                            if (stockInMode) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0xFF10B981)
                                          .withValues(alpha: 0.3)),
                                ),
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          ctrl.currentLang == 'ur'
                                              ? 'تعداد:'
                                              : 'Qty:',
                                          style: _txt(ctrl,
                                              size: 11.5,
                                              weight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                              minWidth: 32, minHeight: 32),
                                          onPressed: stockInQty > 1
                                              ? () => setModalState(
                                                  () => stockInQty--)
                                              : null,
                                          icon: const Icon(
                                              Icons.remove_circle_outline,
                                              size: 20),
                                        ),
                                        Text('$stockInQty',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        IconButton(
                                          visualDensity: VisualDensity.compact,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                              minWidth: 32, minHeight: 32),
                                          onPressed: () =>
                                              setModalState(() => stockInQty++),
                                          icon: const Icon(
                                              Icons.add_circle_outline,
                                              size: 20),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        for (final q in const [1, 4, 8, 12])
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: InkWell(
                                              onTap: () => setModalState(
                                                  () => stockInQty = q),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: stockInQty == q
                                                      ? const Color(0xFF10B981)
                                                      : cardBg,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: Colors.grey
                                                          .withValues(
                                                              alpha: 0.3)),
                                                ),
                                                child: Text(
                                                  'x$q',
                                                  style: TextStyle(
                                                    fontSize: 10.5,
                                                    fontWeight: FontWeight.bold,
                                                    color: stockInQty == q
                                                        ? Colors.white
                                                        : (isDark
                                                            ? Colors.white70
                                                            : Colors.black87),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],

                            // Manual / Gun input field
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: barcodeCtrl,
                                    autofocus: !useCamera,
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: handleScan,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: cardBg,
                                      prefixIcon: const Icon(
                                          Icons.search_rounded,
                                          size: 20),
                                      hintText: ctrl.tr('barcodeSearchPh'),
                                      hintStyle: const TextStyle(
                                          fontSize: 11.5, color: Colors.grey),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: isDark
                                                ? Colors.white24
                                                : Colors.black26),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 20),
                                        onPressed: () =>
                                            handleScan(barcodeCtrl.text),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Quick-Test Barcode Chips
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                _testBarcodeChip(ctrl, 'GLD-IE-G',
                                    () => handleScan('GLD-IE-G')),
                                _testBarcodeChip(ctrl, '896400010001',
                                    () => handleScan('896400010001')),
                                _testBarcodeChip(ctrl, 'CR-RED-G',
                                    () => handleScan('CR-RED-G')),
                                _testBarcodeChip(ctrl, 'BB-2K-W-G',
                                    () => handleScan('BB-2K-W-G')),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Unknown Barcode -> Link to Series / Category / Shade Card Colour
                            if (stockInMode && unknownBarcode != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF59E0B)
                                      .withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: const Color(0xFFF59E0B)
                                          .withValues(alpha: 0.5)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.new_releases_rounded,
                                            color: Color(0xFFF59E0B),
                                            size: 18),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'New Barcode: $unknownBarcode',
                                            style: _txt(ctrl,
                                                size: 12.5,
                                                weight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => setModalState(() =>
                                              linkExistingMode =
                                                  !linkExistingMode),
                                          child: Text(
                                            linkExistingMode
                                                ? 'Create New Shade'
                                                : 'Link Existing',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    if (linkExistingMode &&
                                        ctrl.inventory.isNotEmpty) ...[
                                      DropdownButtonFormField<int>(
                                        initialValue: selectedExistingId,
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          labelText: 'Select Existing Product',
                                          filled: true,
                                          fillColor: cardBg,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 8),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        items: ctrl.inventory
                                            .map((p) => DropdownMenuItem<int>(
                                                  value: p.id,
                                                  child: Text(
                                                    '${p.getName(ctrl.currentLang)} (${p.getSize(ctrl.currentLang)})',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (v) => setModalState(
                                            () => selectedExistingId = v),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF10B981),
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: selectedExistingId == null
                                            ? null
                                            : () {
                                                final linked = ctrl
                                                    .linkBarcodeAndAddStock(
                                                  barcode: unknownBarcode!,
                                                  existingProductId:
                                                      selectedExistingId,
                                                  qty: stockInQty,
                                                );
                                                setModalState(() {
                                                  lastScanned = linked;
                                                  unknownBarcode = null;
                                                  scanCount += stockInQty;
                                                });
                                              },
                                        icon: const Icon(Icons.link_rounded,
                                            size: 18),
                                        label: Text(
                                            'Link Barcode & +$stockInQty Stock'),
                                      ),
                                    ] else ...[
                                      // Series + Category
                                      Row(
                                        children: [
                                          Expanded(
                                            child:
                                                DropdownButtonFormField<String>(
                                              initialValue: selectedSeries,
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                labelText: 'Series',
                                                filled: true,
                                                fillColor: cardBg,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                              items: GobisShadeCards.seriesList
                                                  .map((s) => DropdownMenuItem(
                                                      value: s,
                                                      child: Text(s,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      12))))
                                                  .toList(),
                                              onChanged: (v) {
                                                if (v == null) return;
                                                setModalState(() {
                                                  selectedSeries = v;
                                                  final cats = GobisShadeCards
                                                      .categoriesForSeries(v);
                                                  selectedCategory = cats.first;
                                                  availableShades =
                                                      GobisShadeCards.shadesFor(
                                                          selectedSeries,
                                                          selectedCategory);
                                                  selectedShade =
                                                      availableShades.isNotEmpty
                                                          ? availableShades
                                                              .first
                                                          : null;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            flex: 2,
                                            child:
                                                DropdownButtonFormField<String>(
                                              initialValue: selectedCategory,
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                labelText: 'Category',
                                                filled: true,
                                                fillColor: cardBg,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                              items: GobisShadeCards
                                                  .categoriesForSeries(
                                                      selectedSeries)
                                                  .map((c) => DropdownMenuItem(
                                                      value: c,
                                                      child: Text(c,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      12))))
                                                  .toList(),
                                              onChanged: (v) {
                                                if (v == null) return;
                                                setModalState(() {
                                                  selectedCategory = v;
                                                  availableShades =
                                                      GobisShadeCards.shadesFor(
                                                          selectedSeries,
                                                          selectedCategory);
                                                  selectedShade =
                                                      availableShades.isNotEmpty
                                                          ? availableShades
                                                              .first
                                                          : null;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      // Shade Card Colour Selector
                                      DropdownButtonFormField<ShadeCardEntry>(
                                        initialValue: selectedShade,
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          labelText:
                                              'Shade Card Colour & Number',
                                          filled: true,
                                          fillColor: cardBg,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 8),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        items: availableShades
                                            .map((sh) => DropdownMenuItem(
                                                  value: sh,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _parseHexColor(
                                                              sh.colorHex),
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          sh.displayLabel,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (v) => setModalState(
                                            () => selectedShade = v),
                                      ),
                                      const SizedBox(height: 8),

                                      // Size chips
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: sizeOptions
                                            .map((sz) => ChoiceChip(
                                                  label: Text(sz,
                                                      style: const TextStyle(
                                                          fontSize: 10.5)),
                                                  selected: selectedSize == sz,
                                                  onSelected: (_) =>
                                                      setModalState(() =>
                                                          selectedSize = sz),
                                                ))
                                            .toList(),
                                      ),
                                      const SizedBox(height: 8),

                                      // Cost & Sale Price
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _inputField(
                                                ctrl, costCtrl, 'Cost Price',
                                                isNumber: true),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: _inputField(
                                                ctrl, priceCtrl, 'Sale Price',
                                                isNumber: true),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF10B981),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                        onPressed: () {
                                          final catCode = GobisShadeCards
                                              .catCodeForCategory(
                                                  selectedCategory);
                                          final created =
                                              ctrl.linkBarcodeAndAddStock(
                                            barcode: unknownBarcode!,
                                            brand: 'Gobis',
                                            series: selectedSeries,
                                            cat: catCode,
                                            categoryLabel: selectedCategory,
                                            shadeCode:
                                                selectedShade?.shadeCode ?? '',
                                            shadeName:
                                                selectedShade?.shadeName ?? '',
                                            colorHex:
                                                selectedShade?.colorHex ??
                                                    '#93C5FD',
                                            sizeLabel: selectedSize,
                                            costPrice: double.tryParse(
                                                    costCtrl.text) ??
                                                0,
                                            salePrice: double.tryParse(
                                                    priceCtrl.text) ??
                                                0,
                                            qty: stockInQty,
                                          );
                                          setModalState(() {
                                            lastScanned = created;
                                            unknownBarcode = null;
                                            scanCount += stockInQty;
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.save_alt_rounded,
                                            size: 18),
                                        label: Text(
                                            'Save Shade & +$stockInQty Stock'),
                                      ),
                                    ],
                                  ],
                                ),
                              )
                            else if (lastScanned != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFF10B981)
                                          .withValues(alpha: 0.4)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: _parseHexColor(
                                            lastScanned!.colorHex),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: const Color(0xFF10B981),
                                            width: 2),
                                      ),
                                      child: const Icon(
                                          Icons.check_circle_rounded,
                                          color: Color(0xFF10B981),
                                          size: 24),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            lastScanned!
                                                .getName(ctrl.currentLang),
                                            style: _txt(ctrl,
                                                size: 12,
                                                weight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${lastScanned!.series} • ${lastScanned!.cat}'
                                            '${lastScanned!.shadeCode.isNotEmpty ? " • #${lastScanned!.shadeCode} ${lastScanned!.shadeName}" : ""}'
                                            ' • ${lastScanned!.getSize(ctrl.currentLang)}',
                                            style: const TextStyle(
                                                fontSize: 10.5,
                                                color: Colors.grey),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            stockInMode
                                                ? 'Updated Stock: ${lastScanned!.stock} units'
                                                : '${ctrl.formatMoney(lastScanned!.salePrice)} (Cart: ${ctrl.posCart.where((x) => x.prodId == lastScanned!.id).fold<int>(0, (s, it) => s + it.qty)})',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF10B981),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.barcode_reader,
                                          size: 38,
                                          color: Colors.grey
                                              .withValues(alpha: 0.4)),
                                      const SizedBox(height: 8),
                                      Text(
                                        stockInMode
                                            ? (ctrl.currentLang == 'ur'
                                                ? 'پینٹ کین کا بارکوڈ اسکین کریں — خودکار کیٹیگری اور شیڈ میں سٹاک جمع ہوگا'
                                                : 'Scan a paint can barcode — stock adds automatically by Category & Shade')
                                            : (ctrl.currentLang == 'ur'
                                                ? 'ڈبے کا بارکوڈ اسکین کریں، خودکار کارٹ میں شامل ہوگا'
                                                : 'Scan paint can barcode to add to cart automatically'),
                                        style: _txt(ctrl,
                                            size: 11, color: Colors.grey),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Bottom actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: stockInMode
                                  ? const Color(0xFF10B981)
                                  : ctrl.palette.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.pop(ctx);
                              if (!stockInMode) {
                                openPosCartModal(context, ctrl);
                              }
                            },
                            icon: Icon(
                                stockInMode
                                    ? Icons.check_rounded
                                    : Icons.shopping_cart_checkout_rounded,
                                size: 18),
                            label: Text(
                              stockInMode
                                  ? (ctrl.currentLang == 'ur'
                                      ? 'مکمل ($scanCount شامل)'
                                      : 'Done Stock-In ($scanCount Added)')
                                  : '${ctrl.tr('btnPosCart')} (${ctrl.posCart.length}) - ${ctrl.formatMoney(ctrl.cartTotal)}',
                              style: _txt(ctrl,
                                  size: 12,
                                  weight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).whenComplete(() {
      scannerCtrl?.dispose();
    });
  }

  static Widget _testBarcodeChip(ErpController ctrl, String code, VoidCallback onTap) {
    return ActionChip(
      avatar: const Icon(Icons.barcode_reader, size: 14),
      label: Text(code, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  // ===========================================================================
  // 19. BARCODE LABEL / STICKER PRINT PREVIEW DIALOG
  // ===========================================================================
  static void openBarcodeLabelDialog(BuildContext context, ErpController ctrl, PaintProduct item) {
    final isDark = ctrl.isDarkMode;
    final barcodeValue = item.barcode.isNotEmpty ? item.barcode : item.code;

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.label_important_outline_rounded,
                          size: 22, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ctrl.tr('barcodeLabelTitle'),
                          style: _txt(ctrl, size: 14, weight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded, size: 20),
                      ),
                    ],
                  ),
                  const Divider(height: 16),

                  // Sticker Canvas Preview
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black26),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'BABUR & BROTHERS HARDWARE & PAINT',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.getName(ctrl.currentLang),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        Text(
                          '${item.series} • ${item.getSize(ctrl.currentLang)}',
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),

                        // Barcode Bars Simulation - Wrapped in FittedBox to eliminate right overflow
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '||||| |||| || |||| ||||| |||| |||||',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 20,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              barcodeValue,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'MRP: ${ctrl.formatMoney(item.salePrice)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: barcodeValue));
                            ctrl.showToast(ctrl.currentLang == 'ur'
                                ? 'بارکوڈ کاپی ہو گیا'
                                : 'Barcode copied');
                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.copy_rounded, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  ctrl.currentLang == 'ur' ? 'کاپی کوڈ' : 'Copy Code',
                                  style: _txt(ctrl, size: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ctrl.palette.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            ctrl.showToast(ctrl.currentLang == 'ur'
                                ? 'اسٹیکر پرنٹ کمانڈ بھیج دی گئی'
                                : 'Label sent to thermal sticker printer');
                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.print_rounded, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  ctrl.tr('barcodePrintBtn'),
                                  style: _txt(ctrl, size: 11, weight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
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
      ),
    );
  }

  // ===========================================================================
  // 20. CHANGE PASSWORD DIALOG
  // ===========================================================================
  static void openChangePasswordDialog(
    BuildContext context,
    ErpController ctrl, {
    String initialUsername = '',
    void Function(String newPassword)? onSuccess,
    void Function(String newUsername, String newPassword)? onCredentialsUpdated,
  }) {
    final userCtrl = TextEditingController(
      text: initialUsername.isNotEmpty
          ? initialUsername
          : (ctrl.currentUser?.username ?? 'admin'),
    );
    final newUserCtrl = TextEditingController();
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final isDark = ctrl.isDarkMode;
          final isUrdu = ctrl.currentLang == 'ur';
          final cardBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
          final borderCol = isDark ? Colors.white24 : Colors.grey.shade300;

          Widget buildField({
            required TextEditingController controller,
            required String label,
            required IconData icon,
            bool isPassword = false,
            bool obscure = false,
            VoidCallback? onToggleObscure,
          }) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: _txt(ctrl, size: 11, weight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: controller,
                  obscureText: isPassword && obscure,
                  style: TextStyle(fontSize: 12.5, color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardBg,
                    prefixIcon: Icon(icon, size: 18, color: ctrl.palette.primary),
                    suffixIcon: isPassword
                        ? IconButton(
                            icon: Icon(
                              obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                              size: 18,
                              color: Colors.grey,
                            ),
                            onPressed: onToggleObscure,
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderCol),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderCol),
                    ),
                  ),
                ),
              ],
            );
          }

          return Directionality(
            textDirection: ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: ctrl.palette.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.lock_reset_rounded, size: 22, color: ctrl.palette.primary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isUrdu ? 'یوزر نیم / پاس ورڈ تبدیل کریں' : 'Change Username / Password',
                      style: _txt(ctrl, size: 13.5, weight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildField(
                        controller: userCtrl,
                        label: isUrdu ? 'موجودہ یوزر نیم (Current Username)' : 'Current Username',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 10),
                      buildField(
                        controller: oldPassCtrl,
                        label: isUrdu ? 'موجودہ پاس ورڈ (Current Password)' : 'Current Password',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        obscure: obscureOld,
                        onToggleObscure: () => setDialogState(() => obscureOld = !obscureOld),
                      ),
                      const SizedBox(height: 10),
                      buildField(
                        controller: newUserCtrl,
                        label: isUrdu ? 'نیا یوزر نیم (اختیاری - New Username)' : 'New Username (Optional)',
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 10),
                      buildField(
                        controller: newPassCtrl,
                        label: isUrdu ? 'نیا پاس ورڈ (اختیاری - New Password)' : 'New Password (Optional)',
                        icon: Icons.key_rounded,
                        isPassword: true,
                        obscure: obscureNew,
                        onToggleObscure: () => setDialogState(() => obscureNew = !obscureNew),
                      ),
                      const SizedBox(height: 10),
                      buildField(
                        controller: confirmPassCtrl,
                        label: isUrdu ? 'نئے پاس ورڈ کی تصدیق (Confirm)' : 'Confirm New Password',
                        icon: Icons.check_circle_outline_rounded,
                        isPassword: true,
                        obscure: obscureConfirm,
                        onToggleObscure: () => setDialogState(() => obscureConfirm = !obscureConfirm),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(isUrdu ? 'منسوخ (Cancel)' : 'Cancel', style: _txt(ctrl, size: 12)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ctrl.palette.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final typedNewPass = newPassCtrl.text.trim();
                    final typedConfirm = confirmPassCtrl.text.trim();
                    final typedNewUser = newUserCtrl.text.trim();

                    if (typedNewPass.isNotEmpty && typedNewPass != typedConfirm) {
                      ctrl.showToast(isUrdu
                          ? 'نیا پاس ورڈ اور تصدیقی پاس ورڈ ایک جیسے نہیں ہیں!'
                          : 'New passwords do not match!');
                      return;
                    }
                    final ok = await ctrl.changePassword(
                      username: userCtrl.text.trim(),
                      currentPassword: oldPassCtrl.text.trim(),
                      newPassword: typedNewPass,
                      newUsername: typedNewUser,
                    );
                    if (ok && ctx.mounted) {
                      final finalUser = typedNewUser.isNotEmpty ? typedNewUser : userCtrl.text.trim();
                      final finalPass = typedNewPass.isNotEmpty ? typedNewPass : oldPassCtrl.text.trim();
                      onSuccess?.call(finalPass);
                      onCredentialsUpdated?.call(finalUser, finalPass);
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(
                    isUrdu ? 'اپ ڈیٹ کریں (Update)' : 'Update',
                    style: _txt(ctrl, size: 12, weight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
