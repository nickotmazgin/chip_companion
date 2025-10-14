// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Chip Companion';

  @override
  String get validateButton => 'Validate Format';

  @override
  String get enterChipId => 'Enter Microchip ID';

  @override
  String get chipIdHint => 'Enter 9, 10, or 15 digit chip ID';

  @override
  String get validFormat => 'Valid Format ✓';

  @override
  String get invalidFormat => 'Invalid Format ✗';

  @override
  String get chipType => 'Chip Type';

  @override
  String get formatDescription => 'Format Information';

  @override
  String get suggestedRegistries => 'Registry Information';

  @override
  String get contactRegistry => 'Contact Registry for Verification';

  @override
  String get helpTitle => 'Microchip Guide';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get aboutTitle => 'About';

  @override
  String get languageSelection => 'Language';

  @override
  String get aboutDescription =>
      'Professional pet microchip validator and registry directory. Validate microchip formats, scan with Bluetooth and NFC devices, and access comprehensive registry contact information worldwide.';

  @override
  String get helpContent =>
      'Professional microchip validation tool with Bluetooth and NFC scanning capabilities. Validate microchip ID formats against international standards and access comprehensive registry contact information.\n\nThis app provides format validation and registry directory services. For official pet identification and database lookups, contact veterinary professionals and official registries directly.';

  @override
  String get disclaimer =>
      '⚠️ For Reference Only\n\nThis app provides microchip format validation and registry directory services. It does not connect to live databases or provide actual pet identification lookups. For official pet identification and database searches, contact veterinary professionals and official registries directly.';

  @override
  String get registryContacts => 'Registry Information';

  @override
  String get website => 'Website';

  @override
  String get contactInfo => 'Contact';

  @override
  String get region => 'Region';

  @override
  String get verificationRequired =>
      '⚠️ Always verify information with official sources';

  @override
  String get formatValidation => 'Format Validation';

  @override
  String get learnMore => 'Learn More';

  @override
  String get invalidInput => 'Please enter a valid microchip ID';

  @override
  String get about => 'About';

  @override
  String get forPetOwners => 'For Pet Owners';

  @override
  String get developer => 'Developer';

  @override
  String get createdBy => 'Created by';

  @override
  String get contact => 'Contact';

  @override
  String get support => 'Support';

  @override
  String get helpImprove => 'Help Improve';

  @override
  String get tipJar => 'Tip Jar';

  @override
  String get supportedRegions => 'Supported Regions';

  @override
  String get helpFAQ => 'Help & FAQ';

  @override
  String get howToUse => 'How to Use';

  @override
  String get tips => 'Tips';

  @override
  String get troubleshooting => 'Troubleshooting';

  @override
  String get stepByStep => 'Step by Step Guide';

  @override
  String get step1 => 'Step 1: Enter the microchip ID';

  @override
  String get step2 => 'Step 2: Tap Validate Format';

  @override
  String get step3 => 'Step 3: Review the results';

  @override
  String get step4 => 'Step 4: Contact registries for verification';

  @override
  String get globalRegistries => 'Global Registries';

  @override
  String get notFound => 'Not Found';

  @override
  String get tryThese => 'Try These Solutions';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get enterMicrochipId => 'Enter Microchip ID';

  @override
  String get globalCoverage => 'Global Coverage';

  @override
  String get trademarkNotice =>
      'Registry names are trademarks of their respective owners';

  @override
  String get notAffiliated => 'Not affiliated with any registry organization';

  @override
  String get educationalOnly => 'Format validation and registry directory';

  @override
  String get noOfficialLookup => 'Does not perform official database lookups';

  @override
  String get trademarkOwnership =>
      'Registry names are trademarks of their owners';

  @override
  String get devicesTitle => 'Devices & Scanners';

  @override
  String get homeTitle => 'Home';

  @override
  String get bluetoothScanners => 'Bluetooth Scanners';

  @override
  String get nfcScanning => 'NFC Scanning';

  @override
  String get pairedDevices => 'Paired Devices';

  @override
  String get startBluetoothScan => 'Start Bluetooth Scan';

  @override
  String get scanWithNFC => 'Scan with NFC';

  @override
  String get scanning => 'Scanning...';

  @override
  String get chipIdScanned => 'Chip ID Scanned';

  @override
  String scannedId(String chipId) {
    return 'Scanned ID: $chipId';
  }

  @override
  String get validateThisChip => 'Would you like to validate this chip ID?';

  @override
  String get bluetoothNotEnabled =>
      'Bluetooth is not enabled. Please enable Bluetooth in your device settings.';

  @override
  String get nfcNotAvailable =>
      'NFC is not available on this device or not enabled.';

  @override
  String get noPairedDevices =>
      'No paired external scanners found. Pair Bluetooth scanners in your device\'s Bluetooth settings. NFC is available for tap-to-scan functionality.';

  @override
  String get scannerDisclaimers => 'Scanner Disclaimers';

  @override
  String get scannerCompatibilityDisclaimer =>
      'Scanner support is provided for compatible Bluetooth devices. We do not manufacture scanners and cannot guarantee compatibility with all models.';

  @override
  String get scannerDataDisclaimer =>
      'Scanned chip IDs are used for immediate format validation only. This information is not stored, saved, or transmitted by Chip Companion.';

  @override
  String get validationErrorOccurred => 'Validation error occurred';

  @override
  String get professionalMicrochipValidator =>
      'Professional Microchip Validator';

  @override
  String get validateChipFormatsAndFindRegistries =>
      'Validate chip formats and find registry contacts';

  @override
  String get microchipIdInputField => 'Microchip ID input field';

  @override
  String get enterMicrochipIdToValidate =>
      'Enter a microchip ID to validate its format';

  @override
  String get validatingMicrochipFormat => 'Validating microchip format';

  @override
  String get validateMicrochipFormat => 'Validate microchip format';

  @override
  String get validating => 'Validating...';

  @override
  String get validatingFormat => 'Validating format...';

  @override
  String get developedBy => 'Developed by Nick Otmazgin';

  @override
  String get supportThisApp => 'Support this App';

  @override
  String get contactDeveloper => 'Contact Developer';

  @override
  String get sourceCodeOnGitHub => 'Source Code on GitHub';

  @override
  String get copyrightNotice => 'Copyright © 2025. All rights reserved.';

  @override
  String get emailCopiedToClipboard => 'Email copied to clipboard';

  @override
  String get errorOpeningEmail => 'Error opening email';

  @override
  String get paypalLinkCopiedToClipboard => 'PayPal link copied to clipboard';

  @override
  String get errorOpeningPaypal => 'Error opening PayPal';

  @override
  String get version => 'Version';

  @override
  String get developerEmail => 'NickOtmazgin.Dev@gmail.com';

  @override
  String get israelSupport => 'Israel';

  @override
  String get israelSupportDescription =>
      'Complete support for Israeli veterinary registries and pet identification systems';

  @override
  String get russiaSupport => 'Russia';

  @override
  String get russiaSupportDescription =>
      'Complete support for Russian veterinary registries and animal passport systems';

  @override
  String get worldwideSupport => 'Worldwide';

  @override
  String get worldwideSupportDescription =>
      'Professional microchip validation and registry directory';

  @override
  String get madeWithLove => 'Made with ❤️ for pet owners and veterinarians';

  @override
  String get appDisclaimer =>
      'This app is designed to help reunite lost pets with their families. Always verify information with official registries and veterinarians. Results are provided for informational purposes only.';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get appInformation => 'App Information';

  @override
  String get description => 'Description';

  @override
  String get bluetoothNotEnabledMessage =>
      'Bluetooth is not enabled. Please enable Bluetooth in your device settings.';

  @override
  String get bluetoothScanFailed => 'Bluetooth scan failed';

  @override
  String get chipIdScannedTitle => 'Chip ID Scanned';

  @override
  String get scannedIdLabel => 'Scanned ID';

  @override
  String get validateThisChipQuestion =>
      'Would you like to validate this chip ID?';

  @override
  String get cancel => 'Cancel';

  @override
  String get validate => 'Validate';

  @override
  String get scannerManagement => 'Scanner Management';

  @override
  String get noPairedDevicesMessage =>
      'No paired Bluetooth devices found. Pair a scanner in your device\'s Bluetooth settings.';

  @override
  String get deviceStatus => 'Device Status';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get refresh => 'Refresh';

  @override
  String get unlockProFeatures => 'Unlock Pro Features';

  @override
  String get proFeatures => 'Pro Features';

  @override
  String get freeFeatures => 'Free Features';

  @override
  String get oneTimePurchase => 'One-time purchase';

  @override
  String get bluetoothScanningPro => 'Bluetooth Scanning';

  @override
  String get nfcScanningPro => 'NFC Scanning';

  @override
  String get deviceManagementPro => 'Device Management';

  @override
  String get prioritySupportPro => 'Priority Support';

  @override
  String get connectExternalScanners =>
      'Connect to external RFID scanners via Bluetooth';

  @override
  String get tapToScanNFC =>
      'Use phone\'s built-in NFC reader for modern microchip tags';

  @override
  String get enhancedDeviceInfo =>
      'Enhanced paired device information and status';

  @override
  String get getHelpWhenNeeded => 'Get help when you need it most';

  @override
  String get unlockPro => 'Unlock Pro';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get proUnlocked => 'Pro features unlocked!';

  @override
  String get checkingPurchases => 'Checking for previous purchases...';

  @override
  String get unableToLoadPricing => 'Unable to load pricing information';

  @override
  String get proFeatureLocked => 'This feature requires Pro';

  @override
  String get nfc => 'NFC';

  @override
  String get pro => 'PRO';

  @override
  String get nfcAvailableMessage =>
      'Your device\'s NFC is available. Tap the \'Scan with NFC\' button to begin.';

  @override
  String get pairedDevicesMessage =>
      'A list of your connected Bluetooth scanners will appear here.';

  @override
  String get nfcScanFailed => 'NFC scan failed';

  @override
  String get supportTitle => 'Support Chip Companion';

  @override
  String get supportIntro =>
      'Chip Companion is a solo project, built and maintained with passion.\n\nYour support helps cover costs and fund future development so the core features can stay free for everyone.';

  @override
  String get supportVoluntaryNote =>
      'Contributions are 100% voluntary and do not unlock features or content inside the app. For any in‑app purchases (like Pro features), Google Play billing is used. This page is only for optional donations.';

  @override
  String get donateViaPaypal => 'Donate via PayPal';

  @override
  String get supportVoluntaryButton => 'Support (Voluntary)';

  @override
  String get autoValidateOnScanTitle => 'Auto-validate on scan';

  @override
  String get autoValidateOnScanSubtitle =>
      'When enabled, IDs scanned via Bluetooth or NFC will automatically validate on the Home screen';

  @override
  String get deviceActions => 'Device actions';

  @override
  String get glossaryTitle => 'Microchip Glossary';

  @override
  String get bluetoothScannersIntro =>
      'Connect to external RFID scanners via Bluetooth. These devices work like keyboards and automatically populate the chip ID field.';

  @override
  String get nfcNdefSupportNote =>
      'NFC NDEF tags (collars/cards) are supported: if a tag contains a chip ID in text/URL, the app will extract it, populate Home, and validate. Implanted FDX‑B chips still require an external 134.2 kHz reader.';

  @override
  String get glossaryAboutTitle => 'About Chip Companion';

  @override
  String get glossaryAboutBody =>
      'Chip Companion helps validate pet microchip ID formats and provides public registry contact guidance. You can scan microchips using compatible Bluetooth scanners or NFC (where supported) and, if enabled in Settings, new scans will auto‑validate on the Home screen.';

  @override
  String get glossaryHowTitle => 'How validation works';

  @override
  String get glossaryHowBody =>
      'The app validates the structure of microchip IDs (length, character set, and known patterns) against common formats. Validation confirms that an ID looks correct, but it does not prove that a chip is registered or who owns it. For ownership and registration status, contact the appropriate registry directly.';

  @override
  String get glossaryISOTitle => 'ISO 11784/11785 (FDX‑B)';

  @override
  String get glossaryISOBody =>
      'Standard 15‑digit numeric microchip. The first 3 digits (prefix) can indicate a country (001–899) or a manufacturer (900–998).';

  @override
  String get glossaryAvidTitle => 'AVID 10‑digit';

  @override
  String get glossaryAvidBody =>
      'Legacy/non‑ISO 10‑digit numeric format used by AVID PETtrac.';

  @override
  String get glossaryLegacyTitle => 'Legacy 9‑digit';

  @override
  String get glossaryLegacyBody =>
      'Older 9‑digit numeric formats. Coverage varies; check multiple registries.';

  @override
  String get glossaryHexTitle => 'Hex‑encoded ISO';

  @override
  String get glossaryHexBody =>
      'Some scanners or systems display a 15‑character hexadecimal representation. Convert to a 15‑digit decimal ISO number for official lookups.';

  @override
  String get glossaryScanningTitle => 'Scanning methods';

  @override
  String get glossaryScanningBody =>
      'Bluetooth: Pair a compatible pet microchip scanner and scan from the Devices tab.\nNFC: On supported phones, tap a compatible chip to read its ID.\nAuto‑validate: Enable in Settings to automatically validate scanned IDs on the Home screen.';

  @override
  String get glossaryDisclaimer =>
      'Disclaimer: This app provides format validation and public registry contact guidance for reference only. It does not perform official database lookups, confirm registration status, or store owner data. Manufacturer/Country code hints are based on public information and may not be guaranteed.';

  @override
  String get glossaryDigitsTitle => 'What the 15 digits mean';

  @override
  String get glossaryDigitsBody =>
      'Digits 1–3: Country (001–899) or Manufacturer (900–998) prefix. Digits 4–14: Unique identifier. Digit 15: Sequence digit (not a check digit). Prefixes can hint at origin, but always verify registration with official registries.';

  @override
  String get glossaryEdgeCasesTitle => 'Common edge cases';

  @override
  String get glossaryEdgeCasesBody =>
      'Leading zeros may be omitted on labels; remove spaces and hyphens when typing. Hex vs decimal: convert hex to a 15‑digit decimal for lookups. Cloned or re‑encoded chips exist—validation confirms format only, not registration.';

  @override
  String get glossaryBeyondTitle => 'Beyond companion animals';

  @override
  String get glossaryBeyondBody =>
      'Pets typically use FDX‑B (ISO 11784/11785). Livestock and some industrial systems may use HDX or other technologies. This app focuses on pet microchip ID formats and guidance.';

  @override
  String get setDeviceAlias => 'Set device alias';

  @override
  String get alias => 'Alias';

  @override
  String get save => 'Save';

  @override
  String get rememberDevice => 'Remember device';

  @override
  String get forgetDevice => 'Forget device';

  @override
  String get setAlias => 'Set alias';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get unsupported => 'Unsupported';

  @override
  String get off => 'Off';

  @override
  String get noSubscriptionLifetimeAccess =>
      'No subscription. Lifetime access to Pro features.';

  @override
  String get proWebPurchaseNotice =>
      'In-app purchases are not available on web. Use the Android/iOS app to unlock Pro with a one-time purchase (lifetime access) through official store billing.';

  @override
  String get nfcNoPairedListInfo =>
      'NFC does not maintain a paired devices list. When available on your phone, simply tap a tag to scan—no pairing required.';

  @override
  String get deviceClass => 'Class';
}
