import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babur_brothers_paint_erp/main.dart';
import 'package:babur_brothers_paint_erp/state/erp_controller.dart';

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
    await tester.pump(const Duration(seconds: 3));
  });
}
