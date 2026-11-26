# Babur & Brothers Paint ERP — Work & Change History

**Project Path:** `c:\Users\Haseeb\Desktop\babur_brothers_paint_erp`  
**Branch:** `main`  
**Remote:** `https://github.com/Haseeb-ML/babur-paint-erp.git`

---

## 1. Authentication & User Management Updates
- Removed the **Register** tab/page from login flow (login-only screen).
- Removed the **Cashier** role option.
- Added **Change Username** alongside **Change Password** with local storage (`SharedPreferences`) and Firebase sync.
- Built and verified release APK (`9b7b520`).

---

## 2. Camera Barcode Scanner & Gobi's Category / Shade-Wise Stock-In (`8e27ce3`)
Implemented based on client requirements and official Gobi's Paints shade card PDFs (`C:\Users\Haseeb\Downloads\paint`):

- **Dependencies & Permissions:**
  - Added `mobile_scanner: ^7.5.0` to `pubspec.yaml`.
  - Added `<uses-permission android:name="android.permission.CAMERA" />` to `android/app/src/main/AndroidManifest.xml`.
- **Official Shade Cards (`lib/data/gobis_shade_cards.dart`):**
  - Added `ShadeCardEntry` and `GobisShadeCards` covering:
    - **Gold Series:** *Gold Luxurious Wall Emulsion* (`1400 White` – `1473 Cameo`), *Gold High Gloss Synthetic Enamel & Metallic* (`7001 White` – `7058 Dark Grey`), *Gold Aqueous Matt Finish* (`400 White` – `442 Black`), *Gold Eggshell Finish Matt Enamel* (`700 White` – `735 Black`), *Gold Exterior Weather Guard* (`5000 White` – `5084 Beaver`).
    - **Hercules Series:** *Hercules Emulsion*, *Hercules Enamel*, *Hercules Weather Guard*.
    - **Protector Series:** *Protector Emulsion*, *Protector Weather Guard*, *Protector Sealer / Primer*.
- **Model & Controller (`lib/models/erp_models.dart`, `lib/state/erp_controller.dart`):**
  - Added `shadeCode` and `shadeName` fields to `PaintProduct` (`toMap`, `fromMap`, constructor).
  - Updated `saveOrUpdateProduct` to support `barcode`, `shadeCode`, and `shadeName`.
  - Added `scanStockIn(String barcode, {int qty = 1})` for continuous stock-in scanning.
  - Added `linkBarcodeAndAddStock(...)` to link unknown barcodes to existing products or create new Series / Category / Shade-wise inventory items.
- **Scanner & Inventory UI (`lib/ui/modals/erp_modals.dart`, `lib/ui/views/erp_views.dart`):**
  - Upgraded `openBarcodeScannerModal` with live `MobileScanner` camera view, torch toggle, manual/USB barcode input fallback, `POS Billing` / `Stock-In (Add Qty)` mode switcher, quantity stepper (`x1`, `x4`, `x8`, `x12`), and inline new-barcode linking to official shade cards.
  - Added prominent **Scan Stock-In** button in Inventory header and shade badges (`#shadeCode shadeName`) on inventory cards.
  - Added camera barcode scan button and Shade `#` / Shade Colour fields in `openProductModal`.

---

## 3. POS Billing & Percentage Discount Improvements (`36bfdc3`)
- **Prominent POS Barcode Scan (`lib/ui/views/erp_views.dart`):**
  - Moved **Scan Barcode** (`btnScanBarcode`) and **+ Add Stock** (`btnNewStock`) buttons out of the horizontally scrollable category chip row to a dedicated quick-action row directly above the POS search bar.
- **Percentage Discount in POS Cart (`lib/ui/modals/erp_modals.dart`):**
  - Added `%` / `Rs` mode toggle and quick percentage chips (`0%`, `2%`, `5%`, `10%`, `15%`) in `openPosCartModal`, calculating rupee discount and Grand Total live (`004.ogg` requirement).

---

## 4. Firebase & Cloud Sync Verification
- **Sync Architecture (`lib/services/cloud_sync.dart`, `lib/state/erp_controller.dart`, `lib/main.dart`):**
  - `connectCloud()` initializes Firebase and signs in anonymously via `FirebaseAuth.instance.signInAnonymously()`.
  - `saveState()` writes locally to `SharedPreferences` and triggers `_pushToCloud()` after a 3-second debounce.
  - `CloudSync.push()` stores the full shop JSON backup (`exportBackupJson()`) in Cloud Firestore at **`shops/babur_brothers`** (`json` and `updatedAt` fields), where all `invoices`, `inventory`, `customers`, `suppliers`, `painters`, `cashLedger`, and `users` are persisted.
  - `lib/firebase_options.dart` is configured for **Android** and **Web** (Windows desktop runs offline-only).
