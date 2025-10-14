import 'package:flutter_test/flutter_test.dart';
import 'package:chip_companion/services/security_service.dart';

void main() {
  group('SecurityService basic validation', () {
    test('Rejects overly long input via constant max length', () {
      final tooLong = '1' * (SecurityService.maxChipIdLength + 1);
      expect(SecurityService.validateAndSanitizeChipId(tooLong), isNull);
    });

    test('Accepts numeric within bounds', () {
      final ok = '123456789012345';
      expect(SecurityService.validateAndSanitizeChipId(ok), equals(ok));
    });

    test('Sanitizes and uppercases hex, strips spaces/dashes', () {
      final raw = ' a1-b2 c3 d4 e5 f6 a7 b ';
      final sanitized = SecurityService.validateAndSanitizeChipId(raw);
      expect(sanitized, equals('A1B2C3D4E5F6A7B'));
    });
  });
}
