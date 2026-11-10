import 'package:flutter/material.dart';

class ErpThemePalette {
  final String id;
  final String nameUr;
  final String nameRo;
  final String nameEn;
  final Color headerStart;
  final Color headerEnd;
  final Color primary;
  final Color accent;
  final Color kpiBg;

  const ErpThemePalette({
    required this.id,
    required this.nameUr,
    required this.nameRo,
    required this.nameEn,
    required this.headerStart,
    required this.headerEnd,
    required this.primary,
    required this.accent,
    required this.kpiBg,
  });

  String getName(String lang) {
    if (lang == 'ur') return nameUr;
    if (lang == 'ro') return nameRo;
    return nameEn;
  }
}

class AppThemes {
  static const List<ErpThemePalette> palettes = [
    ErpThemePalette(
      id: 'royal_blue',
      nameUr: 'رائل بلیو (کلائنٹ پسندیدہ ڈیزائن)',
      nameRo: 'Royal Blue (Client Favorite)',
      nameEn: 'Royal Blue (Client Favorite)',
      headerStart: Color(0xFF1E3A8A),
      headerEnd: Color(0xFF1D4ED8),
      primary: Color(0xFF2563EB),
      accent: Color(0xFFFBBF24),
      kpiBg: Color(0xFF172554),
    ),
    ErpThemePalette(
      id: 'bnb_gold',
      nameUr: 'بابر اینڈ برادرز گولڈ اینڈ بلیک (B&B لوگو)',
      nameRo: 'B&B Gold & Black (Official Logo)',
      nameEn: 'B&B Gold & Black (Official Logo)',
      headerStart: Color(0xFF090D16),
      headerEnd: Color(0xFF1E293B),
      primary: Color(0xFFD97706),
      accent: Color(0xFFF59E0B),
      kpiBg: Color(0xFF0F172A),
    ),
    ErpThemePalette(
      id: 'hercules_green',
      nameUr: 'گوبیز ہرکولیس ایمرالڈ گرین',
      nameRo: "Gobi's Hercules Emerald Green",
      nameEn: "Gobi's Hercules Emerald Green",
      headerStart: Color(0xFF064E3B),
      headerEnd: Color(0xFF047857),
      primary: Color(0xFF059669),
      accent: Color(0xFFFBBF24),
      kpiBg: Color(0xFF022C22),
    ),
    ErpThemePalette(
      id: 'timber_terracotta',
      nameUr: 'ٹمبر لائن ٹیراکوٹا اینڈ ریڈ',
      nameRo: 'Timberline Terracotta & Red',
      nameEn: 'Timberline Terracotta & Red',
      headerStart: Color(0xFF7F1D1D),
      headerEnd: Color(0xFFB91C1C),
      primary: Color(0xFFDC2626),
      accent: Color(0xFFFBBF24),
      kpiBg: Color(0xFF450A0A),
    ),
    ErpThemePalette(
      id: 'velvet_indigo',
      nameUr: 'رائل ویلویٹ پرپل انڈیگو',
      nameRo: 'Royal Velvet Purple Indigo',
      nameEn: 'Royal Velvet Purple Indigo',
      headerStart: Color(0xFF312E81),
      headerEnd: Color(0xFF4338CA),
      primary: Color(0xFF4F46E5),
      accent: Color(0xFFFBBF24),
      kpiBg: Color(0xFF1E1B4B),
    ),
  ];

  static Color parseHex(String hexString) {
    final buffer = StringBuffer();
    String clean = hexString.replaceFirst('#', '').trim();
    if (clean.length == 6) buffer.write('ff');
    buffer.write(clean);
    return Color(int.tryParse(buffer.toString(), radix: 16) ?? 0xFF93C5FD);
  }
}

