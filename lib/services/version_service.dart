import 'package:package_info_plus/package_info_plus.dart';

/// Service to get app version information dynamically
class VersionService {
  static PackageInfo? _packageInfo;

  /// Get the formatted version string (e.g., "Version 2.0.7 (10)")
  static Future<String> getVersionString(String versionLabel) async {
    _packageInfo ??= await PackageInfo.fromPlatform();
    return '$versionLabel ${_packageInfo!.version} (${_packageInfo!.buildNumber})';
  }

  /// Get just the version number (e.g., "2.0.7")
  static Future<String> getVersionNumber() async {
    _packageInfo ??= await PackageInfo.fromPlatform();
    return _packageInfo!.version;
  }

  /// Get just the build number (e.g., "10")
  static Future<String> getBuildNumber() async {
    _packageInfo ??= await PackageInfo.fromPlatform();
    return _packageInfo!.buildNumber;
  }
}

