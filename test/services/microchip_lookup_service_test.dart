import 'package:flutter_test/flutter_test.dart';
import 'package:chip_companion/services/microchip_lookup_service.dart';

void main() {
  group('MicrochipLookupService format detection & decoding', () {
    test('Detects ISO and decodes country code 840 (United States)', () async {
      final result = await MicrochipLookupService.validateChipFormat('840123456789012');
      expect(result.isValidFormat, isTrue);
      expect(result.chipType, 'ISO 11784/11785');
      expect(result.manufacturerHint, contains('Country code 840'));
      expect(result.manufacturerHint, contains('United States'));
    });

    test('Detects ISO and decodes manufacturer code 981 (Datamars/Destron hint)', () async {
      final result = await MicrochipLookupService.validateChipFormat('981000000000000');
      expect(result.isValidFormat, isTrue);
      expect(result.chipType, 'ISO 11784/11785');
      // Implementation now returns descriptive hint like
      // "Destron Fearing / Datamars (ICAR code 981)"
      expect(result.manufacturerHint, anyOf(
        contains('ICAR code 981'),
        contains('981'),
        contains('Datamars'),
      ));
    });

    test('Detects ISO and decodes manufacturer code 982 (AVID hint)', () async {
      final result = await MicrochipLookupService.validateChipFormat('982000000000000');
      expect(result.isValidFormat, isTrue);
      expect(result.manufacturerHint, contains('AVID'));
    });

    test('Detects AVID 10-digit', () async {
      final result = await MicrochipLookupService.validateChipFormat('1234567890');
      expect(result.isValidFormat, isTrue);
      expect(result.chipType, 'AVID 10-digit');
      expect(result.chipStandard, 'AVID Proprietary');
    });

    test('Detects Legacy 9-digit', () async {
      final result = await MicrochipLookupService.validateChipFormat('123456789');
      expect(result.isValidFormat, isTrue);
      expect(result.chipType, 'Legacy 9-digit');
    });

    test('Detects 15-character hex as ISO-like (Hex Encoded)', () async {
      final result = await MicrochipLookupService.validateChipFormat('A1B2C3D4E5F6A7B');
      expect(result.isValidFormat, isTrue);
      expect(result.chipType, 'ISO-like (Hex Encoded)');
      expect(result.formatDescription, contains('hexadecimal'));
      // Conversion to decimal should provide a 15-digit string when feasible
      expect(result.decimalIsoId?.length, anyOf(isNull, equals(15)));
    });
  });
}
