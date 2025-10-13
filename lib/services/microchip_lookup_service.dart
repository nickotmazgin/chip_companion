import 'package:chip_companion/services/security_service.dart';
import 'package:chip_companion/data/icar_db.dart';

/// Professional microchip format validation service
/// Provides format checking and registry information for professional reference only
class MicrochipLookupService {
  /// Validates microchip format and returns professional reference information
  static Future<MicrochipLookupResult> validateChipFormat(
    String rawInput,
  ) async {
    final sanitized = SecurityService.validateAndSanitizeChipId(rawInput);
    if (sanitized == null) {
      return MicrochipLookupResult(
        chipId: rawInput,
        isValidFormat: false,
        chipType: 'Invalid',
        formatDescription: 'Input does not match supported chip format rules.',
        suggestedRegistries: const [],
        validationDate: DateTime.now(),
      );
    }

    final type = _detectType(sanitized);
    final valid = type != 'Unknown';
    final desc = _describe(type, sanitized);
  // We'll build registries after decoding manufacturer to allow adding a
  // primary manufacturer registry link first.
  List<RegistryInfo> registries = const <RegistryInfo>[];
    final standard = _getChipStandard(type);

    // Decode ISO prefix using ICAR DB for richer details
    String? manufacturer;
    String? country;
    RegistryInfo? primaryRegistry;
  if (sanitized.length == 15 && RegExp(r'^\d{15}$').hasMatch(sanitized)) {
      final prefix = sanitized.substring(0, 3);
      final prefixNum = int.tryParse(prefix);
      if (prefixNum != null && prefixNum >= 1 && prefixNum <= 899) {
        country = IcarDb.countryForPrefix(prefix);
      } else if (prefixNum != null && prefixNum >= 900 && prefixNum <= 999) {
        final info = IcarDb.manufacturerForCode(prefix);
        if (info != null) {
          manufacturer = '${info.name} (ICAR code $prefix)';
          if (info.registryWebsite != null) {
            primaryRegistry = RegistryInfo(
              name: info.registryName ?? info.name,
              region: 'Manufacturer',
              website: info.registryWebsite!,
              email: info.supportEmail,
              phone: info.supportPhone,
              contactInfo: 'Direct registry for ICAR code $prefix',
              isEducational: false,
              lookupUrl: info.registryWebsite,
            );
          }
        }
      }
    }

    // Fall back to previous hint if not found in DB
    manufacturer ??= _getManufacturerHint(sanitized);
    // Build base registry list now and add primary manufacturer registry first
    registries = valid ? _registriesFor(sanitized) : <RegistryInfo>[];
    if (primaryRegistry != null) {
      final pr = primaryRegistry; // capture non-null for closure promotion
      // Insert at top, avoid duplicates by website/name
      final exists = registries.any((r) =>
          (r.lookupUrl != null && pr.lookupUrl != null && r.lookupUrl == pr.lookupUrl) ||
          r.website == pr.website ||
          r.name == pr.name);
      if (!exists) {
        registries.insert(0, pr);
      }
    }

    final guidance = _getNextStepsGuidance(valid, registries);
  final decimalForm = _maybeConvertHexToDecimal(type, sanitized);

    return MicrochipLookupResult(
      chipId: sanitized,
      isValidFormat: valid,
      chipType: type,
      formatDescription: desc,
      suggestedRegistries: registries,
      chipStandard: standard,
      manufacturerHint: manufacturer,
      country: country,
      validationDate: DateTime.now(),
      nextStepsGuidance: guidance,
      decimalIsoId: decimalForm,
    );
  }

  static String _detectType(String id) {
    final isNumeric = RegExp(r'^\d+$').hasMatch(id);
    final isHex = RegExp(r'^[0-9A-F]+$').hasMatch(id);
    if (id.length == 15 && isNumeric) return 'ISO 11784/11785';
    if (id.length == 15 && isHex && !isNumeric) return 'ISO-like (Hex Encoded)';
    if (id.length == 10 && isNumeric) return 'AVID 10-digit';
    if (id.length == 9 && isNumeric) return 'Legacy 9-digit';
    return 'Unknown';
  }

