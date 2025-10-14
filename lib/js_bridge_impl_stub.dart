import 'package:flutter/material.dart';
import 'package:chip_companion/services/settings_service.dart';

void setupJavaScriptBridge(
  SettingsService settingsService,
  GlobalKey<NavigatorState> navigatorKey, {
  Function(int)? onTabNavigation,
}) {
  // No-op on non-web platforms
}
