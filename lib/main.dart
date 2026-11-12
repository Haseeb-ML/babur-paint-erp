import 'package:flutter/material.dart';
import 'state/erp_controller.dart';
import 'ui/modals/erp_modals.dart';
import 'ui/views/auth_screen.dart';
import 'ui/views/erp_views.dart';
import 'ui/views/invoices_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = ErpController();
  await controller.init();
  runApp(BaburBrothersPaintApp(controller: controller));
  // Online sync runs in background; app works fully offline if it fails.
  controller.connectCloud();
}

class BaburBrothersPaintApp extends StatefulWidget {
  final ErpController controller;
  const BaburBrothersPaintApp({super.key, required this.controller});

  @override
  State<BaburBrothersPaintApp> createState() => _BaburBrothersPaintAppState();
}

class _BaburBrothersPaintAppState extends State<BaburBrothersPaintApp> {
  final TextEditingController _posSearchCtrl = TextEditingController();
  final bool _useMobileFrameOnDesktop = true;

  @override
  void dispose() {
    _posSearchCtrl.dispose();
    super.dispose();
  }

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
      height: ctrl.isRtl ? 1.55 : 1.3,
      fontFamilyFallback: const [
        'Inter',
        'Segoe UI',
        'Roboto',
        'sans-serif'
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final ctrl = widget.controller;
        final isDark = ctrl.isDarkMode;

        return MaterialApp(
          title: 'Babur & Brothers Paint ERP',
          debugShowCheckedModeBanner: false,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: ctrl.palette.primary,
            scaffoldBackgroundColor: const Color(0xFFF1F5F9),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: ctrl.palette.primary,
            scaffoldBackgroundColor: const Color(0xFF0F172A),
          ),
          home: !ctrl.isAuthenticated
              ? AuthScreen(controller: ctrl)
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isWideScreen = constraints.maxWidth > 540;
                    final appBody = Directionality(
                      textDirection:
                          ctrl.isRtl ? TextDirection.rtl : TextDirection.ltr,
                      child: Scaffold(
                        backgroundColor: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF1F5F9),
                        body: SafeArea(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  // 2. Enterprise Application Header + 3 KPI Strip
                                  _buildEnterpriseHeader(context, ctrl),
                                  // 3. Scrollable Main Views Container
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 12, 12, 20),
                                      child:
                                          _buildActiveTabContent(context, ctrl),
                                    ),
                                  ),
                                  // 4. Bottom Navigation Bar
                                  _buildBottomNavBar(ctrl),
                                ],
                              ),
                              // Toast Notification Banner
                              if (ctrl.toastMessage != null)
                                Positioned(
                                  top: 52,
                                  left: 18,
                                  right: 18,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? ctrl.palette.primary
                                            : const Color(0xFF0F172A),
                                        borderRadius:
                                            BorderRadius.circular(16),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: 14,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              ctrl.toastMessage!,
                                              style: _txt(ctrl,
                                                  size: 12,
                                                  weight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const Text(
                                            '✓',
                                            style: TextStyle(
                                              color: Color(0xFFFBBF24),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );

                    if (!isWideScreen || !_useMobileFrameOnDesktop) {
                      return appBody;
                    }

                    // Desktop / Browser Mobile Frame Wrapper (Matches client's HTML test design)
                    return Scaffold(
                      backgroundColor: const Color(0xFF0B1120),
                      body: Center(
                        child: Container(
                          width: 405,
                          height: constraints.maxHeight.clamp(500.0, 860.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1.2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black87,
                                blurRadius: 45,
                                offset: Offset(0, 20),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: appBody,
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildEnterpriseHeader(BuildContext context, ErpController ctrl) {
    final isDark = ctrl.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF020617), const Color(0xFF0F172A)]
              : [ctrl.palette.headerStart, ctrl.palette.headerEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : Colors.white24,
          ),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 11),
      child: Column(
        children: [
          // Top Brand Row + Action Buttons
          Row(
            children: [
              // Babur & Brothers Logo (Click to Edit Shop Info)
              InkWell(
                onTap: () => ErpModals.openEditShopModal(context, ctrl),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.format_paint_rounded,
                      color: Color(0xFFFBBF24),
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: InkWell(
                  onTap: () => ErpModals.openEditShopModal(context, ctrl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ctrl.shopProfile.getName(ctrl.currentLang),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _txt(
                                ctrl,
                                size: 13.5,
                                weight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Icon(Icons.edit_outlined, size: 12, color: Colors.amberAccent),
                        ],
                      ),
                      Text(
                        ctrl.shopProfile.getSub(ctrl.currentLang),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _txt(
                          ctrl,
                          size: 10.5,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Action Buttons: Cart, Theme/Light-Dark, Language
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Cart Button
                  InkWell(
                    onTap: () => ErpModals.openPosCartModal(context, ctrl),
                    borderRadius: BorderRadius.circular(11),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_cart_outlined,
                              size: 15, color: Color(0xFFFCD34D)),
                          const SizedBox(width: 3),
                          Text(
                            '${ctrl.cartItemCount}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFCD34D),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  // 2. Theme Palette & Light/Dark Button
                  InkWell(
                    onTap: () => ErpModals.openThemeAndSettingsModal(context, ctrl),
                    borderRadius: BorderRadius.circular(11),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(
                        Icons.palette_outlined,
                        size: 16,
                        color: Color(0xFFFCD34D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  // 3. Language Cycle Button (Urdu -> Roman -> EN)
                  InkWell(
                    onTap: () => ctrl.cycleLanguage(),
                    borderRadius: BorderRadius.circular(11),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        ctrl.tr('langBadgeNext'),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  // 4. Logout / User Profile Button
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Row(
                            children: [
                              const Icon(Icons.logout_rounded,
                                  color: Colors.redAccent, size: 22),
                              const SizedBox(width: 8),
                              Text(ctrl.currentLang == 'ur'
                                  ? 'لاگ آؤٹ تصدیق'
                                  : 'Sign Out Confirmation'),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${ctrl.currentLang == 'ur' ? 'موجودہ صارف:' : 'Active User:'} ${ctrl.currentUser?.name ?? "Admin"} (${ctrl.currentUser?.role ?? "Admin"})',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(ctrl.currentLang == 'ur'
                                  ? 'کیا آپ واقعی لاگ آؤٹ کر کے لاگ ان اسکرین پر جانا چاہتے ہیں؟'
                                  : 'Are you sure you want to sign out and return to the login screen?'),
                            ],
                          ),
                          actions: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(ctx);
                                ErpModals.openChangePasswordDialog(
                                  context,
                                  ctrl,
                                  initialUsername: ctrl.currentUser?.username ?? 'admin',
                                );
                              },
                              icon: const Icon(Icons.lock_reset_rounded, size: 16),
                              label: Text(ctrl.currentLang == 'ur'
                                  ? 'پاس ورڈ تبدیل کریں'
                                  : 'Change Password'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text(ctrl.currentLang == 'ur'
                                  ? 'منسوخ (Cancel)'
                                  : 'Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                ctrl.logout();
                              },
                              child: Text(ctrl.currentLang == 'ur'
                                  ? 'لاگ آؤٹ (Sign Out)'
                                  : 'Sign Out'),
                            ),
                          ],
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(11),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                            color: Colors.redAccent.withValues(alpha: 0.4)),
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),

          // User info badge bar
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  '👤 ${ctrl.currentUser?.name ?? "Admin"} • ${ctrl.currentUser?.role ?? "Owner"}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFDE68A),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Gobi\'s Dealer',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),

          // 3-Column KPI Strip inside Header
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.85)
                  : ctrl.palette.kpiBg.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _headerKpiBox(
                    ctrl,
                    label: ctrl.tr('kpiSales'),
                    value: ctrl.formatMoney(ctrl.totalSales),
                    labelCol: Colors.blue[100]!,
                    valCol: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => AllInvoicesScreen(controller: ctrl),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _headerKpiBox(
                    ctrl,
                    label: ctrl.tr('kpiProfit'),
                    value: ctrl.formatMoney(ctrl.netProfit),
                    labelCol: const Color(0xFFA7F3D0),
                    valCol: const Color(0xFF6EE7B7),
                    onTap: () {
                      ctrl.setKhataSubTab('cash');
                      ctrl.switchTab('khata');
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _headerKpiBox(
                    ctrl,
                    label: ctrl.tr('kpiUdhar'),
                    value: ctrl.formatMoney(ctrl.totalUdharPending),
                    labelCol: const Color(0xFFFDE68A),
                    valCol: const Color(0xFFFCD34D),
                    onTap: () {
                      ctrl.setKhataSubTab('cust');
                      ctrl.switchTab('khata');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerKpiBox(
    ErpController ctrl, {
    required String label,
    required String value,
    required Color labelCol,
    required Color valCol,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _txt(ctrl, size: 10.5, color: labelCol),
            ),
            const SizedBox(height: 1),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: valCol,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(BuildContext context, ErpController ctrl) {
    switch (ctrl.currentTab) {
      case 'pos':
        return ErpViews.buildPosView(context, ctrl, _posSearchCtrl);
      case 'tinting':
        return ErpViews.buildTintingView(context, ctrl);
      case 'inventory':
        return ErpViews.buildInventoryView(context, ctrl);
      case 'khata':
        return ErpViews.buildKhataView(context, ctrl);
      case 'painters':
        return ErpViews.buildPaintersView(context, ctrl);
      case 'dashboard':
      default:
        return ErpViews.buildDashboardView(context, ctrl);
    }
  }

  Widget _buildBottomNavBar(ErpController ctrl) {
    final isDark = ctrl.isDarkMode;
    final items = [
      {'id': 'dashboard', 'icon': Icons.home_outlined, 'label': ctrl.tr('navDashboard')},
      {'id': 'pos', 'icon': Icons.calculate_outlined, 'label': ctrl.tr('navPos')},
      {'id': 'tinting', 'icon': Icons.palette_outlined, 'label': ctrl.tr('navTinting')},
      {'id': 'inventory', 'icon': Icons.inventory_2_outlined, 'label': ctrl.tr('navInventory')},
      {'id': 'khata', 'icon': Icons.menu_book_rounded, 'label': ctrl.tr('navKhata')},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF020617) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: items.map((it) {
              final id = it['id'] as String;
              final active = ctrl.currentTab == id ||
                  (ctrl.currentTab == 'painters' && id == 'dashboard');
              return Expanded(
                child: InkWell(
                  onTap: () => ctrl.switchTab(id),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                    decoration: BoxDecoration(
                      color: active
                          ? (isDark
                              ? const Color(0xFF1E293B)
                              : ctrl.palette.primary.withValues(alpha: 0.1))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          it['icon'] as IconData,
                          size: 18,
                          color: active
                              ? (isDark ? const Color(0xFFFCD34D) : ctrl.palette.primary)
                              : Colors.grey,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          it['label'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _txt(
                            ctrl,
                            size: 10,
                            weight: active ? FontWeight.bold : FontWeight.normal,
                            color: active
                                ? (isDark ? const Color(0xFFFCD34D) : ctrl.palette.primary)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          Container(
            width: 100,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
