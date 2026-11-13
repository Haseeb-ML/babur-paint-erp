import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babur_brothers_paint_erp/data/gobis_shade_cards.dart';
import 'package:babur_brothers_paint_erp/main.dart';
import 'package:babur_brothers_paint_erp/services/invoice_pdf_service.dart';
import 'package:babur_brothers_paint_erp/state/erp_controller.dart';
import 'package:babur_brothers_paint_erp/ui/modals/erp_modals.dart';
import 'package:babur_brothers_paint_erp/ui/views/invoices_screen.dart';

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

    // 8. Test Change Username only (keeping password)
    final changeUserOk = await ctrl.changePassword(
      username: 'asad',
      currentPassword: '999',
      newUsername: 'asad_pro',
    );
    expect(changeUserOk, true);
    await ctrl.logout();
    expect(await ctrl.login('asad', '999'), false);
    expect(await ctrl.login('asad_pro', '999'), true);

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

    // 3. Test AllInvoicesScreen
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (c) => AllInvoicesScreen(controller: ctrl),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all invoices screen loaded cleanly
    expect(find.byType(AllInvoicesScreen), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);

    // Pop back to dashboard
    Navigator.pop(ctx);
    await tester.pumpAndSettle();

    // 4. Test Cash Ledger Bill matching and invoice opening
    final firstSaleEntry = ctrl.cashLedger.firstWhere((e) => e.type == 'income');
    final invoiceForEntry = ctrl.findInvoiceForCashEntry(firstSaleEntry);
    expect(invoiceForEntry, isNotNull);
    expect(invoiceForEntry!.invoiceNo, 'INV-1042');

    // Open invoice dialog via ErpModals
    ErpModals.openInvoiceDialog(ctx, ctrl, invoiceForEntry);
    await tester.pumpAndSettle();

    // Verify invoice dialog opened with thermal receipt and WhatsApp PDF button
    expect(find.textContaining('INV-1042'), findsAtLeastNWidgets(1));
    expect(find.byIcon(Icons.picture_as_pdf_rounded), findsAtLeastNWidgets(1));

    // Close invoice dialog
    await tester.tap(find.byIcon(Icons.close_rounded).first);
    await tester.pumpAndSettle();

    // 5. Test Invoice PDF Service generation (A4 & Thermal 80mm Roll)
    final pdfBytesA4 = await InvoicePdfService.generateInvoicePdf(ctrl, invoiceForEntry);
    expect(pdfBytesA4.isNotEmpty, true);
    expect(pdfBytesA4.lengthInBytes, greaterThan(500));

    final pdfBytesThermal = await InvoicePdfService.generateInvoicePdf(
      ctrl,
      invoiceForEntry,
      format: PdfPageFormat.roll80,
    );
    expect(pdfBytesThermal.isNotEmpty, true);
    expect(pdfBytesThermal.lengthInBytes, greaterThan(300));
  });

  testWidgets('Category & Shade-Wise Barcode Stock-In Flow Test',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(380, 820);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final ctrl = ErpController();
    await ctrl.init();
    ctrl.setLanguage('en');

    // 1. Verify official shade card catalog loaded
    final goldEmulsionShades = GobisShadeCards.shadesFor(
      'Gold',
      'Gold Luxurious Wall Emulsion',
    );
    expect(goldEmulsionShades.any((s) => s.shadeCode == '1400' && s.shadeName == 'White'), true);
    expect(GobisShadeCards.categoriesForSeries('Hercules'), contains('Hercules Emulsion'));

    // 2. Link new barcode to Gold Luxurious Wall Emulsion - 1400 White with 8 gallons
    final created = ctrl.linkBarcodeAndAddStock(
      barcode: '896400099887',
      series: 'Gold',
      cat: 'Emulsion',
      categoryLabel: 'Gold Luxurious Wall Emulsion',
      shadeCode: '1400',
      shadeName: 'White',
      colorHex: '#FFFFFF',
      sizeLabel: '3.64L (Gallon)',
      costPrice: 3900,
      salePrice: 4600,
      qty: 8,
    );
    expect(created.stock, 8);
    expect(created.shadeCode, '1400');
    expect(created.shadeName, 'White');

    // 3. Scan same barcode again (+4 units) -> stock becomes 12
    final updated = ctrl.scanStockIn('896400099887', qty: 4);
    expect(updated, isNotNull);
    expect(updated!.stock, 12);

    // 4. Open Stock-In Barcode Scanner Modal on mobile viewport & test unknown barcode linking
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => ErpModals.openBarcodeScannerModal(
                context,
                ctrl,
                isStockIn: true,
              ),
              child: const Text('Open Stock-In'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open Stock-In'));
    await tester.pumpAndSettle();

    expect(find.text('Stock-In Barcode Scanner'), findsOneWidget);
    expect(find.text('Done Stock-In (0 Added)'), findsOneWidget);

    // Enter unknown barcode and submit
    await tester.enterText(find.byType(TextField).first, '999888777666');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('New Barcode: 999888777666'), findsOneWidget);

    // Save shade & +1 stock
    await tester.ensureVisible(find.text('Save Shade & +1 Stock'));
    await tester.tap(find.text('Save Shade & +1 Stock'));
    await tester.pumpAndSettle();

    expect(ctrl.findProductByBarcode('999888777666'), isNotNull);
    expect(find.text('Done Stock-In (1 Added)'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