  static String _describe(String type, String id) {
    switch (type) {
      case 'ISO 11784/11785':
        return '15-digit ISO (FDX-B) numeric microchip. Prefix may indicate country (001–899) or manufacturer (900–998/999).';
      case 'ISO-like (Hex Encoded)':
        return '15-character hexadecimal representation detected. Convert to 15-digit decimal ISO (FDX-B) format for official lookups.';
      case 'AVID 10-digit':
        return '10-digit numeric AVID-style number (non-ISO).';
      case 'Legacy 9-digit':
        return '9-digit legacy numeric format; check multiple registries for coverage.';
      default:
        return 'Format not recognized. Verify manually.';
    }
  }

  /// Convert a 15-character hex representation to 15-digit decimal ISO format.
  /// Returns null unless type is 'ISO-like (Hex Encoded)' and conversion yields
  /// a 15-digit numeric string.
  static String? _maybeConvertHexToDecimal(String type, String id) {
    if (type != 'ISO-like (Hex Encoded)') return null;
    // Convert hex string to BigInt, then to decimal string.
    try {
      final value = BigInt.parse(id, radix: 16);
      final decimal = value.toString();
      // ISO decimal should be 15 digits; if shorter, left-pad with zeros.
      if (decimal.length <= 15) {
        final padded = decimal.padLeft(15, '0');
        if (RegExp(r'^\d{15}$').hasMatch(padded)) {
          return padded;
        }
      }
    } catch (_) {
      // ignore
    }
    return null;
  }

  static List<RegistryInfo> _registriesFor(String id) {
    final list = <RegistryInfo>[];

    // AAHA Universal Lookup (real lookup)
    list.add(
      RegistryInfo(
        name: 'AAHA Universal Pet Microchip Lookup',
        region: 'Worldwide',
        website: 'https://www.petmicrochiplookup.org/',
        email: 'info@aaha.org',
        contactInfo: 'Connects to numerous registries globally',
        isEducational: false,
        lookupUrl: 'https://www.petmicrochiplookup.org/?microchip=$id',
      ),
    );

    // PetMaxx (international search network)
    list.add(
      const RegistryInfo(
        name: 'PetMaxx',
        region: 'Worldwide',
        website: 'https://www.petmaxx.com/',
        email: 'info@petmaxx.com',
        contactInfo: 'Large international microchip search network',
      ),
    );

    // Popular US registries
    if (id.length == 10) {
      list.add(
        const RegistryInfo(
          name: 'AVID® Pet Recovery',
          region: 'USA',
          website: 'https://www.avidid.com/',
          email: 'petchip@avidid.com',
          phone: '+1-800-336-2843',
          contactInfo: '24/7 PETtrac hotline • Toll-free: 1-800-336-2843 • Alt: +1-951-371-7505',
        ),
      );
    }

    // Common 15-digit ISO suggestions (international)
    if (id.length == 15) {
      list.addAll([
        const RegistryInfo(
          name: 'HomeAgain®',
          region: 'USA',
          website: 'https://www.homeagain.com/',
          email: 'customerservice@homeagain.com',
          phone: '+1-888-466-3242',
          contactInfo: '24/7 support',
        ),
        const RegistryInfo(
          name: 'AKC Reunite',
          region: 'USA',
          website: 'https://www.akcreunite.org/',
          email: 'found@akcreunite.org',
          phone: '+1-800-252-7894',
          contactInfo: 'Also: +1-919-816-3753',
        ),
        const RegistryInfo(
          name: '24PetWatch',
          region: 'Canada / USA',
          website: 'https://www.24petwatch.com/',
          contactInfo: 'Contact via website; support channel may vary by service',
        ),
        const RegistryInfo(
          name: 'EIDAP Inc.',
          region: 'Canada',
          website: 'https://www.eidap.com/',
          email: 'info@eidap.com',
          phone: '+1-888-346-8899',
          contactInfo: 'Alt: +1-905-970-8181',
        ),
        const RegistryInfo(
          name: 'Europetnet',
          region: 'Europe',
          website: 'https://www.europetnet.org/pet-id-search.html',
          email: 'info@europetnet.org',
          contactInfo:
              'Use Pet ID search page; or contact via website form or info@europetnet.org',
        ),
        const RegistryInfo(
          name: 'Petlog',
          region: 'UK',
          website: 'https://www.petlog.org.uk/',
          phone: '+44 1296 336579',
          contactInfo: 'Lost pets 24/7: +44 1296 737600',
        ),
        const RegistryInfo(
          name: 'TASSO e.V.',
          region: 'Germany',
          website: 'https://www.tasso.net/',
          email: 'info@tasso.net',
          phone: '+49 6190 937300',
        ),
        const RegistryInfo(
          name: 'FINDEFIX',
          region: 'Germany',
          website: 'https://www.findefix.com/',
          email: 'info@findefix.com',
          contactInfo: 'Registry by Deutscher Tierschutzbund',
        ),
        const RegistryInfo(
          name: 'I-CAD',
          region: 'France',
          website: 'https://www.i-cad.fr/',
          contactInfo:
              'Official French national registry • Contact via website form • Phone hours Mon–Fri 08:30–17:30 CET • Address: 29 RUE DU PROGRES, CS 50011, 93108 MONTREUIL CEDEX',
        ),
        const RegistryInfo(
          name: 'REIAC',
          region: 'Spain',
          website: 'https://www.reiac.es/',
          contactInfo:
              'Spanish Network of Companion Animal Identification • Use “Localizar chip” and contact your regional Colegio Oficial de Veterinarios',
        ),
        const RegistryInfo(
          name: 'Animal-ID.ru',
          region: 'Russia',
          website: 'https://animal-id.ru/',
          email: 'info@animal-id.ru',
          contactInfo: 'All-Russian unified database of chipped animals',
        ),
        const RegistryInfo(
          name: 'The National Dog Registry (המאגר הארצי לרישום כלבים)',
          region: 'Israel',
          website: 'https://dogsearch.moag.gov.il/#/pages/pets',
          email: 'dogcenter@moag.gov.il',
          phone: '*6016',
          contactInfo:
              'Official MoAG dog search portal • Additional contact: Moked.sherut@moag.gov.il • Alt. phone: +972-3-948-5555',
        ),
        const RegistryInfo(
          name: 'Australasian Animal Registry (AAR)',
          region: 'Australia',
          website: 'https://www.aar.org.au/',
          phone: '+61 2 9704 1450',
          contactInfo: 'Call centre operated by Royal Agricultural Society of NSW',
        ),
      ]);
    }

    return list;
  }

