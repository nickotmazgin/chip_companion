import 'package:flutter_test/flutter_test.dart';
import 'package:chip_companion/services/validation/microchip_validator.dart';

void main() {
  group('MicrochipValidator', () {
    group('ISO 11784/11785 (15-digit decimal)', () {
      test('validates valid 15-digit ISO with country code', () {
        final result = MicrochipValidator.validate('840123456789012');
        expect(result.isValid, true);
        expect(result.standardId, 'iso_fdxb');
        expect(result.normalized, '840123456789012');
        expect(result.prefix, 840);
        expect(result.hint, 'Country code');
      });

      test('validates valid 15-digit ISO with manufacturer code', () {
        final result = MicrochipValidator.validate('981234567890123');
        expect(result.isValid, true);
        expect(result.standardId, 'iso_fdxb');
        expect(result.normalized, '981234567890123');
        expect(result.prefix, 981);
        expect(result.hint, 'Manufacturer code');
      });

      test('validates 15-digit ISO with spaces and dashes', () {
        final result = MicrochipValidator.validate('840 123 456 789 012');
        expect(result.isValid, true);
        expect(result.standardId, 'iso_fdxb');
        expect(result.normalized, '840123456789012');
      });

      test('validates 15-digit ISO with various separators', () {
        final result = MicrochipValidator.validate('840-123-456-789-012');
        expect(result.isValid, true);
        expect(result.normalized, '840123456789012');
      });

      test('validates ISO with prefix 900-998 as manufacturer', () {
        final result = MicrochipValidator.validate('900123456789012');
        expect(result.hint, 'Manufacturer code');
      });

      test('validates ISO with prefix 1-899 as country', () {
        final result = MicrochipValidator.validate('250123456789012');
        expect(result.hint, 'Country code');
      });
    });

    group('AVID 10-digit', () {
      test('validates valid 10-digit AVID format', () {
        final result = MicrochipValidator.validate('1234567890');
        expect(result.isValid, true);
        expect(result.standardId, 'avid_10');
        expect(result.normalized, '1234567890');
        expect(result.prefix, null);
        expect(result.hint, null);
      });

      test('validates 10-digit with spaces', () {
        final result = MicrochipValidator.validate('123 456 7890');
        expect(result.isValid, true);
        expect(result.standardId, 'avid_10');
        expect(result.normalized, '1234567890');
      });
    });

    group('Legacy 9-digit', () {
      test('validates valid 9-digit legacy format', () {
        final result = MicrochipValidator.validate('123456789');
        expect(result.isValid, true);
        expect(result.standardId, 'legacy_9');
        expect(result.normalized, '123456789');
        expect(result.prefix, null);
        expect(result.hint, null);
      });

      test('validates 9-digit with spaces and dashes', () {
        final result = MicrochipValidator.validate('123-456-789');
        expect(result.isValid, true);
        expect(result.standardId, 'legacy_9');
        expect(result.normalized, '123456789');
      });
    });

    group('Hex-15 format', () {
      test('validates valid hex-15 format (with letters)', () {
        final result = MicrochipValidator.validate('1A2B3C4D5E6F7AB');
        expect(result.isValid, true);
        expect(result.standardId, 'hex_15');
        // Should convert hex to decimal
        expect(result.normalized.isNotEmpty, true);
        expect(result.normalized.length, 15);
      });

      test('validates hex-15 with mixed case', () {
        final result = MicrochipValidator.validate('1a2B3c4D5e6F7aB');
        expect(result.isValid, true);
        expect(result.standardId, 'hex_15');
      });

      test('converts hex ABC123456789012 to decimal correctly', () {
        final result = MicrochipValidator.validate('ABC123456789012');
        expect(result.isValid, true);
        expect(result.standardId, 'hex_15');
        // ABC123456789012 in hex = 773513251999223826 in decimal (truncated to 15)
        expect(result.normalized, '773513251999223');
      });
    });

    group('Invalid formats', () {
      test('rejects empty string', () {
        final result = MicrochipValidator.validate('');
        expect(result.isValid, false);
        expect(result.standardId, 'unknown');
      });

      test('rejects too short chip ID', () {
        final result = MicrochipValidator.validate('12345678');
        expect(result.isValid, false);
        expect(result.standardId, 'unknown');
      });

      test('rejects too long chip ID', () {
        final result = MicrochipValidator.validate('1234567890123456');
        expect(result.isValid, false);
        expect(result.standardId, 'unknown');
      });

      test('rejects non-alphanumeric characters', () {
        final result = MicrochipValidator.validate('123456789@#\$');
        expect(result.isValid, false);
      });

      test('rejects 14-digit number', () {
        final result = MicrochipValidator.validate('12345678901234');
        expect(result.isValid, false);
      });

      test('rejects 11-digit number', () {
        final result = MicrochipValidator.validate('12345678901');
        expect(result.isValid, false);
      });
    });

    group('Edge cases', () {
      test('handles whitespace-only input', () {
        final result = MicrochipValidator.validate('   ');
        expect(result.isValid, false);
      });

      test('handles leading/trailing whitespace', () {
        final result = MicrochipValidator.validate('  840123456789012  ');
        expect(result.isValid, true);
        expect(result.normalized, '840123456789012');
      });

      test('handles multiple separators', () {
        final result = MicrochipValidator.validate('840 - 123 - 456 - 789 - 012');
        expect(result.isValid, true);
        expect(result.normalized, '840123456789012');
      });

      test('distinguishes hex from decimal 15-char', () {
        // All digits - should be ISO
        final decResult = MicrochipValidator.validate('123456789012345');
        expect(decResult.standardId, 'iso_fdxb');

        // Contains letters - should be hex_15
        final hexResult = MicrochipValidator.validate('12345678901234A');
        expect(hexResult.standardId, 'hex_15');
      });

      test('handles prefix edge cases', () {
        // Prefix 000 (no hint)
        final result000 = MicrochipValidator.validate('000123456789012');
        expect(result000.hint, null);

        // Prefix 001 (country)
        final result001 = MicrochipValidator.validate('001123456789012');
        expect(result001.hint, 'Country code');

        // Prefix 899 (country)
        final result899 = MicrochipValidator.validate('899123456789012');
        expect(result899.hint, 'Country code');

        // Prefix 900 (manufacturer)
        final result900 = MicrochipValidator.validate('900123456789012');
        expect(result900.hint, 'Manufacturer code');

        // Prefix 998 (manufacturer)
        final result998 = MicrochipValidator.validate('998123456789012');
        expect(result998.hint, 'Manufacturer code');

        // Prefix 999 (no hint)
        final result999 = MicrochipValidator.validate('999123456789012');
        expect(result999.hint, null);
      });
    });

    group('Separator handling', () {
      test('removes spaces correctly', () {
        expect(
          MicrochipValidator.validate('840 123 456 789 012').normalized,
          '840123456789012',
        );
      });

      test('removes dashes correctly', () {
        expect(
          MicrochipValidator.validate('840-123-456-789-012').normalized,
          '840123456789012',
        );
      });

      test('removes mixed separators', () {
        expect(
          MicrochipValidator.validate('840- 123 -456- 789 -012').normalized,
          '840123456789012',
        );
      });

      test('removes tabs and newlines', () {
        expect(
          MicrochipValidator.validate('840\t123\n456\r789 012').normalized,
          '840123456789012',
        );
      });
    });
  });
}

