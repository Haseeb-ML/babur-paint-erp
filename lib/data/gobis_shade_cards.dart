class ShadeCardEntry {
  final String series;
  final String categoryLabel;
  final String cat; // Maps to PaintProduct.cat (Emulsion, Enamel, Weather, etc.)
  final String shadeCode;
  final String shadeName;
  final String colorHex;

  const ShadeCardEntry({
    required this.series,
    required this.categoryLabel,
    required this.cat,
    required this.shadeCode,
    required this.shadeName,
    required this.colorHex,
  });

  String get displayLabel =>
      shadeCode.isEmpty ? shadeName : '$shadeCode - $shadeName';
}

class GobisShadeCards {
  static const List<String> seriesList = [
    'Gold',
    'Hercules',
    'Protector',
  ];

  static const Map<String, List<String>> categoriesBySeries = {
    'Gold': [
      'Gold Luxurious Wall Emulsion',
      'Gold High Gloss Synthetic Enamel',
      'Gold Aqueous Matt Finish',
      'Gold Eggshell Finish Matt Enamel',
      'Gold Exterior Weather Guard',
    ],
    'Hercules': [
      'Hercules Emulsion',
      'Hercules Enamel',
      'Hercules Weather Guard',
    ],
    'Protector': [
      'Protector Emulsion',
      'Protector Weather Guard',
      'Protector Sealer / Primer',
    ],
  };

  static String catCodeForCategory(String categoryLabel) {
    final lower = categoryLabel.toLowerCase();
    if (lower.contains('weather')) return 'Weather';
    if (lower.contains('enamel') ||
        lower.contains('eggshell') ||
        lower.contains('aqueous')) {
      return 'Enamel';
    }
    return 'Emulsion';
  }

  static List<String> categoriesForSeries(String series) =>
      categoriesBySeries[series] ?? const ['General'];

  static List<ShadeCardEntry> shadesFor(String series, String categoryLabel) {
    return allShades
        .where((s) => s.series == series && s.categoryLabel == categoryLabel)
        .toList();
  }