  /// Get chip standard information
  static String? _getChipStandard(String type) {
    switch (type) {
      case 'ISO 11784/11785':
        return 'ISO 11784/11785 (FDX-B)';
      case 'AVID 10-digit':
        return 'AVID Proprietary';
      case 'Legacy 9-digit':
        return 'Legacy Format';
      default:
        return null;
    }
  }

  /// Get manufacturer hint based on chip ID patterns
  static String? _getManufacturerHint(String id) {
    // For 15-digit ISO chips, extract manufacturer code (first 3 digits)
    if (id.length == 15) {
      return _decodeIso11784Prefix(id);
    } else if (id.length == 10) {
      return 'AVID® Proprietary Format (Unconfirmed)';
    } else if (id.length == 9) {
      return 'Legacy Format (Contact registries for manufacturer info)';
    }
    return null;
  }

  /// Decode the first three digits of an ISO 11784/11785 (FDX-B) microchip.
  /// These digits can represent either:
  /// - a manufacturer code (typically 900–998 assigned by ICAR), or
  /// - a country code (ISO 3166-1 numeric) when in the 001–899 range.
  /// Returns a concise human-readable description suitable for UI display.
  static String _decodeIso11784Prefix(String id) {
    final prefix = id.substring(0, 3);
    final code = int.tryParse(prefix);
    if (code == null) {
      return 'FDX-B Technology • Invalid prefix';
    }

    // Common ISO 3166-1 numeric country codes (not exhaustive)
    const isoCountries = <String, String>{
      '004': 'Afghanistan',
      '008': 'Albania',
      '012': 'Algeria',
      '036': 'Australia',
      '040': 'Austria',
      '056': 'Belgium',
      '076': 'Brazil',
      '100': 'Bulgaria',
      '124': 'Canada',
      '152': 'Chile',
      '156': 'China',
      '191': 'Croatia',
      '203': 'Czechia',
      '208': 'Denmark',
      '233': 'Estonia',
      '246': 'Finland',
      '250': 'France',
      '276': 'Germany',
      '300': 'Greece',
      '344': 'Hong Kong',
      '348': 'Hungary',
      '352': 'Iceland',
      '356': 'India',
      '360': 'Indonesia',
      '372': 'Ireland',
      '376': 'Israel',
      '380': 'Italy',
      '392': 'Japan',
      '410': 'South Korea',
      '458': 'Malaysia',
      '528': 'Netherlands',
      '554': 'New Zealand',
      '578': 'Norway',
      '616': 'Poland',
      '620': 'Portugal',
      '643': 'Russia',
      '702': 'Singapore',
      '704': 'Vietnam',
      '724': 'Spain',
      '752': 'Sweden',
      '756': 'Switzerland',
      '764': 'Thailand',
      '792': 'Turkey',
      '826': 'United Kingdom',
      '840': 'United States',
    };

    // Common ICAR manufacturer code hints (publicly-circulating, but not authoritative)
    // Labels include "(Unconfirmed)" to avoid implying official endorsement.
    const manufacturers = <String, String>{
      '900': 'ICAR Manufacturer-coded (Various) (Unconfirmed)',
      '956': 'Trovan (Unconfirmed)',
      '972': 'Allflex (Unconfirmed)',
      '981': 'Destron Fearing / Datamars (Unconfirmed)',
      '982': 'AVID® (Unconfirmed)',
      '985': 'Trovan (Unconfirmed)',
      '991': 'Pethealth (Unconfirmed)',
      '999': 'Microchip ID Systems (Unconfirmed)',
    };

    // Country-coded
    if (code >= 1 && code <= 899) {
      final country = isoCountries[prefix];
      if (country != null) {
        return 'FDX-B Technology • Country code $prefix — $country';
      }
      return 'FDX-B Technology • Country code $prefix (ISO 3166-1 numeric)';
    }

    // Manufacturer-coded (ICAR)
    if (code >= 900 && code <= 998) {
      final m = manufacturers[prefix];
      if (m != null) {
        return 'FDX-B Technology • Manufacturer code $prefix — $m';
      }
      return 'FDX-B Technology • Manufacturer code $prefix (ICAR-assigned)';
    }

    // 999 is special; treat via manufacturers map if present
    if (code == 999) {
      final m = manufacturers[prefix] ?? 'Manufacturer code 999 (ICAR-assigned)';
      return 'FDX-B Technology • $m';
    }

    // Fallback for any unexpected code
    return 'FDX-B Technology • Prefix $prefix';
  }

