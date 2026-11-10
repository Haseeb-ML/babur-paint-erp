import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/gobis_initial_data.dart';
import '../l10n/app_strings.dart';
import '../models/erp_models.dart';
import '../theme/app_themes.dart';

class ErpController extends ChangeNotifier {
  static const String _kStorageKey = 'babur_brothers_gobis_erp_v1';

  String currentLang = 'ur'; // 'ur', 'ro', 'en'
  bool isDarkMode = false;
  int paletteIndex = 0; // 0 = Royal Blue (HTML design), 1 = B&B Gold & Black, etc.
  String currentTab = 'dashboard'; // dashboard, pos, tinting, inventory, khata, painters
  String posSeriesFilter = 'ALL'; // ALL, Decorative, Carman NC, Silverline, Stoving, Timberline, Ancillaries
  String invCatFilter = 'ALL'; // ALL, LOW, Emulsion, Weather, Enamel, NC2K, Wood, StovingEpoxy, Hardware
  String khataSubTab = 'cust'; // cust, supp, cash
  String shadeSeriesFilter = 'ALL'; // ALL, WeatherGuard, Emulsion, Enamel, Custom

  int selectedShadeIndex = 1; // Default Off White 3716
  String selectedTintPack = 'Gallon'; // Quarter, Gallon, Drum

  ShopProfile shopProfile = GobisInitialData.defaultShopProfile;
  List<PaintProduct> inventory = [];
  List<CartItem> posCart = [];
  List<ShadeItem> shades = [];
  List<UdharCustomer> customers = [];
  List<SupplierAccount> suppliers = [];
  List<PainterAccount> painters = [];
  List<CashLedgerEntry> cashLedger = [];

  String? toastMessage;
  bool isSyncingOnline = false;
  String lastSyncedTime = 'Just Now';

  ErpThemePalette get palette => AppThemes.palettes[paletteIndex % AppThemes.palettes.length];
  bool get isRtl => currentLang == 'ur';

  String tr(String key) => AppStrings.tr(currentLang, key);

  String formatMoney(num amount) {
    final prefix = tr('currencyPrefix');
    final int rounded = amount.round();
    final String formatted = rounded.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$prefix$formatted';
  }

