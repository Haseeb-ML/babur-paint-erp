import 'dart:convert';

class ShopProfile {
  String nameUr;
  String nameRo;
  String nameEn;
  String subUr;
  String subRo;
  String subEn;
  String address;
  String phone;
  String email;

  ShopProfile({
    required this.nameUr,
    required this.nameRo,
    required this.nameEn,
    required this.subUr,
    required this.subRo,
    required this.subEn,
    required this.address,
    required this.phone,
    required this.email,
  });

  String getName(String lang) {
    if (lang == 'ur') return nameUr;
    if (lang == 'ro') return nameRo;
    return nameEn;
  }

  String getSub(String lang) {
    if (lang == 'ur') return subUr;
    if (lang == 'ro') return subRo;
    return subEn;
  }

  Map<String, dynamic> toMap() => {
        'nameUr': nameUr,
        'nameRo': nameRo,
        'nameEn': nameEn,
        'subUr': subUr,
        'subRo': subRo,
        'subEn': subEn,
        'address': address,
        'phone': phone,
        'email': email,
      };

  factory ShopProfile.fromMap(Map<String, dynamic> map) => ShopProfile(
        nameUr: map['nameUr'] ?? 'بابر اینڈ برادرز ہارڈویئر اینڈ پینٹ سٹور',
        nameRo: map['nameRo'] ?? 'Babur & Brothers Hardware & Paint Store',
        nameEn: map['nameEn'] ?? 'Babur & Brothers Hardware & Paint Store',
        subUr: map['subUr'] ?? 'بھیرہ روڈ، نواز پلازہ، ملکوال • 03000952862',
        subRo: map['subRo'] ?? 'Bhera Road, Nawaz Plaza, Malikwal • 03000952862',
        subEn: map['subEn'] ?? 'Bhera Road, Nawaz Plaza, Malikwal • 03000952862',
        address: map['address'] ?? 'Bhera road nawaz plaza malikwal',
        phone: map['phone'] ?? '03000952862',
        email: map['email'] ?? 'Babur.Brothers369@gmail.com',
      );
}

class PaintProduct {
  int id;
  String code;
  String brand; // Gobis, Berger, Brighto, Master, Hardware
  String series; // Decorative, Carman NC, Silverline, BigBang 2K, Tusker 2K, Stoving, Epoxy & Ind, Timberline, Ancillaries
  String cat; // Emulsion, Weather, Enamel, NC2K, StovingEpoxy, Wood, Hardware
  String nameUr;
  String nameRo;
  String nameEn;
  String sizeUr;
  String sizeRo;
  String sizeEn;
  double costPrice;
  double retailPrice; // RP (Before GST or Net Rate)
  double gstAmount; // 18% GST if Decorative/Timberline, else 0
  double salePrice; // Active selling price (MRP or Net Rate)
  int stock;
  int minStock;
  String colorHex;

  PaintProduct({
    required this.id,
    required this.code,
    required this.brand,
    required this.series,
    required this.cat,
    required this.nameUr,
    required this.nameRo,
    required this.nameEn,
    required this.sizeUr,
    required this.sizeRo,
    required this.sizeEn,
    required this.costPrice,
    required this.retailPrice,
    required this.gstAmount,
    required this.salePrice,
    required this.stock,
    required this.minStock,
    required this.colorHex,
  });

  String getName(String lang) {
    if (lang == 'ur') return nameUr;
    if (lang == 'ro') return nameRo;
    return nameEn;
  }

  String getSize(String lang) {
    if (lang == 'ur') return sizeUr;
    if (lang == 'ro') return sizeRo;
    return sizeEn;
  }

