import 'package:flutter_test/flutter_test.dart';
import 'package:chip_companion/services/microchip_lookup_service.dart';

void main() {
  group('MicrochipLookupService', () {
    test('Valid 15-digit ISO format passes', () async {
      final res = await MicrochipLookupService.validateChipFormat('840123456789012');
      expect(res.isValidFormat, true);
      expect(res.chipType.contains('ISO'), true);
    });

    test('Invalid short ID rejected', () async {
      final res = await MicrochipLookupService.validateChipFormat('123');
      expect(res.isValidFormat, false);
    });

    test('Rejects illegal characters', () async {
      final res = await MicrochipLookupService.validateChipFormat('84012<script>');
      expect(res.isValidFormat, false);
    });
  });
}