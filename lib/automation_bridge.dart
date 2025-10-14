import 'package:flutter/foundation.dart';

/// Simple global automation bridge for web-driven E2E/screenshot control.
/// These callbacks are no-ops by default and are wired by HomeScreen when mounted.
class AutomationBridge {
  static void Function(String chipId)? setChipId;
  static VoidCallback? validateChip;
  static VoidCallback? focusInput;

  static void debugLog(String message) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('🤖 Automation: $message');
    }
  }
}
