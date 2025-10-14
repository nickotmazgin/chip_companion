import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('ru'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Chip Companion'**
  String get appTitle;

  /// Button text to validate microchip format
  ///
  /// In en, this message translates to:
  /// **'Validate Format'**
  String get validateButton;

  /// Label for chip ID input field
  ///
  /// In en, this message translates to:
  /// **'Enter Microchip ID'**
  String get enterChipId;

  /// Hint text for chip ID input
  ///
  /// In en, this message translates to:
  /// **'Enter 9, 10, or 15 digit chip ID'**
  String get chipIdHint;

  /// Text shown when chip format is valid
  ///
  /// In en, this message translates to:
  /// **'Valid Format ✓'**
  String get validFormat;

  /// Text shown when chip format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid Format ✗'**
  String get invalidFormat;

  /// Label for chip type information
  ///
  /// In en, this message translates to:
  /// **'Chip Type'**
  String get chipType;

  /// Label for format description
  ///
  /// In en, this message translates to:
  /// **'Format Information'**
  String get formatDescription;

  /// Label for registry information section
  ///
  /// In en, this message translates to:
  /// **'Registry Information'**
  String get suggestedRegistries;

  /// Instruction to contact registry
  ///
  /// In en, this message translates to:
  /// **'Contact Registry for Verification'**
  String get contactRegistry;

  /// Title for help screen
  ///
  /// In en, this message translates to:
  /// **'Microchip Guide'**
  String get helpTitle;

  /// Title for settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Title for about screen
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelection;

  /// Description of the app shown in about screen
  ///
  /// In en, this message translates to:
  /// **'Professional pet microchip validator and registry directory. Validate microchip formats, scan with Bluetooth and NFC devices, and access comprehensive registry contact information worldwide.'**
  String get aboutDescription;

  /// Main help content explaining app functionality
  ///
  /// In en, this message translates to:
  /// **'Professional microchip validation tool with Bluetooth and NFC scanning capabilities. Validate microchip ID formats against international standards and access comprehensive registry contact information.\n\nThis app provides format validation and registry directory services. For official pet identification and database lookups, contact veterinary professionals and official registries directly.'**
  String get helpContent;

  /// Important disclaimer about app limitations
  ///
  /// In en, this message translates to:
  /// **'⚠️ For Reference Only\n\nThis app provides microchip format validation and registry directory services. It does not connect to live databases or provide actual pet identification lookups. For official pet identification and database searches, contact veterinary professionals and official registries directly.'**
  String get disclaimer;

  /// Title for registry contacts section
  ///
  /// In en, this message translates to:
  /// **'Registry Information'**
  String get registryContacts;

  /// Label for website information
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// Label for contact information
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactInfo;

  /// Label for region information
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// Warning about verification requirement
  ///
  /// In en, this message translates to:
  /// **'⚠️ Always verify information with official sources'**
  String get verificationRequired;

  /// Title for format validation section
  ///
  /// In en, this message translates to:
  /// **'Format Validation'**
  String get formatValidation;

  /// Button text to learn more
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// Error message for invalid input
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid microchip ID'**
  String get invalidInput;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Section for pet owners
  ///
  /// In en, this message translates to:
  /// **'For Pet Owners'**
  String get forPetOwners;

  /// Developer label
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// Created by label
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get createdBy;

  /// Contact label
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Support label
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Help improve label
  ///
  /// In en, this message translates to:
  /// **'Help Improve'**
  String get helpImprove;

  /// Tip jar label
  ///
  /// In en, this message translates to:
  /// **'Tip Jar'**
  String get tipJar;

  /// Supported regions label
  ///
  /// In en, this message translates to:
  /// **'Supported Regions'**
  String get supportedRegions;

  /// Help and FAQ title
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpFAQ;

  /// How to use section
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get howToUse;

  /// Tips section
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// Troubleshooting section
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get troubleshooting;

  /// Step by step guide title
  ///
  /// In en, this message translates to:
  /// **'Step by Step Guide'**
  String get stepByStep;

  /// Step 1 instruction
  ///
  /// In en, this message translates to:
  /// **'Step 1: Enter the microchip ID'**
  String get step1;

  /// Step 2 instruction
  ///
  /// In en, this message translates to:
  /// **'Step 2: Tap Validate Format'**
  String get step2;

  /// Step 3 instruction
  ///
  /// In en, this message translates to:
  /// **'Step 3: Review the results'**
  String get step3;

  /// Step 4 instruction
  ///
  /// In en, this message translates to:
  /// **'Step 4: Contact registries for verification'**
  String get step4;

  /// Global registries section
  ///
  /// In en, this message translates to:
  /// **'Global Registries'**
  String get globalRegistries;

  /// Not found message
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get notFound;

  /// Try these solutions label
  ///
  /// In en, this message translates to:
  /// **'Try These Solutions'**
  String get tryThese;

  /// Settings title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Select language label
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Enter microchip ID label
  ///
  /// In en, this message translates to:
  /// **'Enter Microchip ID'**
  String get enterMicrochipId;

  /// Global coverage label
  ///
  /// In en, this message translates to:
  /// **'Global Coverage'**
  String get globalCoverage;

  /// Trademark notice for registry names
  ///
  /// In en, this message translates to:
  /// **'Registry names are trademarks of their respective owners'**
  String get trademarkNotice;

  /// Disclaimer about not being affiliated
  ///
  /// In en, this message translates to:
  /// **'Not affiliated with any registry organization'**
  String get notAffiliated;

  /// Professional tool description
  ///
  /// In en, this message translates to:
  /// **'Format validation and registry directory'**
  String get educationalOnly;

  /// Disclaimer about no official lookups
  ///
  /// In en, this message translates to:
  /// **'Does not perform official database lookups'**
  String get noOfficialLookup;

  /// Trademark ownership notice
  ///
  /// In en, this message translates to:
  /// **'Registry names are trademarks of their owners'**
  String get trademarkOwnership;

  /// Title for the devices screen
  ///
  /// In en, this message translates to:
  /// **'Devices & Scanners'**
  String get devicesTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// Title for Bluetooth scanners section
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Scanners'**
  String get bluetoothScanners;

  /// Title for NFC scanning section
  ///
  /// In en, this message translates to:
  /// **'NFC Scanning'**
  String get nfcScanning;

  /// Title for paired devices section
  ///
  /// In en, this message translates to:
  /// **'Paired Devices'**
  String get pairedDevices;

  /// Button to start Bluetooth scanning
  ///
  /// In en, this message translates to:
  /// **'Start Bluetooth Scan'**
  String get startBluetoothScan;

  /// Button to start NFC scanning
  ///
  /// In en, this message translates to:
  /// **'Scan with NFC'**
  String get scanWithNFC;

  /// Text shown while scanning
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// Title for scanned chip ID dialog
  ///
  /// In en, this message translates to:
  /// **'Chip ID Scanned'**
  String get chipIdScanned;

  /// Text showing the scanned chip ID
  ///
  /// In en, this message translates to:
  /// **'Scanned ID: {chipId}'**
  String scannedId(String chipId);

  /// Question asking if user wants to validate scanned chip
  ///
  /// In en, this message translates to:
  /// **'Would you like to validate this chip ID?'**
  String get validateThisChip;

  /// Warning when Bluetooth is not enabled
  ///
  /// In en, this message translates to:
  /// **'Bluetooth is not enabled. Please enable Bluetooth in your device settings.'**
  String get bluetoothNotEnabled;

  /// Warning when NFC is not available
  ///
  /// In en, this message translates to:
  /// **'NFC is not available on this device or not enabled.'**
  String get nfcNotAvailable;

  /// Message when no paired external scanners are found, mentioning both Bluetooth and NFC
  ///
  /// In en, this message translates to:
  /// **'No paired external scanners found. Pair Bluetooth scanners in your device\'s Bluetooth settings. NFC is available for tap-to-scan functionality.'**
  String get noPairedDevices;

  /// Title for scanner disclaimers section
  ///
  /// In en, this message translates to:
  /// **'Scanner Disclaimers'**
  String get scannerDisclaimers;

  /// Disclaimer about scanner compatibility
  ///
  /// In en, this message translates to:
  /// **'Scanner support is provided for compatible Bluetooth devices. We do not manufacture scanners and cannot guarantee compatibility with all models.'**
  String get scannerCompatibilityDisclaimer;

  /// Disclaimer about scanned data handling
  ///
  /// In en, this message translates to:
  /// **'Scanned chip IDs are used for immediate format validation only. This information is not stored, saved, or transmitted by Chip Companion.'**
  String get scannerDataDisclaimer;

  /// Error message when validation fails
  ///
  /// In en, this message translates to:
  /// **'Validation error occurred'**
  String get validationErrorOccurred;

  /// Title for the professional validator section
  ///
  /// In en, this message translates to:
  /// **'Professional Microchip Validator'**
  String get professionalMicrochipValidator;

  /// Description of what the app does
  ///
  /// In en, this message translates to:
  /// **'Validate chip formats and find registry contacts'**
  String get validateChipFormatsAndFindRegistries;

  /// Accessibility label for input field
  ///
  /// In en, this message translates to:
  /// **'Microchip ID input field'**
  String get microchipIdInputField;

  /// Accessibility hint for input field
  ///
  /// In en, this message translates to:
  /// **'Enter a microchip ID to validate its format'**
  String get enterMicrochipIdToValidate;

  /// Accessibility label when validating
  ///
  /// In en, this message translates to:
  /// **'Validating microchip format'**
  String get validatingMicrochipFormat;

  /// Accessibility label for validate button
  ///
  /// In en, this message translates to:
  /// **'Validate microchip format'**
  String get validateMicrochipFormat;

  /// Text shown while validating
  ///
  /// In en, this message translates to:
  /// **'Validating...'**
  String get validating;

  /// Text shown while validating format
  ///
  /// In en, this message translates to:
  /// **'Validating format...'**
  String get validatingFormat;

  /// Developer attribution
  ///
  /// In en, this message translates to:
  /// **'Developed by Nick Otmazgin'**
  String get developedBy;

  /// Link text for supporting the app
  ///
  /// In en, this message translates to:
  /// **'Support this App'**
  String get supportThisApp;

  /// Link text for contacting developer
  ///
  /// In en, this message translates to:
  /// **'Contact Developer'**
  String get contactDeveloper;

  /// Link text for GitHub source code
  ///
  /// In en, this message translates to:
  /// **'Source Code on GitHub'**
  String get sourceCodeOnGitHub;

  /// Copyright notice
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2025. All rights reserved.'**
  String get copyrightNotice;

  /// Message when email is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Email copied to clipboard'**
  String get emailCopiedToClipboard;

  /// Error message when email fails to open
  ///
  /// In en, this message translates to:
  /// **'Error opening email'**
  String get errorOpeningEmail;

  /// Message when PayPal link is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'PayPal link copied to clipboard'**
  String get paypalLinkCopiedToClipboard;

  /// Error message when PayPal fails to open
  ///
  /// In en, this message translates to:
  /// **'Error opening PayPal'**
  String get errorOpeningPaypal;

  /// App version label (dynamic number shown via PackageInfo)
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Developer email address
  ///
  /// In en, this message translates to:
  /// **'NickOtmazgin.Dev@gmail.com'**
  String get developerEmail;

  /// Israel support label
  ///
  /// In en, this message translates to:
  /// **'Israel'**
  String get israelSupport;

  /// Description of Israel support
  ///
  /// In en, this message translates to:
  /// **'Complete support for Israeli veterinary registries and pet identification systems'**
  String get israelSupportDescription;

  /// Russia support label
  ///
  /// In en, this message translates to:
  /// **'Russia'**
  String get russiaSupport;

  /// Description of Russia support
  ///
  /// In en, this message translates to:
  /// **'Complete support for Russian veterinary registries and animal passport systems'**
  String get russiaSupportDescription;

  /// Worldwide support label
  ///
  /// In en, this message translates to:
  /// **'Worldwide'**
  String get worldwideSupport;

  /// Description of worldwide support
  ///
  /// In en, this message translates to:
  /// **'Professional microchip validation and registry directory'**
  String get worldwideSupportDescription;

  /// Footer message
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for pet owners and veterinarians'**
  String get madeWithLove;

  /// App disclaimer text
  ///
  /// In en, this message translates to:
  /// **'This app is designed to help reunite lost pets with their families. Always verify information with official registries and veterinarians. Results are provided for informational purposes only.'**
  String get appDisclaimer;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// App information section title
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInformation;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Message when Bluetooth is not enabled
  ///
  /// In en, this message translates to:
  /// **'Bluetooth is not enabled. Please enable Bluetooth in your device settings.'**
  String get bluetoothNotEnabledMessage;

  /// Error message when Bluetooth scan fails
  ///
  /// In en, this message translates to:
  /// **'Bluetooth scan failed'**
  String get bluetoothScanFailed;

  /// Title for scanned chip dialog
  ///
  /// In en, this message translates to:
  /// **'Chip ID Scanned'**
  String get chipIdScannedTitle;

  /// Label for scanned chip ID
  ///
  /// In en, this message translates to:
  /// **'Scanned ID'**
  String get scannedIdLabel;

  /// Question asking if user wants to validate scanned chip
  ///
  /// In en, this message translates to:
  /// **'Would you like to validate this chip ID?'**
  String get validateThisChipQuestion;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Validate button text
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// Scanner management screen title
  ///
  /// In en, this message translates to:
  /// **'Scanner Management'**
  String get scannerManagement;

  /// Message when no paired devices are found
  ///
  /// In en, this message translates to:
  /// **'No paired Bluetooth devices found. Pair a scanner in your device\'s Bluetooth settings.'**
  String get noPairedDevicesMessage;

  /// Device status section title
  ///
  /// In en, this message translates to:
  /// **'Device Status'**
  String get deviceStatus;

  /// Bluetooth label
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get bluetooth;

  /// Available status
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Unavailable status
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Title for Pro unlock dialog
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro Features'**
  String get unlockProFeatures;

  /// Label for Pro features
  ///
  /// In en, this message translates to:
  /// **'Pro Features'**
  String get proFeatures;

  /// Label for free features
  ///
  /// In en, this message translates to:
  /// **'Free Features'**
  String get freeFeatures;

  /// Text for one-time purchase
  ///
  /// In en, this message translates to:
  /// **'One-time purchase'**
  String get oneTimePurchase;

  /// Pro feature: Bluetooth scanning
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Scanning'**
  String get bluetoothScanningPro;

  /// Pro feature: NFC scanning
  ///
  /// In en, this message translates to:
  /// **'NFC Scanning'**
  String get nfcScanningPro;

  /// Pro feature: Device management
  ///
  /// In en, this message translates to:
  /// **'Device Management'**
  String get deviceManagementPro;

  /// Pro feature: Priority support
  ///
  /// In en, this message translates to:
  /// **'Priority Support'**
  String get prioritySupportPro;

  /// Description for Bluetooth scanning Pro feature
  ///
  /// In en, this message translates to:
  /// **'Connect to external RFID scanners via Bluetooth'**
  String get connectExternalScanners;

  /// Description for NFC scanning Pro feature
  ///
  /// In en, this message translates to:
  /// **'Use phone\'s built-in NFC reader for modern microchip tags'**
  String get tapToScanNFC;

  /// Description for device management Pro feature
  ///
  /// In en, this message translates to:
  /// **'Enhanced paired device information and status'**
  String get enhancedDeviceInfo;

  /// Description for priority support Pro feature
  ///
  /// In en, this message translates to:
  /// **'Get help when you need it most'**
  String get getHelpWhenNeeded;

  /// Button text to unlock Pro features
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro'**
  String get unlockPro;

  /// Button text to restore purchases
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// Button text to dismiss Pro dialog
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// Message when Pro features are unlocked
  ///
  /// In en, this message translates to:
  /// **'Pro features unlocked!'**
  String get proUnlocked;

  /// Message when checking for previous purchases
  ///
  /// In en, this message translates to:
  /// **'Checking for previous purchases...'**
  String get checkingPurchases;

  /// Error message when pricing cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Unable to load pricing information'**
  String get unableToLoadPricing;

  /// Message for locked Pro features
  ///
  /// In en, this message translates to:
  /// **'This feature requires Pro'**
  String get proFeatureLocked;

  /// NFC label
  ///
  /// In en, this message translates to:
  /// **'NFC'**
  String get nfc;

  /// Pro badge text
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get pro;

  /// Message when NFC is available
  ///
  /// In en, this message translates to:
  /// **'Your device\'s NFC is available. Tap the \'Scan with NFC\' button to begin.'**
  String get nfcAvailableMessage;

  /// Message for paired devices section
  ///
  /// In en, this message translates to:
  /// **'A list of your connected Bluetooth scanners will appear here.'**
  String get pairedDevicesMessage;

  /// Error message when NFC scan fails
  ///
  /// In en, this message translates to:
  /// **'NFC scan failed'**
  String get nfcScanFailed;

  /// Title for the Support (donations) page
  ///
  /// In en, this message translates to:
  /// **'Support Chip Companion'**
  String get supportTitle;

  /// Introductory text explaining voluntary support
  ///
  /// In en, this message translates to:
  /// **'Chip Companion is a solo project, built and maintained with passion.\n\nYour support helps cover costs and fund future development so the core features can stay free for everyone.'**
  String get supportIntro;

  /// Compliance note about donations and Google Play billing
  ///
  /// In en, this message translates to:
  /// **'Contributions are 100% voluntary and do not unlock features or content inside the app. For any in‑app purchases (like Pro features), Google Play billing is used. This page is only for optional donations.'**
  String get supportVoluntaryNote;

  /// Button label to donate via PayPal
  ///
  /// In en, this message translates to:
  /// **'Donate via PayPal'**
  String get donateViaPaypal;

  /// Button label linking to the Support page, clarifying voluntary nature
  ///
  /// In en, this message translates to:
  /// **'Support (Voluntary)'**
  String get supportVoluntaryButton;

  /// Title for the auto-validate on scan toggle
  ///
  /// In en, this message translates to:
  /// **'Auto-validate on scan'**
  String get autoValidateOnScanTitle;

  /// Subtitle for the auto-validate on scan toggle
  ///
  /// In en, this message translates to:
  /// **'When enabled, IDs scanned via Bluetooth or NFC will automatically validate on the Home screen'**
  String get autoValidateOnScanSubtitle;

  /// Tooltip/title for device actions menu
  ///
  /// In en, this message translates to:
  /// **'Device actions'**
  String get deviceActions;

  /// Title for the Glossary screen
  ///
  /// In en, this message translates to:
  /// **'Microchip Glossary'**
  String get glossaryTitle;

  /// No description provided for @bluetoothScannersIntro.
  ///
  /// In en, this message translates to:
  /// **'Connect to external RFID scanners via Bluetooth. These devices work like keyboards and automatically populate the chip ID field.'**
  String get bluetoothScannersIntro;

  /// No description provided for @nfcNdefSupportNote.
  ///
  /// In en, this message translates to:
  /// **'NFC NDEF tags (collars/cards) are supported: if a tag contains a chip ID in text/URL, the app will extract it, populate Home, and validate. Implanted FDX‑B chips still require an external 134.2 kHz reader.'**
  String get nfcNdefSupportNote;

  /// About section title in Glossary
  ///
  /// In en, this message translates to:
  /// **'About Chip Companion'**
  String get glossaryAboutTitle;

  /// About section body in Glossary
  ///
  /// In en, this message translates to:
  /// **'Chip Companion helps validate pet microchip ID formats and provides public registry contact guidance. You can scan microchips using compatible Bluetooth scanners or NFC (where supported) and, if enabled in Settings, new scans will auto‑validate on the Home screen.'**
  String get glossaryAboutBody;

  /// How validation works title
  ///
  /// In en, this message translates to:
  /// **'How validation works'**
  String get glossaryHowTitle;

  /// How validation works body
  ///
  /// In en, this message translates to:
  /// **'The app validates the structure of microchip IDs (length, character set, and known patterns) against common formats. Validation confirms that an ID looks correct, but it does not prove that a chip is registered or who owns it. For ownership and registration status, contact the appropriate registry directly.'**
  String get glossaryHowBody;

  /// No description provided for @glossaryISOTitle.
  ///
  /// In en, this message translates to:
  /// **'ISO 11784/11785 (FDX‑B)'**
  String get glossaryISOTitle;

  /// No description provided for @glossaryISOBody.
  ///
  /// In en, this message translates to:
  /// **'Standard 15‑digit numeric microchip. The first 3 digits (prefix) can indicate a country (001–899) or a manufacturer (900–998).'**
  String get glossaryISOBody;

  /// No description provided for @glossaryAvidTitle.
  ///
  /// In en, this message translates to:
  /// **'AVID 10‑digit'**
  String get glossaryAvidTitle;

  /// No description provided for @glossaryAvidBody.
  ///
  /// In en, this message translates to:
  /// **'Legacy/non‑ISO 10‑digit numeric format used by AVID PETtrac.'**
  String get glossaryAvidBody;

  /// No description provided for @glossaryLegacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Legacy 9‑digit'**
  String get glossaryLegacyTitle;

  /// No description provided for @glossaryLegacyBody.
  ///
  /// In en, this message translates to:
  /// **'Older 9‑digit numeric formats. Coverage varies; check multiple registries.'**
  String get glossaryLegacyBody;

  /// No description provided for @glossaryHexTitle.
  ///
  /// In en, this message translates to:
  /// **'Hex‑encoded ISO'**
  String get glossaryHexTitle;

  /// No description provided for @glossaryHexBody.
  ///
  /// In en, this message translates to:
  /// **'Some scanners or systems display a 15‑character hexadecimal representation. Convert to a 15‑digit decimal ISO number for official lookups.'**
  String get glossaryHexBody;

  /// No description provided for @glossaryScanningTitle.
  ///
  /// In en, this message translates to:
  /// **'Scanning methods'**
  String get glossaryScanningTitle;

  /// No description provided for @glossaryScanningBody.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth: Pair a compatible pet microchip scanner and scan from the Devices tab.\nNFC: On supported phones, tap a compatible chip to read its ID.\nAuto‑validate: Enable in Settings to automatically validate scanned IDs on the Home screen.'**
  String get glossaryScanningBody;

  /// No description provided for @glossaryDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer: This app provides format validation and public registry contact guidance for reference only. It does not perform official database lookups, confirm registration status, or store owner data. Manufacturer/Country code hints are based on public information and may not be guaranteed.'**
  String get glossaryDisclaimer;

  /// No description provided for @glossaryDigitsTitle.
  ///
  /// In en, this message translates to:
  /// **'What the 15 digits mean'**
  String get glossaryDigitsTitle;

  /// No description provided for @glossaryDigitsBody.
  ///
  /// In en, this message translates to:
  /// **'Digits 1–3: Country (001–899) or Manufacturer (900–998) prefix. Digits 4–14: Unique identifier. Digit 15: Sequence digit (not a check digit). Prefixes can hint at origin, but always verify registration with official registries.'**
  String get glossaryDigitsBody;

  /// No description provided for @glossaryEdgeCasesTitle.
  ///
  /// In en, this message translates to:
  /// **'Common edge cases'**
  String get glossaryEdgeCasesTitle;

  /// No description provided for @glossaryEdgeCasesBody.
  ///
  /// In en, this message translates to:
  /// **'Leading zeros may be omitted on labels; remove spaces and hyphens when typing. Hex vs decimal: convert hex to a 15‑digit decimal for lookups. Cloned or re‑encoded chips exist—validation confirms format only, not registration.'**
  String get glossaryEdgeCasesBody;

  /// No description provided for @glossaryBeyondTitle.
  ///
  /// In en, this message translates to:
  /// **'Beyond companion animals'**
  String get glossaryBeyondTitle;

  /// No description provided for @glossaryBeyondBody.
  ///
  /// In en, this message translates to:
  /// **'Pets typically use FDX‑B (ISO 11784/11785). Livestock and some industrial systems may use HDX or other technologies. This app focuses on pet microchip ID formats and guidance.'**
  String get glossaryBeyondBody;

  /// Title for the set alias dialog
  ///
  /// In en, this message translates to:
  /// **'Set device alias'**
  String get setDeviceAlias;

  /// Label for alias text field
  ///
  /// In en, this message translates to:
  /// **'Alias'**
  String get alias;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Menu item to remember device
  ///
  /// In en, this message translates to:
  /// **'Remember device'**
  String get rememberDevice;

  /// Menu item to forget device
  ///
  /// In en, this message translates to:
  /// **'Forget device'**
  String get forgetDevice;

  /// Menu item to set alias
  ///
  /// In en, this message translates to:
  /// **'Set alias'**
  String get setAlias;

  /// Menu item to disconnect device
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// Status label for unsupported capability
  ///
  /// In en, this message translates to:
  /// **'Unsupported'**
  String get unsupported;

  /// Status label for supported but turned off
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// Assurance line about one-time purchase and lifetime access
  ///
  /// In en, this message translates to:
  /// **'No subscription. Lifetime access to Pro features.'**
  String get noSubscriptionLifetimeAccess;

  /// Information banner shown on web about IAP unavailability
  ///
  /// In en, this message translates to:
  /// **'In-app purchases are not available on web. Use the Android/iOS app to unlock Pro with a one-time purchase (lifetime access) through official store billing.'**
  String get proWebPurchaseNotice;

  /// Info message explaining NFC has no paired devices list
  ///
  /// In en, this message translates to:
  /// **'NFC does not maintain a paired devices list. When available on your phone, simply tap a tag to scan—no pairing required.'**
  String get nfcNoPairedListInfo;

  /// Label for Bluetooth device class
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get deviceClass;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'he', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
