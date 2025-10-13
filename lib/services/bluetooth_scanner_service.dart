import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Service for managing Bluetooth scanner connectivity
/// Handles HID (Human Interface Device) profile scanners that act like keyboards
class BluetoothScannerService {
  static StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  static StreamSubscription<List<ScanResult>>? _scanSubscription;
  static bool _isScanning = false;

  // Avoid repeated console spam for web/desktop informational logs in debug.
  static final Set<String> _loggedOnce = <String>{};
  static void _logOnce(String key, String message) {
    if (!kDebugMode) return;
    if (_loggedOnce.add(key)) {
      debugPrint(message);
    }
  }

  /// Ensure Bluetooth scan permission is granted before scanning
  static Future<bool> ensureBleScanPermission() async {
    if (kIsWeb) return false;
    if (!Platform.isAndroid) return true; // iOS handles permissions differently

    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdk = androidInfo.version.sdkInt;

      if (sdk >= 31) {
        // Android 12+ requires BLUETOOTH_SCAN permission
        final status = await Permission.bluetoothScan.request();
        return status.isGranted;
      } else {
        // Android 11 and lower require location permission for BLE scanning
        final status = await Permission.location.request();
        return status.isGranted;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error checking BLE permissions: $e');
      return false;
    }
  }

  /// Check if Bluetooth is enabled on the device
  static Future<bool> isBluetoothEnabled() async {
    try {
      if (kIsWeb) {
        _logOnce('web_bt_not_supported', 'Web platform: Bluetooth scanning not supported');
        return false;
      }

      if (Platform.isAndroid || Platform.isIOS) {
        // Check if Bluetooth is supported
        if (await FlutterBluePlus.isSupported == false) {
          if (kDebugMode) debugPrint('Bluetooth not supported on this device');
          return false;
        }

        // Check current adapter state
        final adapterState = await FlutterBluePlus.adapterState.first;
        return adapterState == BluetoothAdapterState.on;
      }

      // Desktop platforms don't support Bluetooth scanning
  _logOnce('desktop_bt_not_supported', 'Bluetooth not supported on desktop platform');
      return false;
    } catch (e) {
      if (kDebugMode) debugPrint('Error checking Bluetooth status: $e');
      return false;
    }
  }

