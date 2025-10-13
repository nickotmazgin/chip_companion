import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight local store for managing remembered Bluetooth devices and aliases.
class DeviceStore {
  static const _rememberedKey = 'remembered_bt_devices';

  /// Returns a set of remembered device addresses
  static Future<Set<String>> getRememberedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_rememberedKey)?.toSet() ?? <String>{};
  }

  /// Remember a device by address
  static Future<void> rememberDevice(String address) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_rememberedKey)?.toSet() ?? <String>{};
    current.add(address);
    await prefs.setStringList(_rememberedKey, current.toList());
  }

  /// Forget a remembered device by address
  static Future<void> forgetDevice(String address) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_rememberedKey)?.toSet() ?? <String>{};
    current.remove(address);
    await prefs.setStringList(_rememberedKey, current.toList());
    await prefs.remove(_aliasKey(address));
  }

  /// Returns whether a device is remembered
  static Future<bool> isRemembered(String address) async {
    final set = await getRememberedDevices();
    return set.contains(address);
  }

  /// Get or set a friendly alias for a device (stored locally)
  static Future<String?> getAlias(String address) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_aliasKey(address));
  }

  static Future<void> setAlias(String address, String alias) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_aliasKey(address), alias);
  }

  static String _aliasKey(String address) => 'device_alias_$address';
}
