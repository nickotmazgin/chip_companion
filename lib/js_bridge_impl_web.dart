import 'package:js/js_util.dart' as js_util;
import 'package:js/js.dart' show allowInterop;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:chip_companion/screens/settings_screen.dart';
import 'package:chip_companion/screens/help_screen.dart';
import 'package:chip_companion/screens/about_screen.dart';
import 'package:chip_companion/screens/glossary_screen.dart';
import 'package:chip_companion/screens/support_screen.dart';
import 'package:chip_companion/services/settings_service.dart';
import 'package:chip_companion/automation_bridge.dart';

// Global callback for tab navigation
Function(int)? _tabNavigationCallback;

void setupJavaScriptBridge(
  SettingsService settingsService,
  GlobalKey<NavigatorState> navigatorKey, {
  Function(int)? onTabNavigation,
}) {
  _tabNavigationCallback = onTabNavigation;
  // Expose navigation function to JavaScript
  js_util.setProperty(js_util.globalThis, 'navigateTo', allowInterop((String route) {
    if (kDebugMode) debugPrint('🌐 JS Bridge: Navigating to $route');

    final context = navigatorKey.currentContext;
    if (context == null) {
      if (kDebugMode) debugPrint('❌ JS Bridge: Navigator context not available');
      return;
    }

    switch (route) {
      case '/home':
        // Navigate to home tab (index 0)
        _navigateToTab(0);
        break;
      case '/devices':
        // Navigate to devices tab (index 1)
        _navigateToTab(1);
        break;
      case '/glossary':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GlossaryScreen(),
          ),
        );
        break;
      case '/support':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SupportScreen(),
          ),
        );
        break;
      case '/settings':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsScreen(settingsService: settingsService),
          ),
        );
        break;
      case '/help':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HelpScreen(),
          ),
        );
        break;
      case '/about':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AboutScreen(),
          ),
        );
        break;
      default:
        if (kDebugMode) debugPrint('❌ JS Bridge: Unknown route: $route');
    }
  }));

  // Expose tab navigation by index directly
  js_util.setProperty(js_util.globalThis, 'navigateToTab', allowInterop((int index) {
    if (kDebugMode) debugPrint('🌐 JS Bridge: navigateToTab($index)');
    _navigateToTab(index);
  }));

  // Expose input/validation helpers for automation
  js_util.setProperty(js_util.globalThis, 'setChipId', allowInterop((String chipId) {
    if (kDebugMode) debugPrint('🌐 JS Bridge: setChipId($chipId)');
    AutomationBridge.setChipId?.call(chipId);
  }));
  js_util.setProperty(js_util.globalThis, 'validateChip', allowInterop(() {
    if (kDebugMode) debugPrint('🌐 JS Bridge: validateChip()');
    AutomationBridge.validateChip?.call();
  }));
  js_util.setProperty(js_util.globalThis, 'focusChipInput', allowInterop(() {
    if (kDebugMode) debugPrint('🌐 JS Bridge: focusChipInput()');
    AutomationBridge.focusInput?.call();
  }));

  // Expose function to get current screen info
  js_util.setProperty(js_util.globalThis, 'getCurrentScreen', allowInterop(() {
    final context = navigatorKey.currentContext;
    if (context == null) return 'unknown';

    final route = ModalRoute.of(context);
    if (route == null) return 'home';

    final routeName = route.settings.name;
    if (routeName != null) return routeName;

    // Check if we're on a specific tab
    return 'main_navigation';
  }));

  if (kDebugMode) debugPrint('✅ JavaScript bridge initialized (web)');
}

void _navigateToTab(int index) {
  // Use the callback to navigate to the specified tab
  _tabNavigationCallback?.call(index);
}
