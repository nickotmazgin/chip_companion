import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chip_companion/l10n/app_localizations.dart';
import 'package:chip_companion/screens/home_screen.dart';
import 'package:chip_companion/screens/devices_screen.dart';
import 'package:chip_companion/screens/glossary_screen.dart';
import 'package:chip_companion/screens/support_screen.dart';
import 'package:chip_companion/services/settings_service.dart';
import 'package:chip_companion/services/purchase_service.dart';
import 'package:chip_companion/js_bridge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Global navigator key for JavaScript bridge
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final settingsService = SettingsService();
  await settingsService.initialize();

  final purchaseService = PurchaseService();
  await purchaseService.initialize();

  // Expose JavaScript bridge functions for automation (web only)
  if (kIsWeb) {
    setupJavaScriptBridge(settingsService, navigatorKey, 
      onTabNavigation: (index) {
        MainNavigationScreen._currentInstance?.navigateToTab(index);
      }
    );
  }

  // Enable Android edge-to-edge system UI and set transparent system bars.
  // This improves visual integration on Android 14/15+ and addresses Play warnings.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  runApp(
    ChipCompanionApp(
      settingsService: settingsService,
      purchaseService: purchaseService,
    ),
  );
}


class ChipCompanionApp extends StatefulWidget {
  final SettingsService settingsService;
  final PurchaseService purchaseService;

  const ChipCompanionApp({
    super.key,
    required this.settingsService,
    required this.purchaseService,
  });

  @override
  State<ChipCompanionApp> createState() => _ChipCompanionAppState();
}

class _ChipCompanionAppState extends State<ChipCompanionApp> {
  @override
  void initState() {
    super.initState();
    widget.settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    widget.settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chip Companion',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Add navigator key for JS bridge
      routes: {
        '/glossary': (context) => const GlossaryScreen(),
        '/support': (context) => const SupportScreen(),
      },

      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(widget.settingsService.locale),

      // Theme
      theme: _buildTheme(),

      // Home
      home: MainNavigationScreen(
        settingsService: widget.settingsService,
        purchaseService: widget.purchaseService,
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 57,
          height: 1.1,
          color: Color(0xFF1B5E20),
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 45,
          height: 1.1,
          color: Color(0xFF1B5E20),
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 36,
          height: 1.1,
          color: Color(0xFF1B5E20),
        ),
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          height: 1.1,
          color: Color(0xFF1B5E20),
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          height: 1.1,
          color: Color(0xFF1B5E20),
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          height: 1.1,
          color: Color(0xFF1B5E20),
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          height: 1.1,
          color: Color(0xFF1B5E20),
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          height: 1.1,
          color: Color(0xFF1B5E20),
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          height: 1.1,
          color: Color(0xFF1B5E20),
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.2,
          color: Color(0xFF2E2E2E),
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.2,
          color: Color(0xFF424242),
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          height: 1.2,
          color: Color(0xFF616161),
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          height: 1.2,
          color: Color(0xFF2E2E2E),
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          height: 1.2,
          color: Color(0xFF424242),
        ),
        labelSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
          height: 1.2,
          color: Color(0xFF616161),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2E7D32), // Forest green
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Color(0xFFE8F5E8),
        foregroundColor: Color(0xFF2E7D32),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Color(0xFF2E7D32),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: const Color(0xFFE8F5E8),
          foregroundColor: const Color(0xFF2E7D32),
          elevation: 3,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFE8F5E8),
        selectedItemColor: Color(0xFF1B5E20),
        unselectedItemColor: Color(0xFF1B5E20),
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 15,
          color: Color(0xFF1B5E20),
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: Color(0xFF1B5E20),
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFFF1F8E9),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final SettingsService settingsService;
  final PurchaseService purchaseService;

  const MainNavigationScreen({
    super.key,
    required this.settingsService,
    required this.purchaseService,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();

  // Static reference for JS bridge communication
  static _MainNavigationScreenState? _currentInstance;
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String? _scannedChipId;

  @override
  void initState() {
    super.initState();
    // Register this instance for JS bridge communication
    MainNavigationScreen._currentInstance = this;
  }

  @override
  void dispose() {
    // Unregister this instance
    if (MainNavigationScreen._currentInstance == this) {
      MainNavigationScreen._currentInstance = null;
    }
    super.dispose();
  }

  // Method to change tab from JS bridge
  void navigateToTab(int index) {
    if (index >= 0 && index < 2) { // We have 2 tabs: home (0) and devices (1)
      setState(() {
        _currentIndex = index;
      });
  if (kDebugMode) debugPrint('🏠 Tab navigation: Changed to index $index');
    }
  }

  void _handleScannedChipId(String chipId) {
    setState(() {
      _scannedChipId = chipId;
      _currentIndex = 0; // Navigate to home screen
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            settingsService: widget.settingsService,
            purchaseService: widget.purchaseService,
            scannedChipId: _scannedChipId,
            onChipIdCleared: () => setState(() => _scannedChipId = null),
          ),
          DevicesScreen(
            purchaseService: widget.purchaseService,
            settingsService: widget.settingsService,
            onChipIdScanned: _handleScannedChipId,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E8), Color(0xFFF1F8E9), Color(0xFFE8F5E8)],
          ),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
            BoxShadow(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF1B5E20),
          unselectedItemColor: const Color(0xFF1B5E20).withValues(alpha: 0.75),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: 0.5,
            color: Color(0xFF1B5E20),
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.3,
            color: Color(0xFF1B5E20),
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _currentIndex == 0
                      ? const Color(0xFF1B5E20).withValues(alpha: 0.1)
                      : const Color(0xFFFFFFFF).withValues(alpha: 0.4),
                  border: _currentIndex == 0
                      ? null
                      : Border.all(
                          color: const Color(0xFF1B5E20).withValues(alpha: 0.2),
                          width: 1,
                        ),
                ),
                child: Icon(
                  Icons.home_rounded,
                  size: 32,
                  color: _currentIndex == 0
                      ? const Color(0xFF1B5E20)
                      : const Color(0xFF1B5E20).withValues(alpha: 0.8),
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF1B5E20).withValues(alpha: 0.15),
                  border: Border.all(
                    color: const Color(0xFF1B5E20).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: const Icon(Icons.home_rounded, size: 32, weight: 800),
              ),
              label: l10n.homeTitle,
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _currentIndex == 1
                      ? const Color(0xFF1B5E20).withValues(alpha: 0.1)
                      : const Color(0xFFFFFFFF).withValues(alpha: 0.4),
                  border: _currentIndex == 1
                      ? null
                      : Border.all(
                          color: const Color(0xFF1B5E20).withValues(alpha: 0.2),
                          width: 1,
                        ),
                ),
                child: Icon(
                  Icons.devices_rounded,
                  size: 32,
                  color: _currentIndex == 1
                      ? const Color(0xFF1B5E20)
                      : const Color(0xFF1B5E20).withValues(alpha: 0.8),
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF1B5E20).withValues(alpha: 0.15),
                  border: Border.all(
                    color: const Color(0xFF1B5E20).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: const Icon(Icons.devices_rounded, size: 32, weight: 800),
              ),
              label: l10n.devicesTitle,
            ),
          ],
        ),
      ),
    );
  }
}
