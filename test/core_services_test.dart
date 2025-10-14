import 'package:flutter_test/flutter_test.dart';
import 'package:chip_companion/services/microchip_lookup_service.dart';
import 'package:chip_companion/services/security_service.dart';

void main() {
  group('Core Service Tests', () {
    test('SecurityService validates input correctly', () {
      expect(SecurityService.validateAndSanitizeChipId('840123456789012'), isNotNull);
      expect(SecurityService.validateAndSanitizeChipId(''), isNull);
      expect(SecurityService.validateAndSanitizeChipId('<script>'), isNull);
    });

    test('MicrochipLookupService handles valid input', () async {
      final result = await MicrochipLookupService.validateChipFormat('840123456789012');
      expect(result.isValidFormat, isTrue);
      expect(result.chipType, contains('ISO'));
    });

    test('MicrochipLookupService handles invalid input', () async {
      final result = await MicrochipLookupService.validateChipFormat('123');
      expect(result.isValidFormat, isFalse);
    });

    test('SecurityService sanitizes strings correctly', () {
      expect(SecurityService.sanitizeString('<script>alert("xss")</script>'), 
             '&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;');
      expect(SecurityService.sanitizeString('Normal text'), 'Normal text');
    });

    test('SecurityService detects malicious patterns', () {
      expect(SecurityService.containsMaliciousPattern('<script>alert("xss")</script>'), isTrue);
      expect(SecurityService.containsMaliciousPattern('Normal text'), isFalse);
    });

    test('SecurityService validates HTTPS URLs', () {
      expect(SecurityService.isValidHttpsUrl('https://example.com'), isTrue);
      expect(SecurityService.isValidHttpsUrl('http://example.com'), isFalse);
      expect(SecurityService.isValidHttpsUrl('invalid-url'), isFalse);
    });
  });
}