  String getBrandLabel(String lang) {
    if (lang == 'ur') {
      switch (brand) {
        case 'Gobis':
          return 'گوبیز';
        case 'Berger':
          return 'برجر';
        case 'Brighto':
          return 'برائٹو';
        case 'Master':
          return 'ماسٹر';
        default:
          return 'ہارڈویئر';
      }
    }
    return brand == 'Gobis' ? "Gobi's" : brand;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'code': code,
        'brand': brand,
        'series': series,
        'cat': cat,
        'nameUr': nameUr,
        'nameRo': nameRo,
        'nameEn': nameEn,
        'sizeUr': sizeUr,
        'sizeRo': sizeRo,
        'sizeEn': sizeEn,
        'costPrice': costPrice,
        'retailPrice': retailPrice,
        'gstAmount': gstAmount,
        'salePrice': salePrice,
        'stock': stock,
        'minStock': minStock,
        'colorHex': colorHex,
      };

  factory PaintProduct.fromMap(Map<String, dynamic> map) => PaintProduct(
        id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
        code: map['code'] ?? '',
        brand: map['brand'] ?? 'Gobis',
        series: map['series'] ?? 'Decorative',
        cat: map['cat'] ?? 'Emulsion',
        nameUr: map['nameUr'] ?? '',
        nameRo: map['nameRo'] ?? '',
        nameEn: map['nameEn'] ?? '',
        sizeUr: map['sizeUr'] ?? '',
        sizeRo: map['sizeRo'] ?? '',
        sizeEn: map['sizeEn'] ?? '',
        costPrice: (map['costPrice'] ?? 0).toDouble(),
        retailPrice: (map['retailPrice'] ?? 0).toDouble(),
        gstAmount: (map['gstAmount'] ?? 0).toDouble(),
        salePrice: (map['salePrice'] ?? 0).toDouble(),
        stock: map['stock'] ?? 0,
        minStock: map['minStock'] ?? 4,
        colorHex: map['colorHex'] ?? '#93C5FD',
      );
}

class CartItem {
  int prodId;
  String code;
  String nameUr;
  String nameRo;
  String nameEn;
  double price;
  double cost;
  int qty;

  CartItem({
    required this.prodId,
    this.code = '',
    required this.nameUr,
    required this.nameRo,
    required this.nameEn,
    required this.price,
    required this.cost,
    required this.qty,
  });

  String getName(String lang) {
    if (lang == 'ur') return nameUr;
    if (lang == 'ro') return nameRo;
    return nameEn;
  }

  Map<String, dynamic> toMap() => {
        'prodId': prodId,
        'code': code,
        'nameUr': nameUr,
        'nameRo': nameRo,
        'nameEn': nameEn,
        'price': price,
        'cost': cost,
        'qty': qty,
      };

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
        prodId: map['prodId'] ?? 0,
        code: map['code'] ?? '',
        nameUr: map['nameUr'] ?? '',
        nameRo: map['nameRo'] ?? '',
        nameEn: map['nameEn'] ?? '',
        price: (map['price'] ?? 0).toDouble(),
        cost: (map['cost'] ?? 0).toDouble(),
        qty: map['qty'] ?? 1,
      );
}

class PigmentShot {
  String nameUr;
  String nameRo;
  String nameEn;
  double ml;
  String colorHex;

  PigmentShot({
    required this.nameUr,
    required this.nameRo,
    required this.nameEn,
    required this.ml,
    required this.colorHex,
  });

  String getName(String lang) {
    if (lang == 'ur') return nameUr;
    if (lang == 'ro') return nameRo;
    return nameEn;
  }

  Map<String, dynamic> toMap() => {
        'nameUr': nameUr,
        'nameRo': nameRo,
        'nameEn': nameEn,
        'ml': ml,
        'colorHex': colorHex,
      };

  factory PigmentShot.fromMap(Map<String, dynamic> map) => PigmentShot(
        nameUr: map['nameUr'] ?? '',
        nameRo: map['nameRo'] ?? '',
        nameEn: map['nameEn'] ?? '',
        ml: (map['ml'] ?? 10).toDouble(),
        colorHex: map['colorHex'] ?? '#F59E0B',
      );
}

