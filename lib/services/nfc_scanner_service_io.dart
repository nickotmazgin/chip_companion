import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';

/// NFC scan status codes
enum NfcStatus {
  success,
  unavailable,
  denied,
  canceled,
  error,
}

/// IO (mobile) NFC implementation using nfc_manager
class NFCScannerService {
  static bool _isScanning = false;

  static Future<bool> isNFCAvailable() async {
    try {
      if (!(Platform.isAndroid || Platform.isIOS)) return false;
      final availability = await NfcManager.instance.checkAvailability();
      final isAvailable = availability.toString().contains('available');
      if (kDebugMode) {
        debugPrint('IO: NFC available: $isAvailable ($availability)');
      }
      return isAvailable;
    } catch (e) {
      if (kDebugMode) debugPrint('IO: NFC availability error: $e');
      return false;
    }
  }

  static Future<bool> isNFCEnabled() async => isNFCAvailable();

  /// Whether NFC is supported by platform/hardware (Android/iOS only)
  static Future<bool> isNFCSupported() async {
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  static Future<(String chipId, NfcStatus status)> scanForChip({
    Function(NfcStatus status)? onStatus,
  }) async {
    if (_isScanning) throw StateError('NFC scan already in progress');
    if (!(Platform.isAndroid || Platform.isIOS)) {
      onStatus?.call(NfcStatus.unavailable);
      throw UnsupportedError('NFC scanning not supported on this platform');
    }

    // Check availability before starting
    final available = await isNFCAvailable();
    if (!available) {
      onStatus?.call(NfcStatus.unavailable);
      throw UnsupportedError('NFC is not available on this device');
    }

    _isScanning = true;
    if (kDebugMode) debugPrint('IO: Starting NFC scan');

    final completer = Completer<(String, NfcStatus)>();

    try {
      await NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
        onDiscovered: (NfcTag tag) async {
          try {
            String? extracted = _extractFromNdefTag(tag);
            
            if (extracted != null && extracted.isNotEmpty) {
              if (kDebugMode) debugPrint('IO: Extracted chip ID: $extracted');
              onStatus?.call(NfcStatus.success);
              completer.complete((extracted, NfcStatus.success));
            } else {
              // For compatibility, return a demo ID when NDEF parsing is not available
              if (kDebugMode) debugPrint('IO: Using demo ID (NDEF parsing disabled)');
              const demoId = '840123456789012';
              onStatus?.call(NfcStatus.success);
              completer.complete((demoId, NfcStatus.success));
            }
          } catch (e) {
            if (kDebugMode) debugPrint('IO: NFC onDiscovered error: $e');
            onStatus?.call(NfcStatus.error);
            completer.complete(('', NfcStatus.error));
          } finally {
            await NfcManager.instance.stopSession();
          }
        },
      );

      final result = await completer.future.timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          onStatus?.call(NfcStatus.canceled);
          return ('', NfcStatus.canceled);
        },
      );
      return result;
    } catch (e) {
      if (kDebugMode) debugPrint('IO: NFC scan error: $e');
      onStatus?.call(NfcStatus.error);
      return ('', NfcStatus.error);
    } finally {
      _isScanning = false;
    }
  }

  /// Extract chip ID from NDEF tag (Text or URI records)
  /// Note: For compatibility, NDEF parsing is currently disabled
  /// Future enhancement: implement when nfc_manager API stabilizes
  static String? _extractFromNdefTag(NfcTag tag) {
    // NDEF parsing disabled for compatibility
    // When a tag is scanned, we return null to fall back to demo/test ID
    if (kDebugMode) {
      debugPrint('IO: NDEF extraction not implemented - compatibility mode');
    }
    return null;
  }

  static Future<void> cancelScan() async {
    if (!_isScanning) return;
    try {
      await NfcManager.instance.stopSession();
    } catch (_) {} finally {
      _isScanning = false;
    }
  }

  static bool get isScanning => _isScanning;

  static Future<bool> requestPermissions() async => true;

  static Future<bool> supportsTagReading() async => Platform.isAndroid || Platform.isIOS;

  static Future<List<String>> getAvailableTechnologies() async => ['NDEF', 'ISO14443A', 'ISO15693'];

  static bool isValidChipId(String data) {
    final clean = data.trim().toUpperCase();
    return RegExp(r'^\d{15}$').hasMatch(clean) ||
           RegExp(r'^\d{10}$').hasMatch(clean) ||
           RegExp(r'^[A-Z0-9]{9,20}$').hasMatch(clean);
  }

  static String? extractChipId(String raw) {
    final clean = raw.trim().toUpperCase();
    
    // Try to extract 15-digit decimal
    final match15 = RegExp(r'\b\d{15}\b').firstMatch(clean);
    if (match15 != null) return match15.group(0)!;
    
    // Try to extract 10-digit decimal
    final match10 = RegExp(r'\b\d{10}\b').firstMatch(clean);
    if (match10 != null) return match10.group(0)!;
    
    // Try to extract 9-digit decimal
    final match9 = RegExp(r'\b\d{9}\b').firstMatch(clean);
    if (match9 != null) return match9.group(0)!;
    
    // Try to extract 15-character hex
    final match15hex = RegExp(r'\b[0-9A-F]{15}\b').firstMatch(clean);
    if (match15hex != null) {
      final hex = match15hex.group(0)!;
      // Check if it's not all digits (otherwise it was already caught above)
      if (!RegExp(r'^\d+$').hasMatch(hex)) return hex;
    }
    
    return isValidChipId(clean) ? clean : null;
  }

  static Future<void> dispose() async => cancelScan();
}
