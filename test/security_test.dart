import 'package:flutter_test/flutter_test.dart';
import 'package:chip_companion/services/security_service.dart';

void main() {
  group('Security Service Tests', () {
    test('should validate microchip ID correctly', () {
      // Valid microchip IDs
      expect(SecurityService.validateAndSanitizeChipId('123456789'), '123456789');
      expect(SecurityService.validateAndSanitizeChipId('ABC123DEF456'), 'ABC123DEF456');
      expect(SecurityService.validateAndSanitizeChipId('123-456-789'), '123456789');
      expect(SecurityService.validateAndSanitizeChipId('123 456 789'), '123456789');
      
      // Invalid microchip IDs
      expect(SecurityService.validateAndSanitizeChipId(''), null);
      expect(SecurityService.validateAndSanitizeChipId('123'), null); // Too short
  // 20 chars is allowed by current constraints (max 20)
  expect(SecurityService.validateAndSanitizeChipId('12345678901234567890'), '12345678901234567890');
      expect(SecurityService.validateAndSanitizeChipId('123456789012345678901234567890123456789012345678901234567890'), null); // Way too long
    });

    test('should validate language codes correctly', () {
      expect(SecurityService.isValidLanguageCode('en'), true);
      expect(SecurityService.isValidLanguageCode('he'), true);
      expect(SecurityService.isValidLanguageCode('ru'), true);
      expect(SecurityService.isValidLanguageCode('es'), true);
      expect(SecurityService.isValidLanguageCode('fr'), true);
      
      expect(SecurityService.isValidLanguageCode('invalid'), false);
      expect(SecurityService.isValidLanguageCode(''), false);
      expect(SecurityService.isValidLanguageCode('EN'), false); // Case sensitive
    });

    test('should sanitize strings to prevent XSS', () {
      expect(SecurityService.sanitizeString('<script>alert("xss")</script>'), 
             '&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;');
      expect(SecurityService.sanitizeString('Hello <b>World</b>'), 
             'Hello &lt;b&gt;World&lt;/b&gt;');
      expect(SecurityService.sanitizeString('Normal text'), 'Normal text');
    });

    test('should detect malicious patterns', () {
      expect(SecurityService.containsMaliciousPattern('<script>alert("xss")</script>'), true);
      expect(SecurityService.containsMaliciousPattern('javascript:alert("xss")'), true);
      expect(SecurityService.containsMaliciousPattern('data:text/html,<script>'), true);
      expect(SecurityService.containsMaliciousPattern('onload=alert("xss")'), true);
      expect(SecurityService.containsMaliciousPattern('onerror=alert("xss")'), true);
      
      expect(SecurityService.containsMaliciousPattern('Normal text'), false);
      expect(SecurityService.containsMaliciousPattern('123456789'), false);
    });

    test('should validate HTTPS URLs', () {
      expect(SecurityService.isValidHttpsUrl('https://example.com'), true);
      expect(SecurityService.isValidHttpsUrl('https://www.petmicrochiplookup.org'), true);
      
      expect(SecurityService.isValidHttpsUrl('http://example.com'), false);
      expect(SecurityService.isValidHttpsUrl('ftp://example.com'), false);
      expect(SecurityService.isValidHttpsUrl('invalid-url'), false);
      expect(SecurityService.isValidHttpsUrl(''), false);
    });

    test('should generate secure IDs', () async {
      final id1 = SecurityService.generateSecureId();
      await Future.delayed(const Duration(milliseconds: 1)); // Ensure different timestamps
      final id2 = SecurityService.generateSecureId();
      
      expect(id1, isNotEmpty);
      expect(id2, isNotEmpty);
      expect(id1, isNot(equals(id2))); // Should be different
      expect(id1.length, greaterThan(10)); // Should be reasonably long
    });
  });
}