class ShadeItem {
  int id;
  String code;
  String series; // WeatherGuard, Emulsion, Enamel, Custom
  String nameUr;
  String nameRo;
  String nameEn;
  String baseUr;
  String baseRo;
  String baseEn;
  String hex;
  double baseGallonPrice;
  double tintCostGallon;
  List<PigmentShot> pigments;

  ShadeItem({
    required this.id,
    required this.code,
    required this.series,
    required this.nameUr,
    required this.nameRo,
    required this.nameEn,
    required this.baseUr,
    required this.baseRo,
    required this.baseEn,
    required this.hex,
    required this.baseGallonPrice,
    required this.tintCostGallon,
    required this.pigments,
  });

  String getName(String lang) {
    if (lang == 'ur') return nameUr;
    if (lang == 'ro') return nameRo;
    return nameEn;
  }

  String getBase(String lang) {
    if (lang == 'ur') return baseUr;
    if (lang == 'ro') return baseRo;
    return baseEn;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'code': code,
        'series': series,
        'nameUr': nameUr,
        'nameRo': nameRo,
        'nameEn': nameEn,
        'baseUr': baseUr,
        'baseRo': baseRo,
        'baseEn': baseEn,
        'hex': hex,
        'baseGallonPrice': baseGallonPrice,
        'tintCostGallon': tintCostGallon,
        'pigments': pigments.map((p) => p.toMap()).toList(),
      };

  factory ShadeItem.fromMap(Map<String, dynamic> map) => ShadeItem(
        id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
        code: map['code'] ?? '',
        series: map['series'] ?? 'WeatherGuard',
        nameUr: map['nameUr'] ?? '',
        nameRo: map['nameRo'] ?? '',
        nameEn: map['nameEn'] ?? '',
        baseUr: map['baseUr'] ?? '',
        baseRo: map['baseRo'] ?? '',
        baseEn: map['baseEn'] ?? '',
        hex: map['hex'] ?? '#F5E6C8',
        baseGallonPrice: (map['baseGallonPrice'] ?? 4468).toDouble(),
        tintCostGallon: (map['tintCostGallon'] ?? 350).toDouble(),
        pigments: (map['pigments'] as List<dynamic>? ?? [])
            .map((e) => PigmentShot.fromMap(Map<String, dynamic>.from(e)))
            .toList(),
      );
}

class UdharHistoryEntry {
  int id;
  String type; // 'given' or 'paid'
  double amount;
  String descUr;
  String descRo;
  String descEn;
  String dateStr;

  UdharHistoryEntry({
    required this.id,
    required this.type,
    required this.amount,
    required this.descUr,
    required this.descRo,
    required this.descEn,
    this.dateStr = 'Today',
  });

  String getDesc(String lang) {
    if (lang == 'ur') return descUr;
    if (lang == 'ro') return descRo;
    return descEn;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'amount': amount,
        'descUr': descUr,
        'descRo': descRo,
        'descEn': descEn,
        'dateStr': dateStr,
      };

  factory UdharHistoryEntry.fromMap(Map<String, dynamic> map) => UdharHistoryEntry(
        id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
        type: map['type'] ?? 'given',
        amount: (map['amount'] ?? 0).toDouble(),
        descUr: map['descUr'] ?? '',
        descRo: map['descRo'] ?? '',
        descEn: map['descEn'] ?? '',
        dateStr: map['dateStr'] ?? 'Today',
      );
}

class UdharCustomer {
  int id;
  String nameUr;
  String nameRo;
  String nameEn;
  String phone;
  String workUr;
  String workRo;
  String workEn;
  double totalGiven;
  double totalPaid;
  List<UdharHistoryEntry> history;

  UdharCustomer({
    required this.id,
    required this.nameUr,
    required this.nameRo,
    required this.nameEn,
    required this.phone,
    required this.workUr,
    required this.workRo,
    required this.workEn,
    required this.totalGiven,
    required this.totalPaid,
    required this.history,
  });

