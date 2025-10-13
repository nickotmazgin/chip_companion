// Microchip validation module for pet microchip IDs
// Supports ISO 11784/11785 (FDX-B), AVID 10-digit, legacy 9-digit, and hex-15 formats

class ChipValidationResult {
  final bool isValid;
  final String standardId; // iso_fdxb | avid_10 | legacy_9 | hex_15 | unknown
  final int? prefix; // first 3 digits for 15-decimal
  final String? hint; // country/manufacturer hint
  final String normalized; // normalized decimal; equals input for non-hex

  const ChipValidationResult(
    this.isValid,
    this.standardId,
    this.normalized, {
    this.prefix,
    this.hint,
  });

  @override
  String toString() =>
      'ChipValidationResult(isValid: $isValid, standardId: $standardId, '
      'normalized: $normalized, prefix: $prefix, hint: $hint)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChipValidationResult &&
          runtimeType == other.runtimeType &&
          isValid == other.isValid &&
          standardId == other.standardId &&
          prefix == other.prefix &&
          hint == other.hint &&
          normalized == other.normalized;

  @override
  int get hashCode =>
      isValid.hashCode ^
      standardId.hashCode ^
      prefix.hashCode ^
      hint.hashCode ^
      normalized.hashCode;
}

class MicrochipValidator {
  static final _dec = RegExp(r'^[0-9]+$');
  static final _hex = RegExp(r'^[0-9A-Fa-f]+$');

  /// Validate a microchip ID and return validation result
  static ChipValidationResult validate(String raw) {
    // Remove whitespace and dashes
    final s = raw.trim().replaceAll(RegExp(r'[\s-]'), '').toUpperCase();

    if (s.isEmpty) {
      return const ChipValidationResult(false, 'unknown', '');
    }

    // Check for 15-character formats
    if (s.length == 15) {
      final isAllDecimal = _dec.hasMatch(s);
      final isValidHex = _hex.hasMatch(s);

      if (isAllDecimal) {
        // Pure decimal 15-digit -> ISO FDX-B
        return _isoCheck(s, 'iso_fdxb');
      } else if (isValidHex) {
        // Contains A-F -> hex-15 format
        final dec = _hexToIsoDecimal(s);
        return _isoCheck(dec, 'hex_15');
      }
    }

    // Check decimal formats
    if (_dec.hasMatch(s)) {
      if (s.length == 10) {
        return ChipValidationResult(true, 'avid_10', s);
      }
      if (s.length == 9) {
        return ChipValidationResult(true, 'legacy_9', s);
      }
    }

    return const ChipValidationResult(false, 'unknown', '');
  }

  /// Check ISO 11784/11785 format and extract prefix/hint
  static ChipValidationResult _isoCheck(String d, String id) {
    if (d.length != 15 || !_dec.hasMatch(d)) {
      return ChipValidationResult(false, id, '');
    }

    final prefix = int.parse(d.substring(0, 3));
    final hint = (prefix >= 1 && prefix <= 899)
        ? 'Country code'
        : (prefix >= 900 && prefix <= 998)
            ? 'Manufacturer code'
            : null;

    return ChipValidationResult(
      true,
      id,
      d,
      prefix: prefix,
      hint: hint,
    );
  }

  /// Convert hex-15 to ISO decimal (15-digit decimal string)
  /// Uses BigInt for accurate large number conversion
  /// Note: 15-char hex can represent values larger than 15-digit decimal can hold,
  /// so we truncate or pad to exactly 15 digits
  static String _hexToIsoDecimal(String hex15) {
    try {
      // Parse hex string as BigInt
      final value = BigInt.parse(hex15, radix: 16);
      // Convert to decimal string
      final decimal = value.toString();
      
      // Ensure exactly 15 digits: truncate from left if longer, pad left if shorter
      if (decimal.length > 15) {
        return decimal.substring(0, 15);
      } else {
        return decimal.padLeft(15, '0');
      }
    } catch (e) {
      // If conversion fails, return zeros as fallback
      return '000000000000000';
    }
  }
}

