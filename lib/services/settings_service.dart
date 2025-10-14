import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chip_companion/services/security_service.dart';

class SettingsService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  static const String _autoValidateOnScanKey = 'auto_validate_on_scan';

  String _currentLocale = 'en';
  bool _autoValidateOnScan = true; // Default: ON

  static final List<SupportedLanguage> supportedLanguages = [
    SupportedLanguage('en', 'English', 'English'),
    SupportedLanguage('he', 'עברית', 'Hebrew'),
    SupportedLanguage('ru', 'Русский', 'Russian'),
    SupportedLanguage('es', 'Español', 'Spanish'),
    SupportedLanguage('fr', 'Français', 'French'),
  ];

  // Initialize the service
  Future<void> initialize() async {
    _currentLocale = await getSavedLanguage();
    _autoValidateOnScan = await getAutoValidateOnScan();
    notifyListeners();
  }

  // Get current locale
  String get locale => _currentLocale;

  // Auto-validate on scan preference
  bool get autoValidateOnScan => _autoValidateOnScan;

  // Get saved language preference
  Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en'; // Default to English
  }

  // Save language preference
  Future<void> saveLanguage(String languageCode) async {
    // Security: Validate language code
    if (!SecurityService.isValidLanguageCode(languageCode)) {
      throw ArgumentError('Invalid language code: $languageCode');
    }

    _currentLocale = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }

  // Get saved preference for auto-validate on scan (default: true)
  Future<bool> getAutoValidateOnScan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoValidateOnScanKey) ?? true;
  }

  // Save preference for auto-validate on scan
  Future<void> setAutoValidateOnScan(bool value) async {
    _autoValidateOnScan = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoValidateOnScanKey, value);
    notifyListeners();
  }

  // Get system locale language code
  String getSystemLanguageCode() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final languageCode = systemLocale.languageCode;

    // Check if system language is supported
    if (supportedLanguages.any((lang) => lang.code == languageCode)) {
      return languageCode;
    }

    return 'en'; // Default to English if system language not supported
  }

  // Get language display name
  String getLanguageName(String languageCode) {
    final language = supportedLanguages.firstWhere(
      (lang) => lang.code == languageCode,
      orElse: () => supportedLanguages.first,
    );
    return language.nativeName;
  }
}

class SupportedLanguage {
  final String code;
  final String nativeName;
  final String englishName;

  SupportedLanguage(this.code, this.nativeName, this.englishName);
}
