# Babur & Brothers Hardware – Paint Shop ERP

Simple, offline-first Flutter app (Android + Web) for a paint & hardware shop.
Bhera Road, Nawaz Plaza, Malikwal · 03000952862 · Babur.Brothers369@gmail.com

## Features
- **3 languages** with instant switch: اردو (RTL), Roman Urdu, English
- **Themes**: 5 colour palettes + Light / Dark mode
- **Offline first**: data saved on the device (SharedPreferences), works without internet
- **Mobile responsive**: no overflow (yellow/black stripe) issues, tested at 380px width
- **Edit ✏️ / Delete 🗑️** buttons on every list item

## Modules
1. **Dashboard**: sales, stock and khata summary
2. **POS & Billing**: cart, invoice with shop logo and print
3. **Color Mixing Studio**: 94 Hercules shades with hex colour and pigment formula
4. **Stock & Godown**: add, edit, delete and low-stock alerts
5. **Khata & Udhaar**: customers, suppliers and cash ledger
6. **Painter Loyalty**: commission and tokens

## Preloaded data (Gobi's Paints)
Decorative (Premium Plus, Silver Line, Gold Series, Hercules, Special 81), Timberline (Sept 2026 prices), Carman NC / PU 2K, Silverline NC, BigBang 2K, Tusker 2K, thinners, stoving / epoxy / industrial coatings, and ancillaries.

## Project structure
```
lib/
  main.dart                  App shell, header, bottom navigation
  data/gobis_initial_data.dart  Products and 94 shades
  l10n/app_strings.dart      Urdu / Roman Urdu / English texts
  models/erp_models.dart     Data models
  state/erp_controller.dart  State and offline storage
  theme/app_themes.dart      Palettes, light/dark
  ui/views/erp_views.dart    Screens
  ui/modals/erp_modals.dart  Add/Edit dialogs
assets/images/logo.jpeg      Shop logo
```

## Run
```bash
flutter pub get
flutter run -d chrome                                   # web
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0 --release   # open on phone via LAN IP
flutter test                                            # tests
flutter build apk --release                             # Android APK
```
APK output: `build/app/outputs/flutter-apk/app-release.apk`

> The APK is signed with the debug key. Create a release keystore before publishing to Play Store.