  Future<void> init() async {
    inventory = GobisInitialData.initialProducts;
    posCart = GobisInitialData.initialCart;
    shades = GobisInitialData.initialShades;
    customers = GobisInitialData.initialCustomers;
    suppliers = GobisInitialData.initialSuppliers;
    painters = GobisInitialData.initialPainters;
    cashLedger = GobisInitialData.initialCashLedger;

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kStorageKey);
      if (raw != null && raw.isNotEmpty) {
        loadFromJsonString(raw, notify: false);
      }
    } catch (_) {
      // Fallback to in-memory defaults if SharedPreferences fails
    }
    notifyListeners();
  }

  Future<void> saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kStorageKey, exportBackupJson());
    } catch (_) {}
  }

  String exportBackupJson() {
    final map = {
      'currentLang': currentLang,
      'isDarkMode': isDarkMode,
      'paletteIndex': paletteIndex,
      'shopProfile': shopProfile.toMap(),
      'inventory': inventory.map((e) => e.toMap()).toList(),
      'posCart': posCart.map((e) => e.toMap()).toList(),
      'shades': shades.map((e) => e.toMap()).toList(),
      'customers': customers.map((e) => e.toMap()).toList(),
      'suppliers': suppliers.map((e) => e.toMap()).toList(),
      'painters': painters.map((e) => e.toMap()).toList(),
      'cashLedger': cashLedger.map((e) => e.toMap()).toList(),
    };
    return jsonEncode(map);
  }

  bool loadFromJsonString(String raw, {bool notify = true}) {
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      currentLang = map['currentLang'] ?? currentLang;
      isDarkMode = map['isDarkMode'] ?? isDarkMode;
      paletteIndex = map['paletteIndex'] ?? paletteIndex;
      if (map['shopProfile'] != null) {
        shopProfile = ShopProfile.fromMap(Map<String, dynamic>.from(map['shopProfile']));
      }
      if (map['inventory'] != null) {
        inventory = (map['inventory'] as List)
            .map((e) => PaintProduct.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
      if (map['posCart'] != null) {
        posCart = (map['posCart'] as List)
            .map((e) => CartItem.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
      if (map['shades'] != null) {
        shades = (map['shades'] as List)
            .map((e) => ShadeItem.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
      if (map['customers'] != null) {
        customers = (map['customers'] as List)
            .map((e) => UdharCustomer.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
      if (map['suppliers'] != null) {
        suppliers = (map['suppliers'] as List)
            .map((e) => SupplierAccount.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
      if (map['painters'] != null) {
        painters = (map['painters'] as List)
            .map((e) => PainterAccount.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
      if (map['cashLedger'] != null) {
        cashLedger = (map['cashLedger'] as List)
            .map((e) => CashLedgerEntry.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
      if (notify) {
        saveState();
        notifyListeners();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> resetToDefaultGobisData() async {
    shopProfile = GobisInitialData.defaultShopProfile;
    inventory = GobisInitialData.initialProducts;
    posCart = GobisInitialData.initialCart;
    shades = GobisInitialData.initialShades;
    customers = GobisInitialData.initialCustomers;
    suppliers = GobisInitialData.initialSuppliers;
    painters = GobisInitialData.initialPainters;
    cashLedger = GobisInitialData.initialCashLedger;
    selectedShadeIndex = 1;
    await saveState();
    showToast(currentLang == 'ur'
        ? 'گوبیز پینٹس کا اصل ڈیٹا دوبارہ لوڈ ہو گیا!'
        : "Original Gobi's Paints catalog restored!");
    notifyListeners();
  }

  void showToast(String msg) {
    toastMessage = msg;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (toastMessage == msg) {
        toastMessage = null;
        notifyListeners();
      }
    });
  }

  void refresh() {
    notifyListeners();
  }

  // =========================================================================
  // LANGUAGE & THEME CONTROLS
  // =========================================================================
  void cycleLanguage() {
    if (currentLang == 'ur') {
      currentLang = 'ro';
    } else if (currentLang == 'ro') {
      currentLang = 'en';
    } else {
      currentLang = 'ur';
    }
    saveState();
    notifyListeners();
  }

  void setLanguage(String lang) {
    currentLang = lang;
    saveState();
    notifyListeners();
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    saveState();
    notifyListeners();
  }

  void setPaletteIndex(int idx) {
    paletteIndex = idx;
    saveState();
    notifyListeners();
  }

  void switchTab(String tab) {
    currentTab = tab;
    notifyListeners();
  }

  void setPosSeriesFilter(String series) {
    posSeriesFilter = series;
    notifyListeners();
  }

  void setInvCatFilter(String cat) {
    invCatFilter = cat;
    notifyListeners();
  }

  void setKhataSubTab(String sub) {
    khataSubTab = sub;
    notifyListeners();
  }

  void setShadeSeriesFilter(String series) {
    shadeSeriesFilter = series;
    notifyListeners();
  }

  void updateShopProfile(ShopProfile updated) {
    shopProfile = updated;
    saveState();
    showToast(tr('savedToast'));
    notifyListeners();
  }

  Future<void> triggerCloudSync() async {
    isSyncingOnline = true;
    notifyListeners();
    await saveState();
    await Future.delayed(const Duration(milliseconds: 700));
    isSyncingOnline = false;
    final now = TimeOfDay.now();
    lastSyncedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    showToast(currentLang == 'ur'
        ? 'آن لائن کلاؤڈ اور آف لائن بیک اپ مکمل ہو گیا!'
        : 'Online Cloud & Offline Local Backup Synced!');
    notifyListeners();
  }

  // =========================================================================
  // LIVE KPI COMPUTATIONS
  // =========================================================================
  double get totalSales {
    double s = 0;
    for (final e in cashLedger) {
      if (e.type == 'income') s += e.amount;
    }
    return s;
  }

  double get totalExpenses {
    double ex = 0;
    for (final e in cashLedger) {
      if (e.type != 'income') ex += e.amount;
    }
    return ex;
  }

  double get netProfit {
    double gross = 0;
    for (final e in cashLedger) {
      if (e.type == 'income') {
        gross += (e.profit > 0 ? e.profit : (e.amount * 0.14));
      }
    }
    return gross - totalExpenses;
  }

  double get totalUdharPending {
    double u = 0;
    for (final c in customers) {
      u += c.remaining;
    }
    return u;
  }

  double get totalSupplierPayable {
    double p = 0;
    for (final s in suppliers) {
      p += s.remaining;
    }
    return p;
  }

  double get inventoryWorth {
    double w = 0;
    for (final i in inventory) {
      w += i.stock * i.salePrice;
    }
    return w;
  }

  int get totalStockUnits {
    int u = 0;
    for (final i in inventory) {
      u += i.stock;
    }
    return u;
  }

  List<PaintProduct> get lowStockItems =>
      inventory.where((i) => i.stock <= i.minStock).toList();

  int get cartItemCount => posCart.fold(0, (acc, item) => acc + item.qty);

  double get cartTotal =>
      posCart.fold(0.0, (acc, item) => acc + (item.price * item.qty));

  // =========================================================================
  // POS & CART CRUD
  // =========================================================================
  void addToPosCart(PaintProduct item) {
    if (item.stock <= 0) {
      showToast(currentLang == 'ur'
          ? 'یہ آئٹم سٹاک میں ختم ہے!'
          : 'Item is out of stock!');
      return;
    }
    final existingIdx = posCart.indexWhere((c) => c.prodId == item.id);
    if (existingIdx >= 0) {
      posCart[existingIdx].qty += 1;
    } else {
      posCart.add(CartItem(
        prodId: item.id,
        code: item.code,
        nameUr: '${item.nameUr} (${item.sizeUr})',
        nameRo: '${item.nameRo} (${item.sizeRo})',
        nameEn: '${item.nameEn} (${item.sizeEn})',
        price: item.salePrice,
        cost: item.costPrice,
        qty: 1,
      ));
    }
    saveState();
    showToast(currentLang == 'ur'
        ? 'آئٹم بل میں شامل ہو گیا!'
        : (currentLang == 'ro'
            ? 'Item bill mein shamil ho gaya!'
            : 'Added to POS Bill!'));
    notifyListeners();
  }

  void changeCartQty(int index, int delta) {
    if (index < 0 || index >= posCart.length) return;
    posCart[index].qty += delta;
    if (posCart[index].qty <= 0) {
      posCart.removeAt(index);
    }
    saveState();
    notifyListeners();
  }

  void removeCartItem(int index) {
    if (index < 0 || index >= posCart.length) return;
    posCart.removeAt(index);
    saveState();
    notifyListeners();
  }

  void updateCartItemPrice(int index, double newPrice, int newQty) {
    if (index < 0 || index >= posCart.length) return;
    posCart[index].price = newPrice;
    posCart[index].qty = newQty > 0 ? newQty : 1;
    saveState();
    notifyListeners();
  }

  void completePosCheckout({
    required String mode, // 'Cash' or 'Udhar'
    required String customerName,
    required String customerPhone,
    required int? painterId,
    required double discount,
  }) {
    if (posCart.isEmpty) {
      showToast(tr('cartEmpty'));
      return;
    }
    double subtotal = 0;
    double totalProfit = 0;
    for (final c in posCart) {
      subtotal += c.price * c.qty;
      final unitCost = c.cost > 0 ? c.cost : (c.price * 0.85);
      totalProfit += (c.price - unitCost) * c.qty;
      final invIdx = inventory.indexWhere((p) => p.id == c.prodId);
      if (invIdx >= 0 && inventory[invIdx].stock >= c.qty) {
        inventory[invIdx].stock -= c.qty;
      }
    }
    final double finalBill = (subtotal - discount) > 0 ? (subtotal - discount) : 0;
    totalProfit = (totalProfit - discount) > 0 ? (totalProfit - discount) : 0;

    final String cName = customerName.trim().isEmpty ? tr('walkInCust') : customerName.trim();

    if (painterId != null && painterId > 0) {
      final pIdx = painters.indexWhere((p) => p.id == painterId);
      if (pIdx >= 0) {
        final comm = (finalBill * 0.05).roundToDouble();
        painters[pIdx].referredSales += finalBill;
        painters[pIdx].unpaidCommission += comm;
      }
    }

    final itemsDescUr = posCart.map((i) => '${i.nameUr} ×${i.qty}').join(' + ');
    final itemsDescRo = posCart.map((i) => '${i.nameRo} ×${i.qty}').join(' + ');
    final itemsDescEn = posCart.map((i) => '${i.nameEn} ×${i.qty}').join(' + ');

    if (mode == 'Cash') {
      cashLedger.insert(
        0,
        CashLedgerEntry(
          id: DateTime.now().millisecondsSinceEpoch,
          type: 'income',
          catUr: 'پوائنٹ آف سیل نقد بل',
          catRo: 'POS Naqad Bill',
          catEn: 'POS Counter Cash Sale',
          descUr: '$cName - $itemsDescUr',
          descRo: '$cName - $itemsDescRo',
          descEn: '$cName - $itemsDescEn',
          amount: finalBill,
          profit: totalProfit,
          dateUr: 'ابھی',
          dateRo: 'Abhi',
          dateEn: 'Just Now',
        ),
      );
      showToast(currentLang == 'ur'
          ? 'نقد بل مکمل! رقم آمدن میں جمع ہو گئی۔'
          : 'Cash Invoice Completed!');
    } else {
      customers.insert(
        0,
        UdharCustomer(
          id: DateTime.now().millisecondsSinceEpoch,
          nameUr: cName,
          nameRo: cName,
          nameEn: cName,
          phone: customerPhone.trim().isEmpty ? '0300-0000000' : customerPhone.trim(),
          workUr: itemsDescUr,
          workRo: itemsDescRo,
          workEn: itemsDescEn,
          totalGiven: finalBill,
          totalPaid: 0,
          history: [
            UdharHistoryEntry(
              id: DateTime.now().millisecondsSinceEpoch + 1,
              type: 'given',
              amount: finalBill,
              descUr: 'پوائنٹ آف سیل ادھار بل ($itemsDescUr)',
              descRo: 'POS Udhaar Bill ($itemsDescRo)',
              descEn: 'POS Credit Invoice ($itemsDescEn)',
              dateStr: 'Today',
            ),
          ],
        ),
      );
      showToast(currentLang == 'ur'
          ? 'بل گاہک کے ادھار کھاتے میں درج ہو گیا!'
          : 'Invoice posted to Customer Credit!');
    }

    posCart.clear();
    saveState();
    notifyListeners();
  }

  // =========================================================================
  // SHADE CARD & COLOR MIXING STUDIO CRUD
  // =========================================================================
  ShadeItem get selectedShade {
    if (shades.isEmpty) return GobisInitialData.initialShades.first;
    if (selectedShadeIndex < 0 || selectedShadeIndex >= shades.length) {
      selectedShadeIndex = 0;
    }
    return shades[selectedShadeIndex];
  }

  double get tintSizeMultiplier {
    if (selectedTintPack == 'Quarter') return 0.28;
    if (selectedTintPack == 'Drum') return 3.92;
    return 1.0;
  }

  void setTintPackSize(String size) {
    selectedTintPack = size;
    notifyListeners();
  }

  void selectShadeById(int id) {
    final idx = shades.indexWhere((s) => s.id == id);
    if (idx >= 0) {
      selectedShadeIndex = idx;
      notifyListeners();
    }
  }

  void dispenseAndAddToPos() {
    final shade = selectedShade;
    final mult = tintSizeMultiplier;
    final totalPrice = ((shade.baseGallonPrice + shade.tintCostGallon) * mult).roundToDouble();
    final costPrice = (totalPrice * 0.82).roundToDouble();
    final packUr = selectedTintPack == 'Quarter'
        ? 'کوارٹر'
        : (selectedTintPack == 'Drum' ? 'ڈرم' : 'گیلن');

    posCart.add(CartItem(
      prodId: shade.id + 10000,
      code: shade.code,
      nameUr: 'گوبیز شیڈ ${shade.code} - ${shade.nameUr} ($packUr)',
      nameRo: 'Gobis Shade ${shade.code} - ${shade.nameRo} ($selectedTintPack)',
      nameEn: "Gobi's Shade ${shade.code} - ${shade.nameEn} ($selectedTintPack)",
      price: totalPrice,
      cost: costPrice,
      qty: 1,
    ));
    saveState();
    showToast(currentLang == 'ur'
        ? 'شیڈ ${shade.code} مکس ہو کر بل میں شامل ہو گیا!'
        : 'Shade ${shade.code} mixed & added to POS Bill!');
    notifyListeners();
  }

  void saveOrUpdateShade({
    int? existingId,
    required String code,
    required String series,
    required String name,
    required String hex,
    required double baseGallonPrice,
    required double tintCostGallon,
    required String formulaDesc,
    required double formulaMl,
  }) {
    final baseUr = series == 'WeatherGuard'
        ? 'بیس: گوبیز ہرکولیس ویدر گارڈ'
        : (series == 'Emulsion'
            ? 'بیس: گوبیز ہرکولیس انٹیریئر ایملشن'
            : 'بیس: گوبیز ہرکولیس ہائی گلاس انیمل');
    final baseEn = series == 'WeatherGuard'
        ? 'Base: Gobis Hercules Weather Guard'
        : (series == 'Emulsion'
            ? 'Base: Gobis Hercules Interior Emulsion'
            : 'Base: Gobis Hercules High Gloss Enamel');

    final pigments = [
      PigmentShot(
        nameUr: formulaDesc,
        nameRo: formulaDesc,
        nameEn: formulaDesc,
        ml: formulaMl,
        colorHex: hex,
      ),
    ];

    if (existingId != null) {
      final idx = shades.indexWhere((s) => s.id == existingId);
      if (idx >= 0) {
        shades[idx] = ShadeItem(
          id: existingId,
          code: code,
          series: series,
          nameUr: name,
          nameRo: name,
          nameEn: name,
          baseUr: baseUr,
          baseRo: baseEn,
          baseEn: baseEn,
          hex: hex,
          baseGallonPrice: baseGallonPrice,
          tintCostGallon: tintCostGallon,
          pigments: pigments,
        );
        selectedShadeIndex = idx;
      }
    } else {
      final newShade = ShadeItem(
        id: DateTime.now().millisecondsSinceEpoch,
        code: code.trim().isEmpty ? 'CS-${100 + shades.length}' : code.trim(),
        series: series,
        nameUr: name,
        nameRo: name,
        nameEn: name,
        baseUr: baseUr,
        baseRo: baseEn,
        baseEn: baseEn,
        hex: hex,
        baseGallonPrice: baseGallonPrice,
        tintCostGallon: tintCostGallon,
        pigments: pigments,
      );
      shades.insert(0, newShade);
      selectedShadeIndex = 0;
    }
    saveState();
    showToast(tr('savedToast'));
    notifyListeners();
  }

  void deleteShade(int id) {
    shades.removeWhere((s) => s.id == id);
    if (selectedShadeIndex >= shades.length) {
      selectedShadeIndex = shades.isEmpty ? 0 : shades.length - 1;
    }
    saveState();
    showToast(tr('deletedToast'));
    notifyListeners();
  }

  // =========================================================================
  // INVENTORY & PRODUCT CRUD
  // =========================================================================
  void quickRestockItem(int id) {
    final idx = inventory.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    inventory[idx].stock += 5;
    saveState();
    showToast(currentLang == 'ur'
        ? '5 نئے یونٹ گودام میں جمع ہو گئے!'
        : 'Added +5 stock units!');
    notifyListeners();
  }

  void saveOrUpdateProduct({
    int? existingId,
    required String code,
    required String brand,
    required String series,
    required String cat,
    required String name,
    required String sizeLabel,
    required double costPrice,
    required double salePrice,
    required int stock,
    required int minStock,
    String colorHex = '#93C5FD',
  }) {
    if (existingId != null) {
      final idx = inventory.indexWhere((p) => p.id == existingId);
      if (idx >= 0) {
        final old = inventory[idx];
        inventory[idx] = PaintProduct(
          id: existingId,
          code: code,
          brand: brand,
          series: series,
          cat: cat,
          nameUr: name,
          nameRo: name,
          nameEn: name,
          sizeUr: sizeLabel,
          sizeRo: sizeLabel,
          sizeEn: sizeLabel,
          costPrice: costPrice,
          retailPrice: costPrice,
          gstAmount: old.gstAmount,
          salePrice: salePrice,
          stock: stock,
          minStock: minStock,
          colorHex: colorHex,
        );
      }
    } else {
      inventory.insert(
        0,
        PaintProduct(
          id: DateTime.now().millisecondsSinceEpoch,
          code: code.isEmpty ? 'GB-${inventory.length + 1}' : code,
          brand: brand,
          series: series,
          cat: cat,
          nameUr: name,
          nameRo: name,
          nameEn: name,
          sizeUr: sizeLabel,
          sizeRo: sizeLabel,
          sizeEn: sizeLabel,
          costPrice: costPrice,
          retailPrice: costPrice,
          gstAmount: 0,
          salePrice: salePrice,
          stock: stock,
          minStock: minStock,
          colorHex: colorHex,
        ),
      );
    }
    saveState();
    showToast(tr('savedToast'));
    notifyListeners();
  }

  void deleteProduct(int id) {
    inventory.removeWhere((p) => p.id == id);
    posCart.removeWhere((c) => c.prodId == id);
    saveState();
    showToast(tr('deletedToast'));
    notifyListeners();
  }

  // =========================================================================
  // CUSTOMER KHATA (UDHAAR) & HISTORY CRUD
  // =========================================================================
  void saveOrUpdateCustomer({
    int? existingId,
    required String name,
    required String phone,
    required String work,
    required double totalGiven,
    required double totalPaid,
  }) {
    if (existingId != null) {
      final idx = customers.indexWhere((c) => c.id == existingId);
      if (idx >= 0) {
        customers[idx].nameUr = name;
        customers[idx].nameRo = name;
        customers[idx].nameEn = name;
        customers[idx].phone = phone;
        customers[idx].workUr = work;
        customers[idx].workRo = work;
        customers[idx].workEn = work;
        customers[idx].totalGiven = totalGiven;
        customers[idx].totalPaid = totalPaid;
      }
    } else {
      customers.insert(
        0,
        UdharCustomer(
          id: DateTime.now().millisecondsSinceEpoch,
          nameUr: name,
          nameRo: name,
          nameEn: name,
          phone: phone.isEmpty ? '0300-1112233' : phone,
          workUr: work,
          workRo: work,
          workEn: work,
          totalGiven: totalGiven,
          totalPaid: totalPaid,
          history: [
            UdharHistoryEntry(
              id: DateTime.now().millisecondsSinceEpoch + 1,
              type: 'given',
              amount: totalGiven,
              descUr: work,
              descRo: work,
              descEn: work,
              dateStr: 'Today',
            ),
            if (totalPaid > 0)
              UdharHistoryEntry(
                id: DateTime.now().millisecondsSinceEpoch + 2,
                type: 'paid',
                amount: totalPaid,
                descUr: 'ابتدائی وصولی',
                descRo: 'Ibtidai Wasooli',
                descEn: 'Initial Payment',
                dateStr: 'Today',
              ),
          ],
        ),
      );
    }
    saveState();
    showToast(tr('savedToast'));
    notifyListeners();
  }

  void deleteCustomer(int id) {
    customers.removeWhere((c) => c.id == id);
    saveState();
    showToast(tr('deletedToast'));
    notifyListeners();
  }

  void submitCustomerUdharRecovery({
    required int custId,
    required double amount,
    required String method,
  }) {
    final idx = customers.indexWhere((c) => c.id == custId);
    if (idx < 0 || amount <= 0) return;
    final c = customers[idx];
    c.totalPaid += amount;
    c.history.insert(
      0,
      UdharHistoryEntry(
        id: DateTime.now().millisecondsSinceEpoch,
        type: 'paid',
        amount: amount,
        descUr: 'وصولی بذریعہ $method',
        descRo: 'Wasooli bazariya $method',
        descEn: 'Received via $method',
        dateStr: 'Just Now',
      ),
    );
    cashLedger.insert(
      0,
      CashLedgerEntry(
        id: DateTime.now().millisecondsSinceEpoch + 1,
        type: 'income',
        catUr: 'ادھار وصولی',
        catRo: 'Udhaar Wasooli',
        catEn: 'Customer Credit Recovery',
        descUr: 'ادھار وصولی از: ${c.nameUr} ($method)',
        descRo: 'Udhaar wasooli az: ${c.nameRo} ($method)',
        descEn: 'Credit Recovered: ${c.nameEn} ($method)',
        amount: amount,
        profit: (amount * 0.14).roundToDouble(),
        dateUr: 'ابھی',
        dateRo: 'Abhi',
        dateEn: 'Just Now',
      ),
    );
    saveState();
    showToast(currentLang == 'ur'
        ? 'ادھار وصول ہو کر آمدن میں شامل ہو گیا!'
        : 'Payment recorded & added to Income!');
    notifyListeners();
  }

  void deleteCustomerHistoryEntry(int custId, int historyId) {
    final idx = customers.indexWhere((c) => c.id == custId);
    if (idx < 0) return;
    final c = customers[idx];
    final hIdx = c.history.indexWhere((h) => h.id == historyId);
    if (hIdx < 0) return;
    final h = c.history[hIdx];
    if (h.type == 'paid') {
      c.totalPaid = (c.totalPaid - h.amount) > 0 ? (c.totalPaid - h.amount) : 0;
    } else {
      c.totalGiven = (c.totalGiven - h.amount) > 0 ? (c.totalGiven - h.amount) : 0;
    }
    c.history.removeAt(hIdx);
    saveState();
    showToast(tr('deletedToast'));
    notifyListeners();
  }

  // =========================================================================
  // SUPPLIER ACCOUNTS CRUD
  // =========================================================================
  void saveOrUpdateSupplier({
    int? existingId,
    required String company,
    required String lastSupply,
    required double totalBill,
    required double paidBill,
  }) {
    if (existingId != null) {
      final idx = suppliers.indexWhere((s) => s.id == existingId);
      if (idx >= 0) {
        suppliers[idx].companyUr = company;
        suppliers[idx].companyRo = company;
        suppliers[idx].companyEn = company;
        suppliers[idx].lastSupplyUr = lastSupply;
        suppliers[idx].lastSupplyRo = lastSupply;
        suppliers[idx].lastSupplyEn = lastSupply;
        suppliers[idx].totalBill = totalBill;
        suppliers[idx].paidBill = paidBill;
      }
    } else {
      suppliers.insert(
        0,
        SupplierAccount(
          id: DateTime.now().millisecondsSinceEpoch,
          companyUr: company,
          companyRo: company,
          companyEn: company,
          lastSupplyUr: lastSupply,
          lastSupplyRo: lastSupply,
          lastSupplyEn: lastSupply,
          totalBill: totalBill,
          paidBill: paidBill,
        ),
      );
    }
    saveState();
    showToast(tr('savedToast'));
    notifyListeners();
  }

  void deleteSupplier(int id) {
    suppliers.removeWhere((s) => s.id == id);
    saveState();
    showToast(tr('deletedToast'));
    notifyListeners();
  }

  void paySupplierInstallment(int suppId, {double? customAmount}) {
    final idx = suppliers.indexWhere((s) => s.id == suppId);
    if (idx < 0) return;
    final s = suppliers[idx];
    final rem = s.remaining;
    if (rem <= 0) {
      showToast(currentLang == 'ur'
          ? 'اس کمپنی کا بل پہلے ہی صاف ہے!'
          : 'Already cleared!');
      return;
    }
    final payAmt = customAmount != null && customAmount > 0
        ? (customAmount > rem ? rem : customAmount)
        : (rem > 25000 ? 25000.0 : rem);
    s.paidBill += payAmt;

    cashLedger.insert(
      0,
      CashLedgerEntry(
        id: DateTime.now().millisecondsSinceEpoch,
        type: 'expense',
        catUr: 'پینٹ کمپنی پیمنٹ',
        catRo: 'Paint Company Payment',
        catEn: 'Supplier Payment',
        descUr: '${s.companyUr} کو قسط ادا کی',
        descRo: '${s.companyRo} ko qist ada ki',
        descEn: 'Paid installment to ${s.companyEn}',
        amount: payAmt,
        profit: 0,
        dateUr: 'ابھی',
        dateRo: 'Abhi',
        dateEn: 'Just Now',
      ),
    );
    saveState();
    showToast(currentLang == 'ur'
        ? 'کمپنی کو ${formatMoney(payAmt)} پیمنٹ درج ہو گئی!'
        : 'Supplier payment recorded!');
    notifyListeners();
  }

  // =========================================================================
  // CASHBOOK / ROZNAMCHA (INCOME & EXPENSES) CRUD
  // =========================================================================
  void saveOrUpdateCashEntry({
    int? existingId,
    required String type, // 'income' or 'expense'
    required String category,
    required String note,
    required double amount,
  }) {
    final profit = type == 'income' ? (amount * 0.15).roundToDouble() : 0.0;
    if (existingId != null) {
      final idx = cashLedger.indexWhere((e) => e.id == existingId);
      if (idx >= 0) {
        cashLedger[idx].type = type;
        cashLedger[idx].catUr = category;
        cashLedger[idx].catRo = category;
        cashLedger[idx].catEn = category;
        cashLedger[idx].descUr = note;
        cashLedger[idx].descRo = note;
        cashLedger[idx].descEn = note;
        cashLedger[idx].amount = amount;
        cashLedger[idx].profit = profit;
      }
    } else {
      cashLedger.insert(
        0,
        CashLedgerEntry(
          id: DateTime.now().millisecondsSinceEpoch,
          type: type,
          catUr: category,
          catRo: category,
          catEn: category,
          descUr: note,
          descRo: note,
          descEn: note,
          amount: amount,
          profit: profit,
          dateUr: 'ابھی',
          dateRo: 'Abhi',
          dateEn: 'Just Now',
        ),
      );
    }
    saveState();
    showToast(tr('savedToast'));
    notifyListeners();
  }

  void deleteCashEntry(int id) {
    cashLedger.removeWhere((e) => e.id == id);
    saveState();
    showToast(tr('deletedToast'));
    notifyListeners();
  }

  // =========================================================================
  // PAINTERS & TOKENS CRUD
  // =========================================================================
  void saveOrUpdatePainter({
    int? existingId,
    required String name,
    required String phone,
    required String specialty,
    required double unpaidCommission,
    required int tokensRedeemed,
    required double referredSales,
  }) {
    if (existingId != null) {
      final idx = painters.indexWhere((p) => p.id == existingId);
      if (idx >= 0) {
        painters[idx].nameUr = name;
        painters[idx].nameRo = name;
        painters[idx].nameEn = name;
        painters[idx].phone = phone;
        painters[idx].specialtyUr = specialty;
        painters[idx].specialtyRo = specialty;
        painters[idx].specialtyEn = specialty;
        painters[idx].unpaidCommission = unpaidCommission;
        painters[idx].tokensRedeemed = tokensRedeemed;
        painters[idx].referredSales = referredSales;
      }
    } else {
      painters.insert(
        0,
        PainterAccount(
          id: DateTime.now().millisecondsSinceEpoch,
          nameUr: name,
          nameRo: name,
          nameEn: name,
          phone: phone,
          specialtyUr: specialty,
          specialtyRo: specialty,
          specialtyEn: specialty,
          referredSales: referredSales,
          tokensRedeemed: tokensRedeemed,
          unpaidCommission: unpaidCommission,
        ),
      );
    }
    saveState();
    showToast(tr('savedToast'));
    notifyListeners();
  }

  void deletePainter(int id) {
    painters.removeWhere((p) => p.id == id);
    saveState();
    showToast(tr('deletedToast'));
    notifyListeners();
  }

  void redeemPainterToken({
    required int painterId,
    required String tokenCode,
    required double amount,
  }) {
    final idx = painters.indexWhere((p) => p.id == painterId);
    if (idx < 0) return;
    painters[idx].tokensRedeemed += 1;
    painters[idx].unpaidCommission += amount;
    saveState();
    showToast(currentLang == 'ur'
        ? 'ٹوکن $tokenCode کی رقم پینٹر کھاتے میں جمع ہو گئی!'
        : 'Token $tokenCode credited to Painter!');
    notifyListeners();
  }

  void payPainterCommission(int painterId) {
    final idx = painters.indexWhere((p) => p.id == painterId);
    if (idx < 0) return;
    final p = painters[idx];
    if (p.unpaidCommission <= 0) return;
    final amt = p.unpaidCommission;
    p.unpaidCommission = 0;

    cashLedger.insert(
      0,
      CashLedgerEntry(
        id: DateTime.now().millisecondsSinceEpoch,
        type: 'expense',
        catUr: 'پینٹر کمیشن ادائیگی',
        catRo: 'Painter Commission Adaigi',
        catEn: 'Painter Commission Paid',
        descUr: '${p.nameUr} کو کمیشن اور ٹوکن کی نقد ادائیگی',
        descRo: '${p.nameRo} ko commission aur token ki naqad adaigi',
        descEn: 'Paid commission & token cash to ${p.nameEn}',
        amount: amt,
        profit: 0,
        dateUr: 'ابھی',
        dateRo: 'Abhi',
        dateEn: 'Just Now',
      ),
    );
    saveState();
    showToast(currentLang == 'ur'
        ? '${formatMoney(amt)} کمیشن ادا کر دیا گیا!'
        : 'Painter commission paid!');
    notifyListeners();
  }

  // =========================================================================
  // ROOM ESTIMATOR PACKAGE TO POS
  // =========================================================================
  void addEstimatePackageToPos({
    required double width,
    required double length,
    required double height,
  }) {
    final netArea = ((2 * (width + length) * height + width * length) * 0.88).round();
    final area = netArea < 100 ? 100 : netArea;
    final litersNeeded = area / 65.0;
    final gallonsNeeded = (litersNeeded / 3.64).ceil().clamp(1, 999);
    final puttyBags = (area / 450.0).ceil().clamp(1, 999);

    posCart.add(CartItem(
      prodId: 102,
      code: 'HRC-WG-G',
      nameUr: 'گوبیز ہرکولیس ویدر گارڈ (${width.round()}x${length.round()} کمرہ پیکج)',
      nameRo: 'Gobis Hercules Weather Guard (${width.round()}x${length.round()} Room Package)',
      nameEn: "Gobi's Hercules Weather Guard (${width.round()}x${length.round()} Room Package)",
      price: 4468,
      cost: 3786,
      qty: gallonsNeeded,
    ));
    posCart.add(CartItem(
      prodId: 113,
      code: 'HRC-WP-D',
      nameUr: 'گوبیز ہرکولیس وال پٹین ڈرم (20 کلو)',
      nameRo: 'Gobis Hercules Wall Putty Drum (20 Kg)',
      nameEn: "Gobi's Hercules Wall Putty Drum (20 Kg)",
      price: 4395,
      cost: 3725,
      qty: puttyBags,
    ));
    currentTab = 'pos';
    saveState();
    showToast(currentLang == 'ur'
        ? 'کمرے کا مکمل گوبیز پینٹ پیکج بل میں شامل ہو گیا!'
        : 'Room Paint Package added to POS Bill!');
    notifyListeners();
  }
}

