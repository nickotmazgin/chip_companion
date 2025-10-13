// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Compagnon de Puce';

  @override
  String get validateButton => 'Valider le Format';

  @override
  String get enterChipId => 'Entrer l\'ID de la Puce';

  @override
  String get chipIdHint => 'Entrez un ID de 9, 10 ou 15 chiffres';

  @override
  String get validFormat => 'Format Valide ✓';

  @override
  String get invalidFormat => 'Format Invalide ✗';

  @override
  String get chipType => 'Type de Puce';

  @override
  String get formatDescription => 'Information sur le Format';

  @override
  String get suggestedRegistries => 'Information du Registre';

  @override
  String get contactRegistry => 'Contactez le registre pour vérification';

  @override
  String get helpTitle => 'Guide des Puces';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get languageSelection => 'Sélection de Langue';

  @override
  String get aboutDescription =>
      'Validateur professionnel de puces électroniques pour animaux et répertoire de registres. Validez les formats de puces électroniques, scannez avec des appareils Bluetooth et NFC, et accédez aux informations de contact des registres dans le monde entier.';

  @override
  String get helpContent =>
      'Outil professionnel de validation de puces électroniques avec capacités de scan Bluetooth et NFC. Validez les formats d\'ID de puce électronique selon les standards internationaux et accédez aux informations complètes de contact des registres.\n\nCette application fournit des services de validation de format et de répertoire de registres. Pour l\'identification officielle d\'animaux et les recherches dans les bases de données, contactez les professionnels vétérinaires et les registres officiels directement.';

  @override
  String get disclaimer =>
      '⚠️ Pour Référence Seulement\n\nCette application fournit des services de validation de format de puce électronique et de répertoire de registres. Elle ne se connecte pas aux bases de données en direct et ne fournit pas de recherches d\'identification d\'animaux réelles. Pour l\'identification officielle d\'animaux et les recherches dans les bases de données, contactez les professionnels vétérinaires et les registres officiels directement.';

  @override
  String get registryContacts => 'Contacts du Registre';

  @override
  String get website => 'Site Web';

  @override
  String get contactInfo => 'Informations de Contact';

  @override
  String get region => 'Région';

  @override
  String get verificationRequired =>
      '⚠️ Toujours vérifier avec les sources officielles';

  @override
  String get formatValidation => 'Validation du Format';

  @override
  String get learnMore => 'En savoir plus';

  @override
  String get invalidInput => 'Entrez un ID de puce valide';

  @override
  String get about => 'À Propos';

  @override
  String get forPetOwners =>
      'Pour les propriétaires d\'animaux et vétérinaires du monde entier';

  @override
  String get developer => 'Développeur';

  @override
  String get createdBy => 'Créé avec ❤️ par Nick Otmazgin';

  @override
  String get contact => 'Contact';

  @override
  String get support => 'Soutenir le Développement';

  @override
  String get helpImprove => 'Aidez à améliorer cette application';

  @override
  String get tipJar => 'Pourboires';

  @override
  String get supportedRegions => 'Régions Supportées';

  @override
  String get helpFAQ => 'Aide et FAQ';

  @override
  String get howToUse => 'Comment Utiliser';

  @override
  String get tips => 'Conseils et Astuces';

  @override
  String get troubleshooting => 'Dépannage';

  @override
  String get stepByStep => 'Guide Étape par Étape';

  @override
  String get step1 => '1. Entrez l\'ID de la micropuce de votre animal';

  @override
  String get step2 => '2. Appuyez sur \'Rechercher l\'ID\' pour chercher';

  @override
  String get step3 => '3. Consultez les détails d\'enregistrement';

  @override
  String get step4 => '4. Contactez le registre si nécessaire';

  @override
  String get globalRegistries => 'Registres Mondiaux d\'Animaux';

  @override
  String get notFound => 'Puce Non Trouvée?';

  @override
  String get tryThese => 'Essayez ces solutions:';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la Langue';

  @override
  String get enterMicrochipId =>
      'Entrez un ID de micropuce pour trouver les informations d\'enregistrement de l\'animal';

  @override
  String get globalCoverage =>
      '🌍 Couverture Mondiale • 🔍 Recherche Multi-Registres';

  @override
  String get trademarkNotice =>
      'Les noms de registres sont des marques déposées de leurs propriétaires respectifs';

  @override
  String get notAffiliated => 'Non affilié à aucune organisation de registre';

  @override
  String get educationalOnly => 'Validation de format professionnel uniquement';

  @override
  String get noOfficialLookup =>
      'Ne effectue pas de recherches officielles dans les bases de données';

  @override
  String get trademarkOwnership =>
      'Les noms de registres sont des marques déposées de leurs propriétaires';

  @override
  String get devicesTitle => 'Appareils';

  @override
  String get homeTitle => 'Accueil';

  @override
  String get bluetoothScanners => 'Scanners Bluetooth';

  @override
  String get nfcScanning => 'Scan NFC';

  @override
  String get pairedDevices => 'Appareils Appariés';

  @override
  String get startBluetoothScan => 'Démarrer le Scan Bluetooth';

  @override
  String get scanWithNFC => 'Scanner avec NFC';

  @override
  String get scanning => 'Scan en cours...';

  @override
  String get chipIdScanned => 'ID de Puce Scannée';

  @override
  String scannedId(String chipId) {
    return 'ID Scannée';
  }

  @override
  String get validateThisChip => 'Valider Cette Puce';

  @override
  String get bluetoothNotEnabled =>
      'Bluetooth n\'est pas activé. Veuillez activer Bluetooth dans les paramètres de votre appareil.';

  @override
  String get nfcNotAvailable => 'NFC n\'est pas disponible sur cet appareil.';

  @override
  String get noPairedDevices =>
      'Aucun appareil Bluetooth apparié trouvé. Appariez un scanner dans les paramètres Bluetooth de votre appareil.';

  @override
  String get scannerDisclaimers => 'Avertissements du Scanner';

  @override
  String get scannerCompatibilityDisclaimer =>
      'Le support du scanner est fourni pour les appareils Bluetooth compatibles. Nous ne fabriquons pas de scanners et ne pouvons garantir la compatibilité avec tous les modèles.';

  @override
  String get scannerDataDisclaimer =>
      'Les données scannées sont traitées localement uniquement pour validation immédiate et ne sont ni stockées ni transmises.';

  @override
  String get validationErrorOccurred =>
      'Une erreur de validation s\'est produite';

  @override
  String get professionalMicrochipValidator =>
      'Validateur Professionnel de Micropuces';

  @override
  String get validateChipFormatsAndFindRegistries =>
      'Validez les formats de puces et trouvez les contacts de registres';

  @override
  String get microchipIdInputField => 'Champ de saisie d\'ID de micropuce';

  @override
  String get enterMicrochipIdToValidate =>
      'Entrez un ID de micropuce pour valider son format';

  @override
  String get validatingMicrochipFormat => 'Validation du format de micropuce';

  @override
  String get validateMicrochipFormat => 'Valider le format de micropuce';

  @override
  String get validating => 'Validation...';

  @override
  String get validatingFormat => 'Validation du format...';

  @override
  String get developedBy => 'Développé par Nick Otmazgin';

  @override
  String get supportThisApp => 'Soutenir cette App';

  @override
  String get contactDeveloper => 'Contacter le Développeur';

  @override
  String get sourceCodeOnGitHub => 'Code Source sur GitHub';

  @override
  String get copyrightNotice => 'Copyright © 2025. Tous droits réservés.';

  @override
  String get emailCopiedToClipboard => 'Email copié dans le presse-papiers';

  @override
  String get errorOpeningEmail => 'Erreur lors de l\'ouverture de l\'email';

  @override
  String get paypalLinkCopiedToClipboard =>
      'Lien PayPal copié dans le presse-papiers';

  @override
  String get errorOpeningPaypal => 'Erreur lors de l\'ouverture de PayPal';

  @override
  String get version => 'Version 2.0.6';

  @override
  String get developerEmail => 'NickOtmazgin.Dev@gmail.com';

  @override
  String get israelSupport => 'Israël';

  @override
  String get israelSupportDescription =>
      'Support complet pour les registres vétérinaires israéliens et systèmes d\'identification d\'animaux';

  @override
  String get russiaSupport => 'Russie';

  @override
  String get russiaSupportDescription =>
      'Support complet pour les registres vétérinaires russes et systèmes de passeports animaux';

  @override
  String get worldwideSupport => 'Mondial';

  @override
  String get worldwideSupportDescription =>
      'Validation professionnelle de micropuces et répertoire de registres';

  @override
  String get madeWithLove =>
      'Fait avec ❤️ pour les propriétaires d\'animaux et vétérinaires';

  @override
  String get appDisclaimer =>
      'Cette application est conçue pour aider à réunir les animaux perdus avec leurs familles. Vérifiez toujours les informations avec les registres officiels et vétérinaires. Les résultats sont fournis à des fins informatives uniquement.';

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String get appInformation => 'Informations de l\'App';

  @override
  String get description => 'Description';

  @override
  String get bluetoothNotEnabledMessage =>
      'Bluetooth n\'est pas activé. Veuillez activer Bluetooth dans les paramètres de votre appareil.';

  @override
  String get bluetoothScanFailed => 'Échec du scan Bluetooth';

  @override
  String get chipIdScannedTitle => 'ID de Puce Scannée';

  @override
  String get scannedIdLabel => 'ID Scannée';

  @override
  String get validateThisChipQuestion => 'Voulez-vous valider cet ID de puce?';

  @override
  String get cancel => 'Annuler';

  @override
  String get validate => 'Valider';

  @override
  String get scannerManagement => 'Gestion des Scanners';

  @override
  String get noPairedDevicesMessage =>
      'Aucun appareil Bluetooth apparié trouvé. Appariez un scanner dans les paramètres Bluetooth de votre appareil.';

  @override
  String get deviceStatus => 'État de l\'Appareil';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get available => 'Disponible';

  @override
  String get unavailable => 'Indisponible';

  @override
  String get refresh => 'Actualiser';

  @override
  String get unlockProFeatures => 'Débloquer les Fonctionnalités Pro';

  @override
  String get proFeatures => 'Fonctionnalités Pro';

  @override
  String get freeFeatures => 'Fonctionnalités Gratuites';

  @override
  String get oneTimePurchase => 'Achat unique';

  @override
  String get bluetoothScanningPro => 'Scan Bluetooth';

  @override
  String get nfcScanningPro => 'Scan NFC';

  @override
  String get deviceManagementPro => 'Gestion des Appareils';

  @override
  String get prioritySupportPro => 'Support Prioritaire';

  @override
  String get connectExternalScanners =>
      'Connecter aux scanners RFID externes via Bluetooth';

  @override
  String get tapToScanNFC =>
      'Utiliser le lecteur NFC intégré du téléphone pour les étiquettes de micropuce modernes';

  @override
  String get enhancedDeviceInfo =>
      'Informations améliorées des appareils appariés et statut';

  @override
  String get getHelpWhenNeeded =>
      'Obtenez de l\'aide quand vous en avez le plus besoin';

  @override
  String get unlockPro => 'Débloquer Pro';

  @override
  String get restorePurchases => 'Restaurer les Achats';

  @override
  String get maybeLater => 'Peut-être Plus Tard';

  @override
  String get proUnlocked => 'Fonctionnalités Pro débloquées!';

  @override
  String get checkingPurchases => 'Vérification des achats précédents...';

  @override
  String get unableToLoadPricing =>
      'Impossible de charger les informations de prix';

  @override
  String get proFeatureLocked => 'Cette fonctionnalité nécessite Pro';

  @override
  String get nfc => 'NFC';

  @override
  String get pro => 'PRO';

  @override
  String get nfcAvailableMessage =>
      'Le NFC de votre appareil est disponible. Appuyez sur le bouton \'Scanner avec NFC\' pour commencer.';

  @override
  String get pairedDevicesMessage =>
      'Une liste de vos scanners Bluetooth connectés apparaîtra ici.';

  @override
  String get nfcScanFailed => 'Échec du scan NFC';

  @override
  String get supportTitle => 'Soutenir Chip Companion';

  @override
  String get supportIntro =>
      'Chip Companion est un projet individuel, construit et maintenu avec passion.\n\nVotre soutien aide à couvrir les coûts et à financer le développement futur afin que les fonctionnalités essentielles restent gratuites pour tous.';

  @override
  String get supportVoluntaryNote =>
      'Les contributions sont 100% volontaires et ne débloquent pas de fonctionnalités ou de contenu dans l\'application. Pour tout achat intégré (comme les fonctionnalités Pro), la facturation Google Play est utilisée. Cette page est uniquement destinée aux dons optionnels.';

  @override
  String get donateViaPaypal => 'Faire un don via PayPal';

  @override
  String get supportVoluntaryButton => 'Soutien (Volontaire)';

  @override
  String get autoValidateOnScanTitle => 'Validation automatique lors du scan';

  @override
  String get autoValidateOnScanSubtitle =>
      'Lorsqu\'elle est activée, les ID scannés via Bluetooth ou NFC seront automatiquement validés sur l\'écran d\'accueil';

  @override
  String get deviceActions => 'Actions de l\'appareil';

  @override
  String get glossaryTitle => 'Glossaire des puces électroniques';

  @override
  String get bluetoothScannersIntro =>
      'Connectez des lecteurs RFID externes via Bluetooth. Ces appareils fonctionnent comme des claviers et remplissent automatiquement le champ d’identifiant.';

  @override
  String get nfcNdefSupportNote =>
      'Les tags NFC NDEF (colliers/cartes) sont pris en charge : si un tag contient un identifiant dans un texte/URL, l’application l’extrait, remplit l’accueil et valide. Les puces implantées FDX‑B nécessitent toujours un lecteur 134,2 kHz externe.';

  @override
  String get glossaryAboutTitle => 'À propos de Chip Companion';

  @override
  String get glossaryAboutBody =>
      'Chip Companion aide à valider les formats d\'identifiants de puces électroniques pour animaux et fournit des informations de contact publiques des registres. Vous pouvez scanner des puces avec des scanners Bluetooth compatibles ou via le NFC (lorsque pris en charge) et, si activé dans les Paramètres, les nouveaux scans seront validés automatiquement sur l\'écran d\'accueil.';

  @override
  String get glossaryHowTitle => 'Comment fonctionne la validation';

  @override
  String get glossaryHowBody =>
      'L\'application valide la structure des identifiants de puces (longueur, jeu de caractères et modèles connus) par rapport aux formats courants. La validation confirme qu\'un identifiant semble correct, mais ne prouve pas qu\'une puce est enregistrée ni qui en est le propriétaire. Pour l\'état d\'enregistrement et la propriété, contactez directement le registre approprié.';

  @override
  String get glossaryISOTitle => 'ISO 11784/11785 (FDX‑B)';

  @override
  String get glossaryISOBody =>
      'Puce standard numérique à 15 chiffres. Les 3 premiers chiffres (préfixe) peuvent indiquer un pays (001–899) ou un fabricant (900–998).';

  @override
  String get glossaryAvidTitle => 'AVID 10 chiffres';

  @override
  String get glossaryAvidBody =>
      'Format numérique non ISO à 10 chiffres utilisé par AVID PETtrac.';

  @override
  String get glossaryLegacyTitle => 'Ancien format 9 chiffres';

  @override
  String get glossaryLegacyBody =>
      'Anciens formats numériques à 9 chiffres. Couverture variable ; vérifiez plusieurs registres.';

  @override
  String get glossaryHexTitle => 'ISO encodé en hexadécimal';

  @override
  String get glossaryHexBody =>
      'Certains scanners ou systèmes affichent une représentation hexadécimale de 15 caractères. Convertissez en un numéro ISO décimal à 15 chiffres pour les recherches officielles.';

  @override
  String get glossaryScanningTitle => 'Méthodes de scan';

  @override
  String get glossaryScanningBody =>
      'Bluetooth : Associez un scanner compatible et scannez depuis l\'onglet Appareils.\nNFC : Sur les téléphones pris en charge, approchez une puce compatible pour lire son identifiant.\nValidation automatique : Activez-la dans Paramètres pour valider automatiquement les identifiants scannés sur l\'écran d\'accueil.';

  @override
  String get glossaryDisclaimer =>
      'Avertissement : Cette application fournit une validation de format et des informations de contact des registres à titre indicatif uniquement. Elle n\'effectue pas de recherches officielles en base de données, ne confirme pas l\'état d\'enregistrement et ne stocke pas de données de propriétaires. Les indications sur les codes Fabricant/Pays sont basées sur des informations publiques et ne sont pas garanties.';

  @override
  String get glossaryDigitsTitle => 'Ce que signifient les 15 chiffres';

  @override
  String get glossaryDigitsBody =>
      'Chiffres 1–3 : préfixe Pays (001–899) ou Fabricant (900–998). Chiffres 4–14 : identifiant unique. Chiffre 15 : chiffre de séquence (pas un chiffre de contrôle). Les préfixes peuvent donner un indice, mais vérifiez toujours l’enregistrement auprès des registres officiels.';

  @override
  String get glossaryEdgeCasesTitle => 'Cas particuliers courants';

  @override
  String get glossaryEdgeCasesBody =>
      'Les zéros initiaux peuvent être omis sur les étiquettes ; supprimez espaces et tirets lors de la saisie. Hexadécimal vs décimal : convertissez l’hexadécimal en un ISO décimal à 15 chiffres pour les recherches. Des puces clonées ou ré‑encodées existent — la validation ne confirme que le format, pas l’enregistrement.';

  @override
  String get glossaryBeyondTitle => 'Au‑delà des animaux de compagnie';

  @override
  String get glossaryBeyondBody =>
      'Les animaux de compagnie utilisent généralement FDX‑B (ISO 11784/11785). Le bétail et certains systèmes industriels peuvent utiliser HDX ou d’autres technologies. Cette application se concentre sur les formats d’ID de puce pour animaux de compagnie et l’orientation correspondante.';

  @override
  String get setDeviceAlias => 'Définir un alias de l\'appareil';

  @override
  String get alias => 'Alias';

  @override
  String get save => 'Enregistrer';

  @override
  String get rememberDevice => 'Mémoriser l\'appareil';

  @override
  String get forgetDevice => 'Oublier l\'appareil';

  @override
  String get setAlias => 'Définir un alias';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get unsupported => 'Non pris en charge';

  @override
  String get off => 'Éteint';

  @override
  String get noSubscriptionLifetimeAccess =>
      'Pas d\'abonnement. Accès à vie aux fonctionnalités Pro.';

  @override
  String get proWebPurchaseNotice =>
      'Les achats intégrés ne sont pas disponibles sur le web. Utilisez l\'application Android/iOS pour débloquer Pro avec un achat unique (accès à vie) via la facturation officielle du store.';

  @override
  String get nfcNoPairedListInfo =>
      'Le NFC ne maintient pas de liste d\'appareils appariés. Lorsqu\'il est disponible sur votre téléphone, il suffit d\'approcher une étiquette pour scanner—aucun appariement requis.';

  @override
  String get deviceClass => 'Classe';
}