  /// Get next steps guidance based on validation results
  static String? _getNextStepsGuidance(
    bool isValid,
    List<RegistryInfo> registries,
  ) {
    if (!isValid) {
      return 'Please verify the chip ID format and try again. Contact your veterinarian if the issue persists.';
    }

    if (registries.isEmpty) {
      return 'Contact your local veterinarian or animal shelter for assistance with this chip ID.';
    }

    final hasRealLookup = registries.any((r) => !r.isEducational);
    if (hasRealLookup) {
      return 'Use the AAHA Universal Lookup for immediate pet identification. Contact other registries for additional verification.';
    } else {
      return 'Contact the suggested registries to verify pet ownership. If unregistered, contact your local veterinarian immediately.';
    }
  }
}

/// Result class for microchip format validation
class MicrochipLookupResult {
  final String chipId;
  final bool isValidFormat;
  final String chipType;
  final String formatDescription;
  final List<RegistryInfo> suggestedRegistries;
  final bool requiresVerification;
  final String? chipStandard;
  final String? manufacturerHint;
  final String? country;
  final DateTime validationDate;
  final String? nextStepsGuidance;
  /// If the input looked like a hex-encoded ISO, this contains the 15-digit decimal ISO form.
  final String? decimalIsoId;

  MicrochipLookupResult({
    required this.chipId,
    required this.isValidFormat,
    required this.chipType,
    required this.formatDescription,
    required this.suggestedRegistries,
    this.requiresVerification = true,
    this.chipStandard,
    this.manufacturerHint,
    this.country,
    required this.validationDate,
    this.nextStepsGuidance,
    this.decimalIsoId,
  });
}

/// Registry information class for professional reference
class RegistryInfo {
  final String name;
  final String region;
  final String website;
  final String? email;
  final String? phone;
  final String? contactInfo;
  final bool isEducational; // Legacy field: true = reference info, false = real lookup
  final String? lookupUrl; // Direct URL for real lookups

  const RegistryInfo({
    required this.name,
    required this.region,
    required this.website,
    this.email,
    this.phone,
    this.contactInfo,
    this.isEducational = true,
    this.lookupUrl,
  });
}
