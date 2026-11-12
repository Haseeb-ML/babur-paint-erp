import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

/// Firebase backup/restore of the whole shop data (one Firestore document).
/// Local (offline) storage stays the primary source; cloud is a sync layer.
class CloudSync {
  static const String _shopId = 'babur_brothers';
  static bool ready = false;

  static DocumentReference<Map<String, dynamic>> get _doc =>
      FirebaseFirestore.instance.collection('shops').doc(_shopId);

  /// Safe to call at startup: never throws, app keeps working offline.
  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 10));

      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance
            .signInAnonymously()
            .timeout(const Duration(seconds: 10));
      }
      ready = true;
    } catch (_) {
      ready = false;
    }
  }

  /// Uploads the JSON backup. Works offline too: Firestore queues the write.
  static Future<bool> push(String json, int updatedAtMs) async {
    if (!ready) return false;
    try {
      await _doc
          .set({'json': json, 'updatedAt': updatedAtMs})
          .timeout(const Duration(seconds: 15));
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns {json, updatedAt} or null when nothing is stored / offline.
  static Future<({String json, int updatedAt})?> pull() async {
    if (!ready) return null;
    try {
      final snap = await _doc
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 12));
      final data = snap.data();
      if (data == null || data['json'] is! String) return null;
      return (
        json: data['json'] as String,
        updatedAt: (data['updatedAt'] as num?)?.toInt() ?? 0
      );
    } catch (_) {
      return null;
    }
  }
}