  double get remaining => (totalGiven - totalPaid) > 0 ? (totalGiven - totalPaid) : 0;

  String getName(String lang) {
    if (lang == 'ur') return nameUr;
    if (lang == 'ro') return nameRo;
    return nameEn;
  }

  String getWork(String lang) {
    if (lang == 'ur') return workUr;
    if (lang == 'ro') return workRo;
    return workEn;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nameUr': nameUr,
        'nameRo': nameRo,
        'nameEn': nameEn,
        'phone': phone,
        'workUr': workUr,
        'workRo': workRo,
        'workEn': workEn,
        'totalGiven': totalGiven,
        'totalPaid': totalPaid,
        'history': history.map((h) => h.toMap()).toList(),
      };

  factory UdharCustomer.fromMap(Map<String, dynamic> map) => UdharCustomer(
        id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
        nameUr: map['nameUr'] ?? '',
        nameRo: map['nameRo'] ?? '',
        nameEn: map['nameEn'] ?? '',
        phone: map['phone'] ?? '',
        workUr: map['workUr'] ?? '',
        workRo: map['workRo'] ?? '',
        workEn: map['workEn'] ?? '',
        totalGiven: (map['totalGiven'] ?? 0).toDouble(),
        totalPaid: (map['totalPaid'] ?? 0).toDouble(),
        history: (map['history'] as List<dynamic>? ?? [])
            .map((e) => UdharHistoryEntry.fromMap(Map<String, dynamic>.from(e)))
            .toList(),
      );
}

class SupplierAccount {
  int id;
  String companyUr;
  String companyRo;
  String companyEn;
  String lastSupplyUr;
  String lastSupplyRo;
  String lastSupplyEn;
  double totalBill;
  double paidBill;

  SupplierAccount({
    required this.id,
    required this.companyUr,
    required this.companyRo,
    required this.companyEn,
    required this.lastSupplyUr,
    required this.lastSupplyRo,
    required this.lastSupplyEn,
    required this.totalBill,
    required this.paidBill,
  });

  double get remaining => (totalBill - paidBill) > 0 ? (totalBill - paidBill) : 0;

  String getCompany(String lang) {
    if (lang == 'ur') return companyUr;
    if (lang == 'ro') return companyRo;
    return companyEn;
  }

  String getLastSupply(String lang) {
    if (lang == 'ur') return lastSupplyUr;
    if (lang == 'ro') return lastSupplyRo;
    return lastSupplyEn;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'companyUr': companyUr,
        'companyRo': companyRo,
        'companyEn': companyEn,
        'lastSupplyUr': lastSupplyUr,
        'lastSupplyRo': lastSupplyRo,
        'lastSupplyEn': lastSupplyEn,
        'totalBill': totalBill,
        'paidBill': paidBill,
      };

  factory SupplierAccount.fromMap(Map<String, dynamic> map) => SupplierAccount(
        id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
        companyUr: map['companyUr'] ?? '',
        companyRo: map['companyRo'] ?? '',
        companyEn: map['companyEn'] ?? '',
        lastSupplyUr: map['lastSupplyUr'] ?? '',
        lastSupplyRo: map['lastSupplyRo'] ?? '',
        lastSupplyEn: map['lastSupplyEn'] ?? '',
        totalBill: (map['totalBill'] ?? 0).toDouble(),
        paidBill: (map['paidBill'] ?? 0).toDouble(),
      );
}

class PainterAccount {
  int id;
  String nameUr;
  String nameRo;
  String nameEn;
  String phone;
  String specialtyUr;
  String specialtyRo;
  String specialtyEn;
  double referredSales;
  int tokensRedeemed;
  double unpaidCommission;

