import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babur_brothers_paint_erp/data/gobis_shade_cards.dart';
import 'package:babur_brothers_paint_erp/state/erp_controller.dart';
import 'package:babur_brothers_paint_erp/ui/modals/erp_modals.dart';

void main() {
  testWidgets('100% Barcode Module Test: Shade Cards, Stock-In, Link Existing, POS & Persistence',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(380, 820);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // 1. Verify ALL 12 Paint Series, Categories & Shades in GobisShadeCards
    expect(GobisShadeCards.seriesList.length, 12);
    for (final series in GobisShadeCards.seriesList) {
      final cats = GobisShadeCards.categoriesForSeries(series);
      expect(cats, isNotEmpty, reason: 'Series $series must have categories');
      for (final cat in cats) {
        final shades = GobisShadeCards.shadesFor(series, cat);
        expect(shades, isNotEmpty, reason: '$series -> $cat must have shades');
        expect(GobisShadeCards.catCodeForCategory(cat), isNotEmpty);
      }
    }

    final ctrl = ErpController();
    await ctrl.init();
    ctrl.setLanguage('en');

    // 2. Stock-In Mode UI: Scan unknown barcode -> Link with Custom Shade & x4 Qty
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
              child: const Text('Open Stock-In Scanner'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open Stock-In Scanner'));
    await tester.pumpAndSettle();

    expect(find.text('Stock-In Barcode Scanner'), findsOneWidget);

    // Select x4 qty chip
    await tester.tap(find.text('x4'));
    await tester.pumpAndSettle();

    // Scan unknown register barcode
    await tester.enterText(find.byType(TextField).first, '1916010600002');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('New Barcode: 1916010600002'), findsOneWidget);

    // Enter Custom Shade / Name
    await tester.enterText(
      find.widgetWithText(
          TextField, 'Custom Shade / Name (optional, overrides dropdown)'),
      'ClassMate Register',
    );
    await tester.ensureVisible(find.text('Save Shade & +4 Stock'));
    await tester.tap(find.text('Save Shade & +4 Stock'));
    await tester.pumpAndSettle();

    final reg = ctrl.findProductByBarcode('1916010600002');
    expect(reg, isNotNull);
    expect(reg!.stock, 4);
    expect(reg.shadeName, 'ClassMate Register');

    // Repeat scan with x8 -> stock becomes 12
    await tester.tap(find.text('x8'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '1916010600002');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(reg.stock, 12);

    // 3. Link Existing Product flow
    final existingProd = ctrl.inventory.last;
    final oldStock = existingProd.stock;
    final linked = ctrl.linkBarcodeAndAddStock(
      barcode: '777666555444',
      existingProductId: existingProd.id,
      qty: 2,
    );
    expect(linked.id, existingProd.id);
    expect(linked.barcode, '777666555444');
    expect(linked.stock, oldStock + 2);

    // 4. Switch to POS Billing Mode inside modal
    await tester.tap(find.text('POS Billing'));
    await tester.pumpAndSettle();

    // 4a. Scan unknown barcode in POS -> inline Link button appears
    await tester.enterText(find.byType(TextField).first, '555444333222');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('Barcode not linked in stock: 555444333222'), findsOneWidget);
    expect(find.text('Link This Barcode in Stock-In'), findsOneWidget);

    // 4b. Scan register with leading zero -> adds +1 to POS Cart!
    await tester.enterText(find.byType(TextField).first, '01916010600002');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(ctrl.posCart.any((c) => c.prodId == reg.id && c.qty == 1), true);

    // 4c. Scan GLD-IE-G case-insensitively -> adds to POS Cart!
    await tester.enterText(find.byType(TextField).first, 'gld-ie-g');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    final gld = ctrl.findProductByBarcode('GLD-IE-G');
    expect(gld, isNotNull);
    expect(ctrl.posCart.any((c) => c.prodId == gld!.id), true);

    // 4d. Out-of-stock guard in POS mode
    final zeroProd = ctrl.linkBarcodeAndAddStock(
      barcode: '000999888777',
      series: 'Carman NC',
      cat: 'NC2K',
      categoryLabel: 'Carman NC Auto Lacquer',
      shadeCode: 'CM-B01',
      shadeName: 'Jet Black',
      qty: 1,
    );
    zeroProd.stock = 0;
    await tester.enterText(find.byType(TextField).first, '000999888777');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.textContaining('Out of Stock:'), findsOneWidget);
    expect(ctrl.posCart.any((c) => c.prodId == zeroProd.id), false);

    // 5. Persistence round-trip (JSON export -> reload)
    final backupJson = ctrl.exportBackupJson();
    final ctrl2 = ErpController();
    expect(ctrl2.loadFromJsonString(backupJson, notify: false), true);
    final restoredReg = ctrl2.findProductByBarcode('1916010600002');
    expect(restoredReg, isNotNull);
    expect(restoredReg!.shadeName, 'ClassMate Register');
    expect(restoredReg.stock, 12);

    await tester.pump(const Duration(seconds: 3));
  });
}
