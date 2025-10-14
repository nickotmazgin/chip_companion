import 'dart:async';
import 'package:flutter/foundation.dart';

/// NFC scan status codes
enum NfcStatus {
  success,
  unavailable,
  denied,
  canceled,
  error,
}

/// Web-safe NFC service: provides no-op availability and a stub scan implementation on web.
class NFCScannerService {
  static bool _isScanning = false;
  static final Set<String> _loggedOnce = <String>{};
  static void _logOnce(String key, String message) {
    if (!kDebugMode) return;
    if (_loggedOnce.add(key)) {
      debugPrint(message);
    }
  }

  static Future<bool> isNFCAvailable() async {
    _logOnce('web_nfc_not_available', 'Web: NFC not available (web stub)');
    return false;
  }

  static Future<bool> isNFCEnabled() async {
    _logOnce('web_nfc_not_enabled', 'Web: NFC not enabled (web stub)');
    return false;
  }

  static Future<bool> isNFCSupported() async => false;

  static Future<(String chipId, NfcStatus status)> scanForChip({
    Function(NfcStatus status)? onStatus,
  }) async {
    if (_isScanning) throw StateError('NFC scan already in progress');
    _isScanning = false;
    _logOnce('web_nfc_unsupported', 'Web: NFC scanning is not supported on web platform');
    onStatus?.call(NfcStatus.unavailable);
    throw UnsupportedError('NFC scanning is not supported on web. Please use the mobile app to scan NFC tags.');
  }

  static Future<void> cancelScan() async {
    _isScanning = false;
  }

  static bool get isScanning => _isScanning;

  static Future<bool> requestPermissions() async => false;
  static Future<bool> supportsTagReading() async => false;

  static List<String> getAvailableTechnologiesSync() => const ['NDEF'];
  static Future<List<String>> getAvailableTechnologies() async => getAvailableTechnologiesSync();

  static bool isValidChipId(String data) {
    final clean = data.trim().toUpperCase();
    return RegExp(r'^\d{15}$').hasMatch(clean) ||
           RegExp(r'^\d{10}$').hasMatch(clean) ||
           RegExp(r'^[A-Z0-9]{9,20}$').hasMatch(clean);
  }

  static String? extractChipId(String raw) {
    final clean = raw.trim().toUpperCase();
    for (final re in [
      RegExp(r'\b\d{15}\b'),
      RegExp(r'\b\d{10}\b'),
      RegExp(r'\b[A-Z0-9]{9,20}\b'),
    ]) {
      final m = re.firstMatch(clean);
      if (m != null) return m.group(0)!;
    }
    return isValidChipId(clean) ? clean : null;
  }

  static Future<void> dispose() async => cancelScan();
}