  static const List<ShadeCardEntry> allShades = [
    // =========================================================================
    // 1. GOBI'S GOLD LUXURIOUS WALL EMULSION
    // =========================================================================
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1400', shadeName: 'White', colorHex: '#FFFFFF'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1401', shadeName: 'Off White', colorHex: '#F7F5EE'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1402', shadeName: 'Magnolia', colorHex: '#F3EAD8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1403', shadeName: 'Soft Silk', colorHex: '#EFE6D5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1405', shadeName: 'Cream', colorHex: '#F2E2B6'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1407', shadeName: 'Cockleshell', colorHex: '#EADFD5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1410', shadeName: 'Honey Milk', colorHex: '#F6E7C1'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1412', shadeName: 'Peach Goddess', colorHex: '#F7D2BD'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1413', shadeName: 'Desert Dawn', colorHex: '#E9BA94'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1414', shadeName: 'Fresh Orange', colorHex: '#F28533'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1423', shadeName: 'Sherbet', colorHex: '#F5E8A6'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1424', shadeName: 'Fresh Green', colorHex: '#8CD17D'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1425', shadeName: 'Lime Light', colorHex: '#DCE89E'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1427', shadeName: 'Pastel Green', colorHex: '#CBE3C1'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1436', shadeName: 'Sea Wind', colorHex: '#B6DED8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1437', shadeName: 'Celestial', colorHex: '#B7D3E8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1438', shadeName: 'Ice Age', colorHex: '#D8E8EE'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1439', shadeName: 'Blue Heaven', colorHex: '#8CC4E8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1444', shadeName: 'Orchard Lane', colorHex: '#D7D5C8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1445', shadeName: 'Mallow', colorHex: '#D9BED8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1446', shadeName: 'Classical', colorHex: '#DDD6CE'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1447', shadeName: 'Cherry Blossom Pink', colorHex: '#F6CED8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1452', shadeName: 'Moon Flower', colorHex: '#F2EFE6'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1453', shadeName: 'Porcelain', colorHex: '#E8E4DB'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1455', shadeName: 'Peach', colorHex: '#F6C2A3'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1456', shadeName: 'Bow Bells', colorHex: '#E8D8C8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1458', shadeName: 'Ash White', colorHex: '#E5E7E9'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1459', shadeName: 'Blue', colorHex: '#2E6BB0'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1460', shadeName: 'Red', colorHex: '#B92B27'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1461', shadeName: 'Wood Berry', colorHex: '#9C5C6E'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1462', shadeName: 'Purple', colorHex: '#6F4E8C'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1463', shadeName: 'Green Summit', colorHex: '#4E7D5B'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1464', shadeName: 'Ice Grey', colorHex: '#CED5DA'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1465', shadeName: 'Terracotta', colorHex: '#C66647'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1466', shadeName: 'Parasol', colorHex: '#E2D0B8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1467', shadeName: 'Tea Rose', colorHex: '#E6B2AA'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1468', shadeName: 'Dove Grey', colorHex: '#B6BBC0'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1469', shadeName: 'Pink', colorHex: '#EFA8BC'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1470', shadeName: 'Sand Stone', colorHex: '#D1BC9B'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1471', shadeName: 'Zephyr', colorHex: '#D8E3DD'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1472', shadeName: 'Forest Green', colorHex: '#2F6644'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Luxurious Wall Emulsion', cat: 'Emulsion', shadeCode: '1473', shadeName: 'Cameo', colorHex: '#DFC7B0'),

    // =========================================================================
    // 2. GOBI'S GOLD HIGH GLOSS SYNTHETIC ENAMEL & METALLIC
    // =========================================================================
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7001', shadeName: 'White', colorHex: '#FFFFFF'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7002', shadeName: 'Off White', colorHex: '#F7F4EA'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7003', shadeName: 'Cream', colorHex: '#F2E0B3'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7004', shadeName: 'Champagne', colorHex: '#E5D3B3'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7007', shadeName: 'Spring Green', colorHex: '#5CB85C'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7009', shadeName: 'Orange', colorHex: '#E86A17'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7010', shadeName: 'Lemon', colorHex: '#F4D03F'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7011', shadeName: 'Red Oxide', colorHex: '#8E3228'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7012', shadeName: 'Dark Brown', colorHex: '#4E3022'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7013', shadeName: 'Golden Yellow', colorHex: '#F39C12'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7014', shadeName: 'Light Blue', colorHex: '#7FB3D5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7015', shadeName: 'Vivid Blue', colorHex: '#1F618D'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7016', shadeName: 'Signal Red', colorHex: '#C0392B'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7017', shadeName: 'Ash White', colorHex: '#E5E8E8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7018', shadeName: 'Sheesham', colorHex: '#6E3B28'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7019', shadeName: 'Emerald', colorHex: '#1E8449'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7020', shadeName: 'Diyar', colorHex: '#8D5524'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7021', shadeName: 'Pale Cream', colorHex: '#F5EBD1'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7022', shadeName: 'Royal Green', colorHex: '#195432'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7023', shadeName: 'Smoke Grey', colorHex: '#8D9399'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7024', shadeName: 'Beige', colorHex: '#D8C7AE'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7025', shadeName: 'Sea Green', colorHex: '#76B5A0'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7026', shadeName: 'Pumice', colorHex: '#CFC9BE'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7027', shadeName: 'Oyster', colorHex: '#D5D0C5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7028', shadeName: 'Coriander', colorHex: '#8D9E6F'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7030', shadeName: 'Golden Brown', colorHex: '#9A6324'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7031', shadeName: 'Fine Silver (Metallic)', colorHex: '#BDC3C7'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7032', shadeName: 'Champ. Silver (Metallic)', colorHex: '#D0C8B8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7033', shadeName: 'Champagne (Metallic)', colorHex: '#D4AF37'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7034', shadeName: 'Gold Valley (Metallic)', colorHex: '#C59B27'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7035', shadeName: 'Copper (Metallic)', colorHex: '#B87333'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7036', shadeName: 'Dark Brown (Metallic)', colorHex: '#5C3A21'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7037', shadeName: 'Rose Pack', colorHex: '#D98E9A'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7038', shadeName: 'Iceland Blue', colorHex: '#A7C7E7'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7039', shadeName: 'Shiny Green', colorHex: '#2E8B57'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7040', shadeName: 'Green Gold', colorHex: '#808000'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7041', shadeName: 'Lush Green', colorHex: '#27AE60'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7045', shadeName: 'Black', colorHex: '#1C1C1C'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7046', shadeName: 'Early Dawn', colorHex: '#EED9C4'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7047', shadeName: 'Cameo', colorHex: '#DFC7B0'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7048', shadeName: 'Soft Terracotta', colorHex: '#D1826B'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7049', shadeName: 'Polish Brown', colorHex: '#7A4329'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7050', shadeName: 'Brown', colorHex: '#6F4E37'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7051', shadeName: 'Rose Pink', colorHex: '#E89EB8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7052', shadeName: 'Hot Pink', colorHex: '#D84378'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7053', shadeName: 'Comet Blue', colorHex: '#4682B4'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7054', shadeName: 'Cornflower', colorHex: '#6495ED'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7055', shadeName: 'Mauve', colorHex: '#9E7BB5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7056', shadeName: 'White Green', colorHex: '#D5E5D5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7057', shadeName: 'Adams Green', colorHex: '#4A773C'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold High Gloss Synthetic Enamel', cat: 'Enamel', shadeCode: '7058', shadeName: 'Dark Grey', colorHex: '#565A5E'),

    // =========================================================================
    // 3. GOBI'S GOLD AQUEOUS MATT FINISH
    // =========================================================================
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '400', shadeName: 'White', colorHex: '#FFFFFF'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '401', shadeName: 'Off White', colorHex: '#F7F5EE'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '402', shadeName: 'Pearl White', colorHex: '#F4F1EA'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '403', shadeName: 'Antique White', colorHex: '#EFE6D5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '404', shadeName: 'Thousand Nights', colorHex: '#2C3E50'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '405', shadeName: 'Ash White', colorHex: '#E5E7E9'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '406', shadeName: 'Silver Tone', colorHex: '#D0D3D4'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '407', shadeName: 'Peppermint', colorHex: '#D1ECE0'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '408', shadeName: 'Vanilla Latte', colorHex: '#EADBC8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '409', shadeName: 'Spring Air', colorHex: '#DCEAE8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '410', shadeName: 'Sand', colorHex: '#D8C49E'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '411', shadeName: 'Cameo', colorHex: '#DFC7B0'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '412', shadeName: 'Soft Peach', colorHex: '#F6D3C1'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '413', shadeName: 'Tile Red', colorHex: '#A94438'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '414', shadeName: 'Deep Spice', colorHex: '#8E4B32'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '415', shadeName: 'Crescent Moon', colorHex: '#F2E7CA'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '416', shadeName: 'Lavender White', colorHex: '#ECE8F1'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '417', shadeName: 'Cockleshell', colorHex: '#EADFD5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '418', shadeName: 'Magnolia', colorHex: '#F3EAD8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '419', shadeName: 'Lilac Time', colorHex: '#CBB8D9'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '420', shadeName: 'Vintage Violet', colorHex: '#7D608C'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '421', shadeName: 'Pink Violet', colorHex: '#B87EA8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '422', shadeName: 'Purple Heather', colorHex: '#8D6996'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '423', shadeName: 'Eternity', colorHex: '#D5C9B8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '424', shadeName: 'Red Haze', colorHex: '#B95858'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '425', shadeName: 'Steel Grey', colorHex: '#7A8086'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '426', shadeName: 'Red Purple', colorHex: '#7A3E5D'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '427', shadeName: 'Vintage', colorHex: '#C5B0A5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '428', shadeName: 'Pink', colorHex: '#F0B6C7'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '429', shadeName: 'Iced Pink', colorHex: '#F5D5DE'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '430', shadeName: 'Puff', colorHex: '#F7E7DA'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '431', shadeName: 'Lime Yellow', colorHex: '#DDE675'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '432', shadeName: 'Mango Yellow', colorHex: '#F3B844'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '433', shadeName: 'Triple Crown', colorHex: '#D8B589'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '434', shadeName: 'Peach Country', colorHex: '#EEB699'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '435', shadeName: 'Fresh Cut', colorHex: '#B6D9A8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '436', shadeName: 'Light Green', colorHex: '#99CC99'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '437', shadeName: 'Twisted Mint', colorHex: '#A6D7C3'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '438', shadeName: 'Leaf Green', colorHex: '#5C9B57'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '439', shadeName: 'Sea Blue', colorHex: '#639BB5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '440', shadeName: 'Cool Blue', colorHex: '#9AC0D9'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '441', shadeName: 'Mauve', colorHex: '#9E7BB5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Aqueous Matt Finish', cat: 'Enamel', shadeCode: '442', shadeName: 'Black', colorHex: '#1C1C1C'),

    // =========================================================================
    // 4. GOBI'S GOLD EGGSHELL FINISH MATT ENAMEL
    // =========================================================================
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '701', shadeName: 'Honey White', colorHex: '#FAF3E3'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '702', shadeName: 'Off White', colorHex: '#F7F5EE'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '703', shadeName: 'Lavender White', colorHex: '#ECE8F1'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '704', shadeName: 'Ash White', colorHex: '#E5E7E9'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '705', shadeName: 'Adorable Peach', colorHex: '#F6D5C1'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '706', shadeName: 'Kitten White', colorHex: '#F5EFE6'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '707', shadeName: 'Cozy', colorHex: '#E6D6C5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '708', shadeName: 'Abalone', colorHex: '#DCD8D0'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '709', shadeName: 'Peach Whisper', colorHex: '#F4DFD0'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '710', shadeName: 'Lime Yellow', colorHex: '#DDE675'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '711', shadeName: 'Marsh Marigold', colorHex: '#F2B830'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '712', shadeName: 'Classic Orange', colorHex: '#E8702A'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '713', shadeName: 'Bubble Gum', colorHex: '#F29EB8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '714', shadeName: 'Natural Paprika', colorHex: '#B8503C'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '715', shadeName: 'Candy Pink', colorHex: '#F3B8CA'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '716', shadeName: 'Carnival Pink', colorHex: '#D85A84'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '717', shadeName: 'Classical', colorHex: '#DDD6CE'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '718', shadeName: 'Lilac Time', colorHex: '#CBB8D9'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '719', shadeName: 'Purple Passion', colorHex: '#6E4C85'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '720', shadeName: 'Lime Light', colorHex: '#DCE89E'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '721', shadeName: 'Light Green', colorHex: '#99CC99'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '722', shadeName: 'Woven Green', colorHex: '#84A98C'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '723', shadeName: 'Emerald Isle', colorHex: '#3B7A57'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '724', shadeName: 'Gumbed Green', colorHex: '#2F5D46'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '725', shadeName: 'Blue Haze', colorHex: '#B6C9D8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '726', shadeName: 'Light Grey', colorHex: '#C8CDD0'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '727', shadeName: 'Steel Grey', colorHex: '#7A8086'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '728', shadeName: 'Honey Frost', colorHex: '#EAE0C8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '729', shadeName: 'Sea Blue', colorHex: '#639BB5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '730', shadeName: 'Regatta Bay', colorHex: '#356085'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '731', shadeName: 'Terrace Stone', colorHex: '#B5AC9E'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '732', shadeName: 'Onyx', colorHex: '#36393C'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '733', shadeName: 'Diyar', colorHex: '#8D5524'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '734', shadeName: 'Polish Brown', colorHex: '#7A4329'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '700', shadeName: 'White', colorHex: '#FFFFFF'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Eggshell Finish Matt Enamel', cat: 'Enamel', shadeCode: '735', shadeName: 'Black', colorHex: '#1C1C1C'),

    // =========================================================================
    // 5. GOBI'S GOLD EXTERIOR WEATHER GUARD
    // =========================================================================
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5000', shadeName: 'White', colorHex: '#FFFFFF'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5002', shadeName: 'Ash White', colorHex: '#E5E7E9'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5003', shadeName: 'Autumn Stone', colorHex: '#D0C0A8'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5004', shadeName: 'Avocado', colorHex: '#7F9C59'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5006', shadeName: 'Beige', colorHex: '#D8C7AE'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5007', shadeName: 'Cameo', colorHex: '#DFC7B0'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5010', shadeName: 'Golden Needles', colorHex: '#E0C070'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5014', shadeName: 'Mossey Fern', colorHex: '#7B9468'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5015', shadeName: 'Tile Red', colorHex: '#A94438'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5016', shadeName: 'Off White', colorHex: '#F7F5EE'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5018', shadeName: 'Autumn Red', colorHex: '#9E3E33'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5019', shadeName: 'Rogue Pink', colorHex: '#D99BA5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5020', shadeName: 'Roof Tile', colorHex: '#B0533A'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5021', shadeName: 'Sand Stone', colorHex: '#D1BC9B'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5023', shadeName: 'Stone Grey', colorHex: '#9C9E9A'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5024', shadeName: 'Sugar Cane', colorHex: '#E8DFC5'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5025', shadeName: 'Sweet Peach', colorHex: '#F3C7AD'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5026', shadeName: 'Tea Rose', colorHex: '#E6B2AA'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5027', shadeName: 'Terracotta', colorHex: '#C66647'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5055', shadeName: 'Sweet Jewel', colorHex: '#D9B6C9'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5056', shadeName: 'Red Haze', colorHex: '#B95858'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5057', shadeName: 'Flame Orange', colorHex: '#E35D2D'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5058', shadeName: 'Polish Brown', colorHex: '#7A4329'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5059', shadeName: 'Sahara Sand', colorHex: '#D9B98C'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5060', shadeName: 'Goose Wing', colorHex: '#B8B9B3'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5061', shadeName: 'Charcoal', colorHex: '#3E4246'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5062', shadeName: 'Founder Blue', colorHex: '#3C5A78'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5064', shadeName: 'Evening Shadow', colorHex: '#8C969E'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5065', shadeName: 'Bright Red', colorHex: '#C0392B'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5066', shadeName: 'Tile Red (Dark)', colorHex: '#8F362C'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5067', shadeName: 'Porcelain Peach', colorHex: '#EDD3C4'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5068', shadeName: 'Michigan Lakes', colorHex: '#5C829B'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5069', shadeName: 'Desert Dawn', colorHex: '#E9BA94'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5070', shadeName: 'Indigo Sea', colorHex: '#3A5374'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5072', shadeName: 'Clay', colorHex: '#B69A84'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5073', shadeName: 'Grey White', colorHex: '#E5E6E1'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5074', shadeName: 'Pottery Clay', colorHex: '#B37356'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5075', shadeName: 'Blue Lake', colorHex: '#7EA5BD'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5076', shadeName: 'Cinnamon', colorHex: '#9A634A'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5077', shadeName: 'Dove Grey', colorHex: '#B6BBC0'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5078', shadeName: 'Camel Coat', colorHex: '#C19A6B'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5079', shadeName: 'Sky Grey', colorHex: '#C3CDD4'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5080', shadeName: 'Wirework Grey', colorHex: '#7A8187'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5081', shadeName: 'Blue Green', colorHex: '#4E8C88'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5082', shadeName: 'Forest Green', colorHex: '#2F6644'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5083', shadeName: 'Jade', colorHex: '#5CA48A'),
    ShadeCardEntry(series: 'Gold', categoryLabel: 'Gold Exterior Weather Guard', cat: 'Weather', shadeCode: '5084', shadeName: 'Beaver', colorHex: '#846E5C'),

    // =========================================================================
    // 6. HERCULES SERIES (Emulsion, Enamel, Weather Guard)
    // =========================================================================
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Emulsion', cat: 'Emulsion', shadeCode: 'H-01', shadeName: 'White', colorHex: '#FFFFFF'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Emulsion', cat: 'Emulsion', shadeCode: 'H-02', shadeName: 'Off White', colorHex: '#F7F5EE'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Emulsion', cat: 'Emulsion', shadeCode: 'H-03', shadeName: 'Ash White', colorHex: '#E5E7E9'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Emulsion', cat: 'Emulsion', shadeCode: 'H-04', shadeName: 'Magnolia', colorHex: '#F3EAD8'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Emulsion', cat: 'Emulsion', shadeCode: 'H-05', shadeName: 'Cream', colorHex: '#F2E2B6'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Emulsion', cat: 'Emulsion', shadeCode: 'H-06', shadeName: 'Peach', colorHex: '#F6C2A3'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Emulsion', cat: 'Emulsion', shadeCode: 'H-07', shadeName: 'Light Green', colorHex: '#99CC99'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Emulsion', cat: 'Emulsion', shadeCode: 'H-08', shadeName: 'Sky Blue', colorHex: '#8CC4E8'),

    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Enamel', cat: 'Enamel', shadeCode: 'HE-01', shadeName: 'White', colorHex: '#FFFFFF'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Enamel', cat: 'Enamel', shadeCode: 'HE-02', shadeName: 'Off White', colorHex: '#F7F5EE'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Enamel', cat: 'Enamel', shadeCode: 'HE-03', shadeName: 'Black', colorHex: '#1C1C1C'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Enamel', cat: 'Enamel', shadeCode: 'HE-04', shadeName: 'Signal Red', colorHex: '#C0392B'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Enamel', cat: 'Enamel', shadeCode: 'HE-05', shadeName: 'Royal Green', colorHex: '#195432'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Enamel', cat: 'Enamel', shadeCode: 'HE-06', shadeName: 'Golden Yellow', colorHex: '#F39C12'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Enamel', cat: 'Enamel', shadeCode: 'HE-07', shadeName: 'Dark Brown', colorHex: '#4E3022'),

    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Weather Guard', cat: 'Weather', shadeCode: 'HW-01', shadeName: 'White', colorHex: '#FFFFFF'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Weather Guard', cat: 'Weather', shadeCode: 'HW-02', shadeName: 'Off White', colorHex: '#F7F5EE'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Weather Guard', cat: 'Weather', shadeCode: 'HW-03', shadeName: 'Ash White', colorHex: '#E5E7E9'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Weather Guard', cat: 'Weather', shadeCode: 'HW-04', shadeName: 'Sand Stone', colorHex: '#D1BC9B'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Weather Guard', cat: 'Weather', shadeCode: 'HW-05', shadeName: 'Terracotta', colorHex: '#C66647'),
    ShadeCardEntry(series: 'Hercules', categoryLabel: 'Hercules Weather Guard', cat: 'Weather', shadeCode: 'HW-06', shadeName: 'Dove Grey', colorHex: '#B6BBC0'),

    // =========================================================================
    // 7. PROTECTOR SERIES (Emulsion, Weather Guard, Sealer/Primer)
    // =========================================================================
    ShadeCardEntry(series: 'Protector', categoryLabel: 'Protector Emulsion', cat: 'Emulsion', shadeCode: 'PR-01', shadeName: 'White', colorHex: '#FFFFFF'),
    ShadeCardEntry(series: 'Protector', categoryLabel: 'Protector Emulsion', cat: 'Emulsion', shadeCode: 'PR-02', shadeName: 'Off White', colorHex: '#F7F5EE'),
    ShadeCardEntry(series: 'Protector', categoryLabel: 'Protector Emulsion', cat: 'Emulsion', shadeCode: 'PR-03', shadeName: 'Ash White', colorHex: '#E5E7E9'),
    ShadeCardEntry(series: 'Protector', categoryLabel: 'Protector Emulsion', cat: 'Emulsion', shadeCode: 'PR-04', shadeName: 'Cream', colorHex: '#F2E2B6'),
    ShadeCardEntry(series: 'Protector', categoryLabel: 'Protector Weather Guard', cat: 'Weather', shadeCode: 'PRW-01', shadeName: 'White', colorHex: '#FFFFFF'),
    ShadeCardEntry(series: 'Protector', categoryLabel: 'Protector Weather Guard', cat: 'Weather', shadeCode: 'PRW-02', shadeName: 'Off White', colorHex: '#F7F5EE'),
    ShadeCardEntry(series: 'Protector', categoryLabel: 'Protector Weather Guard', cat: 'Weather', shadeCode: 'PRW-03', shadeName: 'Sand Stone', colorHex: '#D1BC9B'),
    ShadeCardEntry(series: 'Protector', categoryLabel: 'Protector Sealer / Primer', cat: 'Emulsion', shadeCode: 'PRS-01', shadeName: 'White Sealer', colorHex: '#FAFAFA'),
    ShadeCardEntry(series: 'Protector', categoryLabel: 'Protector Sealer / Primer', cat: 'Emulsion', shadeCode: 'PRS-02', shadeName: 'Acrylic Primer', colorHex: '#F5F5F5'),
  ];
}

