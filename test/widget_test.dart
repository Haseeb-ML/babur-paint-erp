import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babur_brothers_paint_erp/main.dart';
import 'package:babur_brothers_paint_erp/state/erp_controller.dart';
import 'package:babur_brothers_paint_erp/ui/modals/erp_modals.dart';

void main() {
  testWidgets('Full ERP Modules, 3 Languages, Themes & Zero Overflow Test',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(380, 820);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final ctrl = ErpController();
    await ctrl.init();
    ctrl.isAuthenticated = true;

    await tester.pumpWidget(BaburBrothersPaintApp(controller: ctrl));
    await tester.pump();

    // Verify Shop Name in Urdu
    expect(find.textContaining('بابر اینڈ برادرز'), findsOneWidget);

    // Switch through all 6 modules in Urdu (RTL) and ensure zero overflow exceptions
    for (final tab in ['dashboard', 'pos', 'tinting', 'inventory', 'khata', 'painters']) {
      ctrl.switchTab(tab);
      await tester.pump();
    }

    // Switch to Roman Urdu and test all 6 modules
    ctrl.cycleLanguage(); // -> 'ro'
    await tester.pump();
    expect(ctrl.currentLang, 'ro');
    for (final tab in ['dashboard', 'pos', 'tinting', 'inventory', 'khata', 'painters']) {
      ctrl.switchTab(tab);
      await tester.pump();
    }

    // Switch to English and test all 6 modules
    ctrl.cycleLanguage(); // -> 'en'
    await tester.pump();
    expect(ctrl.currentLang, 'en');
    for (final tab in ['dashboard', 'pos', 'tinting', 'inventory', 'khata', 'painters']) {
      ctrl.switchTab(tab);
      await tester.pump();
    }

    // Test CRUD operations (Add / Update / Delete)
    final initialCount = ctrl.inventory.length;
    ctrl.saveOrUpdateProduct(
      code: 'TEST-99',
      brand: 'Gobis',
      series: 'Decorative',
      cat: 'Emulsion',
      name: 'Test Gobis Emulsion',
      sizeLabel: 'Gallon',
      costPrice: 3000,
      salePrice: 3500,
      stock: 10,
      minStock: 3,
    );
    expect(ctrl.inventory.length, initialCount + 1);
    final addedId = ctrl.inventory.first.id;
    ctrl.deleteProduct(addedId);
    expect(ctrl.inventory.length, initialCount);

    // Wait for any toast timers to complete
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('Authentication: Register, Login, and Logout flow test',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final ctrl = ErpController();
    await ctrl.init();

    await tester.pumpWidget(BaburBrothersPaintApp(controller: ctrl));
    await tester.pump();

    // 1. Should be on Login Screen by default
    expect(ctrl.isAuthenticated, false);
    expect(find.textContaining('Sign In'), findsWidgets);

    // 2. Perform Login with default admin credentials
    final loginOk = await ctrl.login('admin', '123');
    expect(loginOk, true);
    expect(ctrl.isAuthenticated, true);
    expect(ctrl.currentUser?.role, 'Owner / Admin');
    await tester.pump();

    // 3. Register a new user
    final regOk = await ctrl.register(
      name: 'Asad Painter',
      username: 'asad',
      password: '321',
      role: 'Cashier / Salesman',
      phone: '03009998877',
    );
    expect(regOk, true);
    expect(ctrl.currentUser?.name, 'Asad Painter');

    // 4. Test Logout
    await ctrl.logout();
    expect(ctrl.isAuthenticated, false);
    expect(ctrl.currentUser, null);

    // 5. Test Change Password for registered user
    final changeOk = await ctrl.changePassword(
      username: 'asad',
      currentPassword: '321',
      newPassword: '999',
    );
    expect(changeOk, true);

    // 6. Verify old password fails
    final oldLoginOk = await ctrl.login('asad', '321');
    expect(oldLoginOk, false);

    // 7. Verify new password succeeds
    final newLoginOk = await ctrl.login('asad', '999');
    expect(newLoginOk, true);
    expect(ctrl.isAuthenticated, true);
    expect(ctrl.currentUser?.name, 'Asad Painter');

    await ctrl.logout();
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('Barcode Modals Zero-Overflow Test on Mobile Viewport',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final ctrl = ErpController();
    await ctrl.init();
    ctrl.isAuthenticated = true;

    await tester.pumpWidget(BaburBrothersPaintApp(controller: ctrl));
    await tester.pump();

    final BuildContext ctx = tester.element(find.byType(Scaffold).first);

    // 1. Open Barcode Scanner Modal
    ErpModals.openBarcodeScannerModal(ctx, ctrl);
    await tester.pumpAndSettle();

    // Verify no overflow in scanner modal
    expect(find.text('||| | | |||| || | || ||| || |||'), findsOneWidget);
    expect(find.textContaining(ctrl.tr('btnPosCart')), findsOneWidget);

    // Close scanner modal
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // 2. Open Barcode Label Dialog
    final sampleProduct = ctrl.inventory.first;
    ErpModals.openBarcodeLabelDialog(ctx, ctrl, sampleProduct);
    await tester.pumpAndSettle();

    // Verify barcode string inside label dialog
    expect(find.text('||||| |||| || |||| ||||| |||| |||||'), findsOneWidget);
    expect(find.text('BABUR & BROTHERS HARDWARE & PAINT'), findsOneWidget);

    // Close barcode label dialog
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
  });
}
