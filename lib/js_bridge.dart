import 'package:flutter/material.dart';
import 'package:chip_companion/services/settings_service.dart';

// Use conditional imports to provide a web implementation that uses dart:js
// and a no-op stub for non-web platforms.
import 'package:chip_companion/js_bridge_impl_stub.dart'
  if (dart.library.js) 'package:chip_companion/js_bridge_impl_web.dart' as impl;

void setupJavaScriptBridge(
  SettingsService settingsService,
  GlobalKey<NavigatorState> navigatorKey, {
  Function(int)? onTabNavigation,
}) =>
    impl.setupJavaScriptBridge(
      settingsService,
      navigatorKey,
      onTabNavigation: onTabNavigation,
    );