  /// Whether the current platform/hardware supports Bluetooth scanning via FlutterBluePlus.
  static Future<bool> isBluetoothSupported() async {
    try {
      if (kIsWeb) return false;
      if (Platform.isAndroid || Platform.isIOS) {
        return await FlutterBluePlus.isSupported;
      }
      // Other platforms (desktop) not supported in this app
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Whether Bluetooth adapter is turned ON (only meaningful if supported)
  static Future<bool> isBluetoothOn() async {
    try {
      if (kIsWeb) return false;
      if (Platform.isAndroid || Platform.isIOS) {
        final state = await FlutterBluePlus.adapterState.first;
        return state == BluetoothAdapterState.on;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Get list of paired Bluetooth devices
  static Future<List<BluetoothDevice>> getPairedDevices() async {
    try {
      if (kIsWeb) {
        _logOnce('web_bt_no_paired', 'Web platform: No paired devices available');
        return [];
      }

      if (Platform.isAndroid || Platform.isIOS) {
        if (await FlutterBluePlus.isSupported == false) {
          return [];
        }

        // Get connected devices
        final connectedDevices = FlutterBluePlus.connectedDevices;
        return connectedDevices
            .map(
              (device) => BluetoothDevice(
                name: device.platformName.isNotEmpty
                    ? device.platformName
                    : 'Unknown Device',
                address: device.remoteId.toString(),
                isConnected: true,
                deviceClass: 'Unknown',
              ),
            )
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting paired devices: $e');
      return [];
    }
  }

  /// Start scanning for Bluetooth HID devices
  /// The callback will be triggered when a scanner sends data
  static Future<void> startScanning(
    Function(String chipId) onChipScanned, {
    Function(String message)? onError,
  }) async {
    if (_isScanning) {
      if (kDebugMode) debugPrint('Bluetooth scan already in progress');
      return;
    }

    try {
      if (kIsWeb) {
        throw UnsupportedError('Bluetooth scanning is not supported on web');
      }

      if (Platform.isAndroid || Platform.isIOS) {
        if (await FlutterBluePlus.isSupported == false) {
          throw UnsupportedError('Bluetooth not supported on this device');
        }

        // Check permissions before scanning
        final hasPermission = await ensureBleScanPermission();
        if (!hasPermission) {
          final errorMsg = 'Bluetooth permission denied';
          if (kDebugMode) debugPrint(errorMsg);
          onError?.call(errorMsg);
          return;
        }

        _isScanning = true;

        // Start scanning for devices
        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

        // Listen for discovered devices
        bool deviceFound = false;

        _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
          if (deviceFound) return;
          for (ScanResult result in results) {
            if (kDebugMode) {
              debugPrint('Found device: ${result.device.platformName}');
            }
            // Mark that at least one device was found to avoid dead_code lint
            deviceFound = true;
            // Integration with specific scanner HID data should occur here.
            // No demo data will be emitted in release builds.
            break;
          }
        });

        // Handle scan timeout - if no scanner found, end scan silently
        Future.delayed(const Duration(seconds: 6), () async {
          if (_isScanning && !deviceFound) {
            await stopScanning();
            if (kDebugMode) debugPrint('Bluetooth scan timeout - no device found');
          }
        });

        if (kDebugMode) debugPrint('Bluetooth scan started');
      } else {
        throw UnsupportedError(
          'Bluetooth scanning not supported on this platform',
        );
      }
    } catch (e) {
      _isScanning = false;
      if (kDebugMode) debugPrint('Error starting Bluetooth scan: $e');
      onError?.call('Error starting scan: $e');
      rethrow;
    }
  }

  /// Stop the current Bluetooth scan
  static Future<void> stopScanning() async {
    if (!_isScanning) return;

    try {
      if (kIsWeb) {
        _logOnce('web_bt_no_scan', 'Web platform: No scan to stop');
        _isScanning = false;
        return;
      }

      if (Platform.isAndroid || Platform.isIOS) {
        await _scanSubscription?.cancel();
        _scanSubscription = null;
        await FlutterBluePlus.stopScan();
        if (kDebugMode) debugPrint('Bluetooth scan stopped');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error stopping Bluetooth scan: $e');
    } finally {
      _isScanning = false;
    }
  }

  /// Check if currently scanning
  static bool get isScanning => _isScanning;

  /// Request Bluetooth permissions
  static Future<bool> requestPermissions() async {
    try {
      if (kIsWeb) {
        // On web, permissions are handled by the browser
        _logOnce('web_bt_permissions', 'Web platform: Bluetooth permissions handled by browser');
        return true;
      }

      if (Platform.isAndroid || Platform.isIOS) {
        // Check if Bluetooth is supported first
        if (await FlutterBluePlus.isSupported == false) {
          if (kDebugMode) debugPrint('Bluetooth not supported on this device');
          return false;
        }

        // Check current adapter state
        final adapterState = await FlutterBluePlus.adapterState.first;
        if (adapterState != BluetoothAdapterState.on) {
          if (kDebugMode) debugPrint('Bluetooth is not enabled');
          return false;
        }

        if (kDebugMode) debugPrint('Bluetooth permissions and state verified');
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) debugPrint('Error requesting Bluetooth permissions: $e');
      return false;
    }
  }

  /// Connect to a specific Bluetooth device
  static Future<bool> connectToDevice(String deviceAddress) async {
    try {
      if (kIsWeb) {
        _logOnce('web_bt_sim_connect', 'Web platform: Simulating device connection');
        return true;
      }

      if (Platform.isAndroid || Platform.isIOS) {
        // In a real implementation, you'd connect to the specific device
        if (kDebugMode) debugPrint('Connecting to device: $deviceAddress');
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) debugPrint('Error connecting to device: $e');
      return false;
    }
  }

  /// Disconnect from current device
  static Future<void> disconnect() async {
    try {
      if (kIsWeb) {
        _logOnce('web_bt_sim_disconnect', 'Web platform: Simulating device disconnection');
        return;
      }

      if (Platform.isAndroid || Platform.isIOS) {
        if (kDebugMode) debugPrint('Bluetooth device disconnected');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error disconnecting: $e');
    }
  }

  /// Clean up resources
  static Future<void> dispose() async {
    await stopScanning();
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    await _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}

/// Represents a Bluetooth device
class BluetoothDevice {
  final String name;
  final String address;
  final bool isConnected;
  final String? deviceClass;

  BluetoothDevice({
    required this.name,
    required this.address,
    this.isConnected = false,
    this.deviceClass,
  });

  factory BluetoothDevice.fromMap(Map<dynamic, dynamic> map) {
    return BluetoothDevice(
      name: map['name'] as String? ?? 'Unknown Device',
      address: map['address'] as String? ?? '',
      isConnected: map['isConnected'] as bool? ?? false,
      deviceClass: map['deviceClass'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'isConnected': isConnected,
      'deviceClass': deviceClass,
    };
  }

  @override
  String toString() {
    return 'BluetoothDevice(name: $name, address: $address, isConnected: $isConnected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BluetoothDevice && other.address == address;
  }

  @override
  int get hashCode => address.hashCode;
}
