import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:chip_companion/data/icar_db.dart';

/// Service for performing REAL microchip lookups
/// This service opens actual websites and performs real lookups
class RealLookupService {
  /// Perform a REAL lookup using AAHA Universal Lookup
  /// This opens the actual website with the microchip ID
  static Future<bool> performRealLookup(String chipId) async {
    try {
      // AAHA Universal Lookup - This is REAL and functional
      final url = 'https://www.petmicrochiplookup.org/?microchip=$chipId';

      if (kDebugMode) debugPrint('🔍 Opening REAL lookup: $url');

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (kDebugMode) debugPrint('✅ Real lookup opened successfully');
        return true;
      } else {
        if (kDebugMode) debugPrint('❌ Cannot open real lookup URL');
        return false;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error opening real lookup: $e');
      return false;
    }
  }

  /// Open HomeAgain website for real lookup
  static Future<bool> openHomeAgainLookup(String chipId) async {
    try {
      const url =
          'https://www.homeagain.com/pet-recovery-services/pet-microchip-lookup/';
      if (kDebugMode) debugPrint('🔍 Opening HomeAgain lookup: $url');

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error opening HomeAgain: $e');
      return false;
    }
  }

  /// Open AVID website for real lookup
  static Future<bool> openAVIDLookup(String chipId) async {
    try {
      const url =
          'https://www.avidid.com/pet-recovery-services/pet-microchip-lookup/';
      if (kDebugMode) debugPrint('🔍 Opening AVID lookup: $url');

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error opening AVID: $e');
      return false;
    }
  }

  /// Open Petlog website for real lookup
  static Future<bool> openPetlogLookup(String chipId) async {
    try {
      const url = 'https://www.petlog.org.uk/lost-found-pets/microchip-lookup/';
      if (kDebugMode) debugPrint('🔍 Opening Petlog lookup: $url');

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error opening Petlog: $e');
      return false;
    }
  }

  /// Get the best real lookup option for a chip ID
  static Future<bool> performBestRealLookup(String chipId) async {
    // If this looks like a 15-digit ISO, try manufacturer registry first
    final isIsoNumeric = RegExp(r'^\d{15}$').hasMatch(chipId);
    if (isIsoNumeric) {
      final prefix = chipId.substring(0, 3);
      final prefixNum = int.tryParse(prefix);
      if (prefixNum != null && prefixNum >= 900 && prefixNum <= 999) {
        final m = IcarDb.manufacturerForCode(prefix);
        if (m?.registryWebsite != null) {
          final uri = Uri.parse(m!.registryWebsite!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            return true;
          }
        }
      }
    }

    // Try AAHA Universal Lookup (most comprehensive aggregator)
    if (await performRealLookup(chipId)) return true;

    // Fallback to specific registries based on chip format
    if (chipId.startsWith('840')) {
      return await openHomeAgainLookup(chipId);
    } else if (chipId.length == 10) {
      return await openAVIDLookup(chipId);
    } else if (chipId.length == 15) {
      return await openPetlogLookup(chipId);
    }

    return false;
  }

  /// Check if real lookups are available
  static bool get isRealLookupAvailable =>
      true; // Always available for web lookups

  /// Get real lookup status message
  static String get realLookupStatus =>
      '✅ Real lookups available - Opens official registry websites';
}
