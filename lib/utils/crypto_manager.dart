import 'dart:convert';

import 'package:e2e_period_tracking/models/tracking_day.dart';
import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CryptoManager {
  static const AESMode algorithm = AESMode.cbc;
  static const testString = 'e2e_period_tracking';
  static const testStringPrefsKey = 'testStringKey';

  static get encryptedTestString => instance.encrypt(text: testString);

  static var aesPassword = '';

  CryptoManager._();
  static final CryptoManager instance = CryptoManager._();

  String? encrypt({required String text, String? key}) {
    final myKey = aesPassword.isNotEmpty ? aesPassword : key;
    if (myKey == null) {
      return null;
    }

    final keyObject = Key.fromUtf8(myKey);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(keyObject, mode: algorithm));
    final encrypted = encrypter.encrypt(text, iv: iv);

    return encrypted.base64;
  }

  String? decrypt({required String text, String? key}) {
    final myKey = aesPassword.isNotEmpty ? aesPassword : key;
    if (myKey == null) {
      return null;
    }

    final keyObject = Key.fromUtf8(myKey);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(keyObject, mode: algorithm));

    try {
      final decrypted = encrypter.decrypt64(text, iv: iv);
      return decrypted;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> testEncryption(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final encrypted = prefs.getString(testStringPrefsKey);
    if (encrypted == null) {
      return false;
    }

    final decrypted = decrypt(text: encrypted, key: key);
    return decrypted == testString;
  }

  static String getTrackingDayKeyMap(DateTime date) {
    return DateFormat("dd-MM-yyyy").format(date);
  }

  Future<Map<String, TrackingDay>> getTrackingDays() async {
    final prefs = await SharedPreferences.getInstance();
    final encrypted = prefs.getString('trackingDays');
    if (encrypted == null) {
      return {};
    }

    final decrypted = decrypt(text: encrypted);
    if (decrypted == null) {
      return {};
    }

    final jsonData = Map<String, dynamic>.from(
        json.decode(decrypted) as Map<String, dynamic>);
    return jsonData.map((key, value) => MapEntry(
        key, TrackingDay()..fromJson(Map<String, dynamic>.from(value))));
  }

  Future<void> upsertTrackingDay(TrackingDay trackingDay) async {
    if (trackingDay.date == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    var trackingDaysMap = await getTrackingDays();
    trackingDaysMap[CryptoManager.getTrackingDayKeyMap(trackingDay.date!)] =
        trackingDay;
    final trackingDays = json.encode(trackingDaysMap);

    final encrypted = encrypt(text: trackingDays);
    if (encrypted == null) {
      return;
    }

    await prefs.setString('trackingDays', encrypted);
  }
}
