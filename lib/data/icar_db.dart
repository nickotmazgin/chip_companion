/// ICAR codes database (non-authoritative, for reference only)
///
/// Notes
/// - Manufacturer codes are typically 900–998/999 and are assigned by ICAR.
/// - Country codes are ISO 3166-1 numeric in the range 001–899.
/// - This dataset is provided as professional reference and should be reviewed
///   against the official ICAR registry periodically.
/// - Trademarks belong to their respective owners.
class IcarDb {
  IcarDb._();

  /// Last update date for this embedded dataset
  static const String lastUpdated = '2025-10-09';

  /// Country codes (ISO 3166-1 numeric -> Country name)
  /// Not exhaustive. Extend as needed during periodic reviews.
  static const Map<String, String> countryCodes = {
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

  /// Manufacturer registry metadata
  static const Map<String, ManufacturerInfo> manufacturerCodes = {
    // Note: Names and associations are for reference and may change.
    '956': ManufacturerInfo(
      code: '956',
      name: 'Trovan',
      website: 'https://www.trovan.com/',
    ),
    '972': ManufacturerInfo(
      code: '972',
      name: 'Allflex',
      website: 'https://www.allflex.global/',
    ),
    '981': ManufacturerInfo(
      code: '981',
      name: 'Destron Fearing / Datamars',
      website: 'https://www.datamars.com/',
      registryName: 'PetLink',
      registryWebsite: 'https://www.petlink.net/',
      // Direct public search pages can change; use root site when unsure.
      supportEmail: 'info@petlink.net',
    ),
    '982': ManufacturerInfo(
      code: '982',
      name: 'AVID®',
      website: 'https://www.avidid.com/',
      registryName: 'AVID PETtrac',
      registryWebsite: 'https://www.avidid.com/',
      supportPhone: '+1-800-336-2843',
      supportEmail: 'petchip@avidid.com',
    ),
    '985': ManufacturerInfo(
      code: '985',
      name: 'Trovan',
      website: 'https://www.trovan.com/',
    ),
    '991': ManufacturerInfo(
      code: '991',
      name: 'Pethealth',
      website: 'https://www.pethealth.com/',
    ),
    '999': ManufacturerInfo(
      code: '999',
      name: 'Microchip ID Systems',
      website: 'https://microchipidsystems.com/',
    ),
  };

  /// Returns country name for a 3-digit prefix in 001–899, or null if unknown.
  static String? countryForPrefix(String prefix) => countryCodes[prefix];

  /// Returns manufacturer info for a 3-digit manufacturer code, or null if unknown.
  static ManufacturerInfo? manufacturerForCode(String code) => manufacturerCodes[code];
}

class ManufacturerInfo {
  final String code;
  final String name;
  final String? website;
  final String? registryName;
  final String? registryWebsite;
  final String? supportEmail;
  final String? supportPhone;

  const ManufacturerInfo({
    required this.code,
    required this.name,
    this.website,
    this.registryName,
    this.registryWebsite,
    this.supportEmail,
    this.supportPhone,
  });
}
