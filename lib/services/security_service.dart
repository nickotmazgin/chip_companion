/// Security service for input validation and sanitization
/// Protects against malicious input and ensures data integrity
class SecurityService {
  static const int maxChipIdLength = 20;
  static const int minChipIdLength = 9;

  /// Sanitize chip ID by removing whitespace and dashes
  /// Returns a clean string with only alphanumeric characters (hex + digits)
  static String sanitizeChipId(String s) {
    return s.trim().replaceAll(RegExp(r'[\s-]'), '');
  }

  static String? validateAndSanitizeChipId(String input) {
    if (input.isEmpty) return null;

    // Reject obvious script / SQL / event handler markers
    final lowered = input.toLowerCase();
    const blockedSubstrings = [
      '<script',
      'javascript:',
      'onerror=',
      'onload=',
      'union ',
      'select ',
      'insert ',
      'update ',
      'delete ',
      'drop ',
      'alter ',
      'create ',
    ];
    if (blockedSubstrings.any(lowered.contains)) return null;

    // Keep only hex + digits (support legacy hex-based encodings) and dashes/spaces
    var sanitized = input.replaceAll(RegExp(r'[^0-9A-Fa-f\s\-]'), '');
    // Remove spaces/dashes for validation
    sanitized = sanitized.replaceAll(RegExp(r'[\s\-]'), '').toUpperCase();

    if (sanitized.length < minChipIdLength || sanitized.length > maxChipIdLength) {
      return null;
    }
    // Allow only digits or hex (legacy chips sometimes hex)
    if (!RegExp(r'^[0-9A-F]+$').hasMatch(sanitized)) return null;

    return sanitized;
  }

  static bool isSafeForDisplay(String value) {
    if (value.length > 200) return false;
    return RegExp(r'^[0-9A-F\- ]+$').hasMatch(value);
  }

  static String escapeForDisplay(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }

  // Additional methods for backward compatibility with tests
  static bool isValidLanguageCode(String code) {
    final languagePattern = RegExp(r'^[a-z]{2}(-[A-Z]{2})?$');
    return languagePattern.hasMatch(code);
  }

  static String sanitizeString(String input) {
    if (input.isEmpty) return input;

    // Escape potentially dangerous characters for display
    String sanitized = input.trim();
    sanitized = sanitized
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');

    // Limit length to prevent abuse
    if (sanitized.length > 1000) {
      sanitized = sanitized.substring(0, 1000);
    }

    return sanitized;
  }

  static bool containsMaliciousPattern(String input) {
    final lowered = input.toLowerCase();
    const blockedSubstrings = [
      '<script',
      'javascript:',
      'onerror=',
      'onload=',
      'union ',
      'select ',
      'insert ',
      'update ',
      'delete ',
      'drop ',
      'alter ',
      'create ',
    ];
    return blockedSubstrings.any(lowered.contains);
  }

  static bool isValidHttpsUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'https' && uri.hasAuthority && uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static String generateSecureId() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final buffer = StringBuffer();

    for (int i = 0; i < 16; i++) {
      buffer.write(chars[((random + i) * 7) % chars.length]);
    }

    return buffer.toString();
  }

  static bool isValidWebsiteUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'https' || uri.scheme == 'http') &&
          uri.hasAuthority &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
