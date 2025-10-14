// Conditional export: use a web-safe implementation in browsers,
// and the IO (mobile) implementation elsewhere.
export 'nfc_scanner_service_web.dart'
  if (dart.library.io) 'nfc_scanner_service_io.dart';