- **Vercel Note:** No app data is sent to Vercel; `vercel.json` in the repository root is only a Flutter Web hosting/build configuration.

---

## 5. Verification, Tests & Release APK Build
- **`flutter analyze lib/`:** `No issues found!`
- **`flutter test` (`test/widget_test.dart`):** `4/4` tests passed:
  1. `Full ERP Modules, 3 Languages, Themes & Zero Overflow Test`
  2. `Authentication: Register, Login, and Logout flow test`
  3. `Barcode Modals Zero-Overflow Test on Mobile Viewport`
  4. `Category & Shade-Wise Barcode Stock-In Flow Test`
- **Release APK Build (`flutter build apk --release`):**
  - Built `build\app\outputs\flutter-apk\app-release.apk` (`73.7 MB`).
  - Copied to `babur_brothers_paint_erp_latest.apk` in project root.

---

## 6. Dummy Test Barcodes PDF Note
- `GLD-IE-G` (`id: 203` in `lib/data/gobis_initial_data.dart`) and `896400010001` are matched directly when present in inventory.
- `CR-RED-G` and `BB-2K-W-G` are not in `gobis_initial_data.dart` by default; scanning them in **Inventory → Scan Stock-In** (or editing a product's `barcode` field) links them permanently so **POS Billing** recognizes them automatically.


---

## 7. Invoice Cleanups, Partial Payments & Credit Khata (`2a528bf`, `9c5c25d`, `5422565`)
Based on client feedback in `C:\Users\Haseeb\Downloads\new fixes`:
- **Clean Invoice Branding (`lib/services/invoice_pdf_service.dart`, `lib/ui/modals/erp_modals.dart`):**
  - Simplified A4 PDF, 80mm Thermal Receipt, Invoice Dialog, and WhatsApp share text headers to **`BABUR & BROTHERS`** / **`بابر اینڈ برادرز`** (removed `HARDWARE & PAINT STORE`, `ہارڈویئر اینڈ پینٹ سٹور`, and `Official Authorized Dealer: Gobi's Paints Pakistan`).
  - Replaced `TAX INVOICE` / `UDHAR` badge with **`INVOICE`** and **`PAID`** or **`DUE / CREDIT`**.
- **Partial Payment & Running Credit (`lib/models/erp_models.dart`, `lib/state/erp_controller.dart`, `lib/ui/views/invoices_screen.dart`):**
  - Added `paidAmount`, `dueAmount`, and `paymentStatusLabel` (`PAID` when `dueAmount <= 0.01`, otherwise `DUE / CREDIT`) to `InvoiceRecord`.
  - Added **Paid Now (Rs.)** + **50%** quick button in `openPosCartModal`, recording cash in `cashLedger` and remaining balance in customer khata (`UdharCustomer`).
  - Added **Receive Payment** button on due invoices in `AllBills & Invoices` (`receiveInvoicePayment`).
  - Renamed `Udhar Total` / `Udhar` filter labels to **`Credit Total`** / **`Credit`** in `lib/ui/views/invoices_screen.dart`.

---

## 8. Multi-Product Supplier Purchase Bills, Table PDF & Print (`9705b50`, `95f5b75`, `a298db2`)
- **Supplier Model & Controller (`lib/models/erp_models.dart`, `lib/state/erp_controller.dart`):**
  - Added `List<CartItem> items` to `SupplierAccount` and `saveOrUpdateSupplier`.
- **Multi-Product Purchase Form (`lib/ui/modals/erp_modals.dart`):**
  - Upgraded `openSupplierModal` with a **Purchase Products** builder (pick from Inventory or type product name, Qty, Rate, and **+ Add** multiple products) that auto-calculates `Total Bill` and supply summary.
- **Supplier Voucher PDF & Print (`lib/services/invoice_pdf_service.dart`, `lib/ui/views/erp_views.dart`):**
  - Added `generateSupplierPdf`, `shareSupplierPdf`, and `printSupplierPdf` with **`BABUR & BROTHERS`** header, **`# | PRODUCT DESCRIPTION | QTY | RATE | AMOUNT`** table, and Total / Paid / Remaining Payable.
  - Added **Print** and **Share PDF** buttons on every Supplier card, plus a direct **Suppliers** shortcut under **All Paint Store ERP Modules** on the Dashboard.

---

## 9. All Paint Series Scanner, POS Scan-to-Cart & Scan Pause Fixes (`3791480`, `06aab1f`, `036fe53`)
- **Expanded Paint Series (`lib/data/gobis_shade_cards.dart`, `lib/ui/modals/erp_modals.dart`):**
  - Added `Carman NC`, `Silverline`, `BigBang 2K`, `Tusker 2K`, `NC Thinner`, `Stoving`, `Epoxy & Ind`, `Timberline`, and `Ancillaries` alongside `Gold`, `Hercules`, and `Protector` (12 series total), plus a **Custom Shade / Name** input field.
- **POS Barcode Matching & Inline Status (`lib/state/erp_controller.dart`, `lib/ui/modals/erp_modals.dart`):**
  - Updated `findProductByBarcode` to normalize whitespace, case, and leading zeros (`08964...` vs `8964...`).
  - Added inline `Out of Stock` and `Barcode not linked in stock` cards with 1-tap **"Link This Barcode in Stock-In"** inside `openBarcodeScannerModal`.
- **Prevented Auto-Increment While Camera Aimed (`lib/ui/modals/erp_modals.dart`):**
  - Added `scanPaused` state to `MobileScanner.onDetect` with a **"Scanned! Tap to Scan Next"** overlay button so each can scans once instead of repeating `1 -> 3, 4, 5, 6`.
- **Verification & APK Output:**
  - `flutter analyze lib/`: **No issues found!**
  - `flutter test` (`test/widget_test.dart`): **7/7 tests passed!**
  - `flutter test test/barcode_module_test.dart`: **1/1 dedicated barcode module test passed!**
  - Built release APK (`73.9 MB`) and saved to **`C:\Users\Haseeb\Desktop\APP\babur.apk`**.

---

## 10. Client Feedback Investigation (`C:\Users\Haseeb\Downloads\babur`)
- Checked client voice notes and screenshots (`202689234036` vs `402689234036` on Gobi's `105-030 QTR` tin):
  - Confirmed `Barcode not linked in stock` appears when a product's barcode has not yet been linked in Stock-In, and also observed varying 2-digit prefixes (`20...` vs `40...`) on curved Gobi's tins.

---

## 11. Multi-Product Billing, Continuous Scanner & WhatsApp 27.7 MB APK
- **Client Voice Notes Analysis (`C:\Users\Haseeb\Downloads\babur client`):**
  - Analyzed 3 client audio notes: client reported 77.5 MB file stuck on WhatsApp upload, multi-item billing (1st, 2nd, 3rd, 4th, 5th product additions) felt restricted in billing, and confusion over WhatsApp "live track / monitor" system warning.
- **Smart Continuous Multi-Item Barcode Scanner (`lib/ui/modals/erp_modals.dart`):**
  - Replaced blocking dark overlay with non-blocking smart debouncing: same barcode is debounced for 2.2 seconds (prevents 1 -> 6 jump), while different cans scan **instantly** without needing screen taps.
  - Added visual green flash border and feedback badge on scan detection.
  - Added live **Current Bill Items (موجودہ بل کے آئٹمز)** list directly inside the Barcode Scanner modal with product titles, prices, live quantity steppers `[-] {qty} [+]`, and delete buttons, plus live Total Bill price.
- **Cart Modal & POS View Enhancements (`lib/ui/modals/erp_modals.dart`, `lib/ui/views/erp_views.dart`):**
  - Added quick **"+ Scan Barcode"** and **"+ Add from List"** buttons inside the Cart / Checkout modal.
  - Added compact `✓ (qty)` badge on POS catalog product cards and persistent bottom checkout bar when cart is not empty.
- **Lightweight Split APK Build:**
  - Built with `flutter build apk --split-per-abi`, reducing APK size from 77.5 MB to **27.7 MB** (`app-arm64-v8a-release.apk`).
  - Saved to **`C:\Users\Haseeb\Desktop\APP\babur.apk`** for instant WhatsApp sharing.
- **Verification:**
  - `flutter analyze lib/`: **No issues found!**
  - `flutter test`: **8/8 tests passed!** (including `barcode_module_test.dart` and `widget_test.dart`).

