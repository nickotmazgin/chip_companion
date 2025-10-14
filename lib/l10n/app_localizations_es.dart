// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Compañero de Chip';

  @override
  String get validateButton => 'Validar Formato';

  @override
  String get enterChipId => 'Introducir ID de microchip';

  @override
  String get chipIdHint => 'Introduzca un ID de 9, 10 o 15 dígitos';

  @override
  String get validFormat => 'Formato Válido ✓';

  @override
  String get invalidFormat => 'Formato Inválido ✗';

  @override
  String get chipType => 'Tipo de Chip';

  @override
  String get formatDescription => 'Información de Formato';

  @override
  String get suggestedRegistries => 'Información de Registro';

  @override
  String get contactRegistry => 'Contacte al registro para verificación';

  @override
  String get helpTitle => 'Guía de Microchip';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get languageSelection => 'Selección de Idioma';

  @override
  String get aboutDescription =>
      'Compañero de Chip es una herramienta profesional para validación de formatos de microchip con capacidades de escaneo Bluetooth y NFC y directorio completo de registros.';

  @override
  String get helpContent =>
      'Herramienta profesional de validación de microchips con capacidades de escaneo Bluetooth y NFC. Valide formatos de ID de microchip contra estándares internacionales y acceda a información completa de contacto de registros.\n\nEsta aplicación proporciona servicios de validación de formato y directorio de registros. Para identificación oficial de mascotas y búsquedas en bases de datos, contacte profesionales veterinarios y registros oficiales directamente.';

  @override
  String get disclaimer =>
      '⚠️ Solo para Referencia\n\nEsta aplicación proporciona servicios de validación de formato de microchip y directorio de registros. No se conecta a bases de datos en vivo ni proporciona búsquedas de identificación de mascotas reales. Para identificación oficial de mascotas y búsquedas en bases de datos, contacte profesionales veterinarios y registros oficiales directamente.';

  @override
  String get registryContacts => 'Información de Registro';

  @override
  String get website => 'Sitio Web';

  @override
  String get contactInfo => 'Información de Contacto';

  @override
  String get region => 'Región';

  @override
  String get verificationRequired =>
      '⚠️ Verifique siempre con fuentes oficiales';

  @override
  String get formatValidation => 'Validación de Formato';

  @override
  String get learnMore => 'Aprender más';

  @override
  String get invalidInput => 'Ingrese un ID de microchip válido';

  @override
  String get about => 'Acerca de';

  @override
  String get forPetOwners =>
      'Para dueños de mascotas y veterinarios en todo el mundo';

  @override
  String get developer => 'Desarrollador';

  @override
  String get createdBy => 'Creado con ❤️ por Nick Otmazgin';

  @override
  String get contact => 'Contacto';

  @override
  String get support => 'Apoyar el Desarrollo';

  @override
  String get helpImprove => 'Ayuda a mejorar esta aplicación';

  @override
  String get tipJar => 'Propinas';

  @override
  String get supportedRegions => 'Regiones Compatibles';

  @override
  String get helpFAQ => 'Ayuda y Preguntas Frecuentes';

  @override
  String get howToUse => 'Cómo Usar';

  @override
  String get tips => 'Consejos y Trucos';

  @override
  String get troubleshooting => 'Solución de Problemas';

  @override
  String get stepByStep => 'Guía Paso a Paso';

  @override
  String get step1 => '1. Ingrese el ID del microchip de su mascota';

  @override
  String get step2 => '2. Toque \'Buscar ID\' para buscar';

  @override
  String get step3 => '3. Vea los detalles de registro';

  @override
  String get step4 => '4. Contacte el registro si es necesario';

  @override
  String get globalRegistries => 'Registros Globales de Mascotas';

  @override
  String get notFound => 'No Encontrado';

  @override
  String get tryThese => 'Pruebe estas soluciones:';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get enterMicrochipId =>
      'Ingrese un ID de microchip para encontrar información de registro de mascotas';

  @override
  String get globalCoverage =>
      '🌍 Cobertura Global • 🔍 Búsqueda Multi-Registro';

  @override
  String get trademarkNotice =>
      'Los nombres de registros son marcas registradas de sus respectivos propietarios';

  @override
  String get notAffiliated =>
      'No afiliado con ninguna organización de registro';

  @override
  String get educationalOnly =>
      'Validación de formato y directorio de registros';

  @override
  String get noOfficialLookup =>
      'No realiza búsquedas oficiales en bases de datos';

  @override
  String get trademarkOwnership =>
      'Los nombres de registros son marcas registradas de sus propietarios';

  @override
  String get devicesTitle => 'Dispositivos';

  @override
  String get homeTitle => 'Inicio';

  @override
  String get bluetoothScanners => 'Escáneres Bluetooth';

  @override
  String get nfcScanning => 'Escaneo NFC';

  @override
  String get pairedDevices => 'Dispositivos Emparejados';

  @override
  String get startBluetoothScan => 'Iniciar Escaneo Bluetooth';

  @override
  String get scanWithNFC => 'Escanear con NFC';

  @override
  String get scanning => 'Escaneando...';

  @override
  String get chipIdScanned => 'ID de Chip Escaneado';

  @override
  String scannedId(String chipId) {
    return 'ID Escaneado';
  }

  @override
  String get validateThisChip => 'Validar Este Chip';

  @override
  String get bluetoothNotEnabled =>
      'Bluetooth no está habilitado. Active Bluetooth en la configuración de su dispositivo.';

  @override
  String get nfcNotAvailable => 'NFC no está disponible en este dispositivo.';

  @override
  String get noPairedDevices =>
      'No se encontraron dispositivos Bluetooth emparejados. Empareje un escáner en la configuración Bluetooth de su dispositivo.';

  @override
  String get scannerDisclaimers => 'Avisos del Escáner';

  @override
  String get scannerCompatibilityDisclaimer =>
      'El soporte del escáner se proporciona para dispositivos Bluetooth compatibles. No fabricamos escáneres y no podemos garantizar la compatibilidad con todos los modelos.';

  @override
  String get scannerDataDisclaimer =>
      'Los datos escaneados se procesan localmente solo para validación inmediata y no se almacenan ni transmiten.';

  @override
  String get validationErrorOccurred => 'Ocurrió un error de validación';

  @override
  String get professionalMicrochipValidator =>
      'Validador Profesional de Microchips';

  @override
  String get validateChipFormatsAndFindRegistries =>
      'Valida formatos de chips y encuentra contactos de registros';

  @override
  String get microchipIdInputField => 'Campo de entrada de ID de microchip';

  @override
  String get enterMicrochipIdToValidate =>
      'Ingrese un ID de microchip para validar su formato';

  @override
  String get validatingMicrochipFormat => 'Validando formato de microchip';

  @override
  String get validateMicrochipFormat => 'Validar formato de microchip';

  @override
  String get validating => 'Validando...';

  @override
  String get validatingFormat => 'Validando formato...';

  @override
  String get developedBy => 'Desarrollado por Nick Otmazgin';

  @override
  String get supportThisApp => 'Apoyar esta App';

  @override
  String get contactDeveloper => 'Contactar Desarrollador';

  @override
  String get sourceCodeOnGitHub => 'Código Fuente en GitHub';

  @override
  String get copyrightNotice =>
      'Copyright © 2025. Todos los derechos reservados.';

  @override
  String get emailCopiedToClipboard => 'Email copiado al portapapeles';

  @override
  String get errorOpeningEmail => 'Error al abrir email';

  @override
  String get paypalLinkCopiedToClipboard =>
      'Enlace PayPal copiado al portapapeles';

  @override
  String get errorOpeningPaypal => 'Error al abrir PayPal';

  @override
  String get version => 'Versión';

  @override
  String get developerEmail => 'NickOtmazgin.Dev@gmail.com';

  @override
  String get israelSupport => 'Israel';

  @override
  String get israelSupportDescription =>
      'Soporte completo para registros veterinarios israelíes y sistemas de identificación de mascotas';

  @override
  String get russiaSupport => 'Rusia';

  @override
  String get russiaSupportDescription =>
      'Soporte completo para registros veterinarios rusos y sistemas de pasaportes animales';

  @override
  String get worldwideSupport => 'Mundial';

  @override
  String get worldwideSupportDescription =>
      'Validación profesional de microchips y directorio de registros';

  @override
  String get madeWithLove =>
      'Hecho con ❤️ para dueños de mascotas y veterinarios';

  @override
  String get appDisclaimer =>
      'Esta aplicación está diseñada para ayudar a reunir mascotas perdidas con sus familias. Siempre verifique la información con registros oficiales y veterinarios. Los resultados se proporcionan solo con fines informativos.';

  @override
  String get quickActions => 'Acciones Rápidas';

  @override
  String get appInformation => 'Información de la App';

  @override
  String get description => 'Descripción';

  @override
  String get bluetoothNotEnabledMessage =>
      'Bluetooth no está habilitado. Por favor, habilite Bluetooth en la configuración de su dispositivo.';

  @override
  String get bluetoothScanFailed => 'Falló el escaneo Bluetooth';

  @override
  String get chipIdScannedTitle => 'ID de Chip Escaneado';

  @override
  String get scannedIdLabel => 'ID Escaneado';

  @override
  String get validateThisChipQuestion =>
      '¿Le gustaría validar este ID de chip?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get validate => 'Validar';

  @override
  String get scannerManagement => 'Gestión de Escáneres';

  @override
  String get noPairedDevicesMessage =>
      'No se encontraron dispositivos Bluetooth emparejados. Empareje un escáner en la configuración Bluetooth de su dispositivo.';

  @override
  String get deviceStatus => 'Estado del Dispositivo';

  @override
  String get bluetooth => 'Bluetooth';

  @override
  String get available => 'Disponible';

  @override
  String get unavailable => 'No Disponible';

  @override
  String get refresh => 'Actualizar';

  @override
  String get unlockProFeatures => 'Desbloquear Características Pro';

  @override
  String get proFeatures => 'Características Pro';

  @override
  String get freeFeatures => 'Características Gratuitas';

  @override
  String get oneTimePurchase => 'Compra única';

  @override
  String get bluetoothScanningPro => 'Escaneo Bluetooth';

  @override
  String get nfcScanningPro => 'Escaneo NFC';

  @override
  String get deviceManagementPro => 'Gestión de Dispositivos';

  @override
  String get prioritySupportPro => 'Soporte Prioritario';

  @override
  String get connectExternalScanners =>
      'Conectar a escáneres RFID externos vía Bluetooth';

  @override
  String get tapToScanNFC =>
      'Usar el lector NFC integrado del teléfono para etiquetas de microchip modernas';

  @override
  String get enhancedDeviceInfo =>
      'Información mejorada de dispositivos emparejados y estado';

  @override
  String get getHelpWhenNeeded => 'Obtén ayuda cuando más la necesites';

  @override
  String get unlockPro => 'Desbloquear Pro';

  @override
  String get restorePurchases => 'Restaurar Compras';

  @override
  String get maybeLater => 'Tal Vez Más Tarde';

  @override
  String get proUnlocked => '¡Características Pro desbloqueadas!';

  @override
  String get checkingPurchases => 'Verificando compras anteriores...';

  @override
  String get unableToLoadPricing =>
      'No se puede cargar la información de precios';

  @override
  String get proFeatureLocked => 'Esta característica requiere Pro';

  @override
  String get nfc => 'NFC';

  @override
  String get pro => 'PRO';

  @override
  String get nfcAvailableMessage =>
      'El NFC de su dispositivo está disponible. Toque el botón \'Escanear con NFC\' para comenzar.';

  @override
  String get pairedDevicesMessage =>
      'Aquí aparecerá una lista de sus escáneres Bluetooth conectados.';

  @override
  String get nfcScanFailed => 'Falló el escaneo NFC';

  @override
  String get supportTitle => 'Apoyar a Chip Companion';

  @override
  String get supportIntro =>
      'Chip Companion es un proyecto individual, construido y mantenido con pasión.\n\nSu apoyo ayuda a cubrir costos y financiar el desarrollo futuro para que las funciones centrales sigan siendo gratuitas para todos.';

  @override
  String get supportVoluntaryNote =>
      'Las contribuciones son 100% voluntarias y no desbloquean funciones ni contenido dentro de la aplicación. Para cualquier compra dentro de la app (como funciones Pro), se utiliza la facturación de Google Play. Esta página es solo para donaciones opcionales.';

  @override
  String get donateViaPaypal => 'Donar vía PayPal';

  @override
  String get supportVoluntaryButton => 'Apoyo (Voluntario)';

  @override
  String get autoValidateOnScanTitle => 'Validación automática al escanear';

  @override
  String get autoValidateOnScanSubtitle =>
      'Cuando está habilitada, los IDs escaneados mediante Bluetooth o NFC se validarán automáticamente en la pantalla de Inicio';

  @override
  String get deviceActions => 'Acciones del dispositivo';

  @override
  String get glossaryTitle => 'Glosario de microchips';

  @override
  String get bluetoothScannersIntro =>
      'Conéctate a lectores RFID externos por Bluetooth. Estos dispositivos funcionan como teclados y rellenan automáticamente el campo de ID del chip.';

  @override
  String get nfcNdefSupportNote =>
      'Se admiten etiquetas NFC NDEF (collares/tarjetas): si una etiqueta contiene un ID en texto/URL, la app lo extrae, completa Inicio y valida. Los microchips implantados FDX‑B aún requieren un lector externo de 134,2 kHz.';

  @override
  String get glossaryAboutTitle => 'Acerca de Chip Companion';

  @override
  String get glossaryAboutBody =>
      'Chip Companion ayuda a validar los formatos de ID de microchip para mascotas y proporciona información pública de contacto de los registros. Puede escanear microchips con escáneres Bluetooth compatibles o NFC (cuando esté disponible) y, si está habilitado en Configuración, las nuevas lecturas se validarán automáticamente en la pantalla de Inicio.';

  @override
  String get glossaryHowTitle => 'Cómo funciona la validación';

  @override
  String get glossaryHowBody =>
      'La aplicación valida la estructura de los IDs de microchip (longitud, conjunto de caracteres y patrones conocidos) según formatos comunes. La validación confirma que un ID parece correcto, pero no prueba que el microchip esté registrado ni quién es su propietario. Para el estado de registro y la propiedad, contacte directamente con el registro correspondiente.';

  @override
  String get glossaryISOTitle => 'ISO 11784/11785 (FDX‑B)';

  @override
  String get glossaryISOBody =>
      'Microchip numérico estándar de 15 dígitos. Los primeros 3 dígitos (prefijo) pueden indicar un país (001–899) o un fabricante (900–998).';

  @override
  String get glossaryAvidTitle => 'AVID de 10 dígitos';

  @override
  String get glossaryAvidBody =>
      'Formato numérico no ISO de 10 dígitos utilizado por AVID PETtrac.';

  @override
  String get glossaryLegacyTitle => 'Formato antiguo de 9 dígitos';

  @override
  String get glossaryLegacyBody =>
      'Formatos numéricos antiguos de 9 dígitos. La cobertura varía; verifique varios registros.';

  @override
  String get glossaryHexTitle => 'ISO codificado en hexadecimal';

  @override
  String get glossaryHexBody =>
      'Algunos escáneres o sistemas muestran una representación hexadecimal de 15 caracteres. Conviértalo a un número ISO decimal de 15 dígitos para búsquedas oficiales.';

  @override
  String get glossaryScanningTitle => 'Métodos de escaneo';

  @override
  String get glossaryScanningBody =>
      'Bluetooth: Empareje un escáner de microchips compatible y escanee desde la pestaña Dispositivos.\nNFC: En teléfonos compatibles, acerque un microchip compatible para leer su ID.\nValidación automática: Actívela en Configuración para validar automáticamente los IDs escaneados en la pantalla de Inicio.';

  @override
  String get glossaryDisclaimer =>
      'Aviso: Esta aplicación ofrece validación de formato e información de contacto de registros públicos solo como referencia. No realiza búsquedas oficiales en bases de datos, no confirma el estado de registro ni almacena datos de propietarios. Las indicaciones de códigos de Fabricante/País se basan en información pública y no están garantizadas.';

  @override
  String get glossaryDigitsTitle => 'Qué significan los 15 dígitos';

  @override
  String get glossaryDigitsBody =>
      'Dígitos 1–3: prefijo de País (001–899) o Fabricante (900–998). Dígitos 4–14: identificador único. Dígito 15: dígito de secuencia (no un dígito de control). Los prefijos pueden sugerir el origen, pero verifique siempre el registro con los registros oficiales.';

  @override
  String get glossaryEdgeCasesTitle => 'Casos límite comunes';

  @override
  String get glossaryEdgeCasesBody =>
      'Los ceros iniciales pueden omitirse en las etiquetas; elimine espacios y guiones al escribir. Hexadecimal vs decimal: convierta el hexadecimal a un ISO decimal de 15 dígitos para las búsquedas. Existen chips clonados o re‑codificados: la validación confirma el formato, no el registro.';

  @override
  String get glossaryBeyondTitle => 'Más allá de los animales de compañía';

  @override
  String get glossaryBeyondBody =>
      'Las mascotas suelen usar FDX‑B (ISO 11784/11785). El ganado y algunos sistemas industriales pueden usar HDX u otras tecnologías. Esta app se centra en los formatos de ID de microchip de mascotas y la orientación correspondiente.';

  @override
  String get setDeviceAlias => 'Establecer alias del dispositivo';

  @override
  String get alias => 'Alias';

  @override
  String get save => 'Guardar';

  @override
  String get rememberDevice => 'Recordar dispositivo';

  @override
  String get forgetDevice => 'Olvidar dispositivo';

  @override
  String get setAlias => 'Establecer alias';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get unsupported => 'No compatible';

  @override
  String get off => 'Apagado';

  @override
  String get noSubscriptionLifetimeAccess =>
      'Sin suscripción. Acceso de por vida a las funciones Pro.';

  @override
  String get proWebPurchaseNotice =>
      'Las compras dentro de la aplicación no están disponibles en la web. Use la app de Android/iOS para desbloquear Pro con una compra única (acceso de por vida) a través de la facturación oficial de la tienda.';

  @override
  String get nfcNoPairedListInfo =>
      'NFC no mantiene una lista de dispositivos emparejados. Cuando esté disponible en su teléfono, simplemente toque una etiqueta para escanear—no se requiere emparejamiento.';

  @override
  String get deviceClass => 'Clase';
}