  PainterAccount({
    required this.id,
    required this.nameUr,
    required this.nameRo,
    required this.nameEn,
    required this.phone,
    required this.specialtyUr,
    required this.specialtyRo,
    required this.specialtyEn,
    required this.referredSales,
    required this.tokensRedeemed,
    required this.unpaidCommission,
  });

  String getName(String lang) {
    if (lang == 'ur') return nameUr;
    if (lang == 'ro') return nameRo;
    return nameEn;
  }

  String getSpecialty(String lang) {
    if (lang == 'ur') return specialtyUr;
    if (lang == 'ro') return specialtyRo;
    return specialtyEn;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nameUr': nameUr,
        'nameRo': nameRo,
        'nameEn': nameEn,
        'phone': phone,
        'specialtyUr': specialtyUr,
        'specialtyRo': specialtyRo,
        'specialtyEn': specialtyEn,
        'referredSales': referredSales,
        'tokensRedeemed': tokensRedeemed,
        'unpaidCommission': unpaidCommission,
      };

  factory PainterAccount.fromMap(Map<String, dynamic> map) => PainterAccount(
        id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
        nameUr: map['nameUr'] ?? '',
        nameRo: map['nameRo'] ?? '',
        nameEn: map['nameEn'] ?? '',
        phone: map['phone'] ?? '',
        specialtyUr: map['specialtyUr'] ?? '',
        specialtyRo: map['specialtyRo'] ?? '',
        specialtyEn: map['specialtyEn'] ?? '',
        referredSales: (map['referredSales'] ?? 0).toDouble(),
        tokensRedeemed: map['tokensRedeemed'] ?? 0,
        unpaidCommission: (map['unpaidCommission'] ?? 0).toDouble(),
      );
}

class CashLedgerEntry {
  int id;
  String type; // 'income' or 'expense'
  String catUr;
  String catRo;
  String catEn;
  String descUr;
  String descRo;
  String descEn;
  double amount;
  double profit;
  String dateUr;
  String dateRo;
  String dateEn;

  CashLedgerEntry({
    required this.id,
    required this.type,
    required this.catUr,
    required this.catRo,
    required this.catEn,
    required this.descUr,
    required this.descRo,
    required this.descEn,
    required this.amount,
    required this.profit,
    required this.dateUr,
    required this.dateRo,
    required this.dateEn,
  });

  String getCat(String lang) {
    if (lang == 'ur') return catUr;
    if (lang == 'ro') return catRo;
    return catEn;
  }

  String getDesc(String lang) {
    if (lang == 'ur') return descUr;
    if (lang == 'ro') return descRo;
    return descEn;
  }

  String getDate(String lang) {
    if (lang == 'ur') return dateUr;
    if (lang == 'ro') return dateRo;
    return dateEn;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'catUr': catUr,
        'catRo': catRo,
        'catEn': catEn,
        'descUr': descUr,
        'descRo': descRo,
        'descEn': descEn,
        'amount': amount,
        'profit': profit,
        'dateUr': dateUr,
        'dateRo': dateRo,
        'dateEn': dateEn,
      };

  factory CashLedgerEntry.fromMap(Map<String, dynamic> map) => CashLedgerEntry(
        id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
        type: map['type'] ?? 'income',
        catUr: map['catUr'] ?? '',
        catRo: map['catRo'] ?? '',
        catEn: map['catEn'] ?? '',
        descUr: map['descUr'] ?? '',
        descRo: map['descRo'] ?? '',
        descEn: map['descEn'] ?? '',
        amount: (map['amount'] ?? 0).toDouble(),
        profit: (map['profit'] ?? 0).toDouble(),
        dateUr: map['dateUr'] ?? 'آج',
        dateRo: map['dateRo'] ?? 'Aaj',
        dateEn: map['dateEn'] ?? 'Today',
      );

  static String encodeList(List<dynamic> list) =>
      jsonEncode(list.map((e) => e.toMap()).toList());
}

