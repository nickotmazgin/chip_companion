import 'package:flutter/material.dart';
import 'package:chip_companion/services/bluetooth_scanner_service.dart';
import 'package:chip_companion/services/nfc_scanner_service.dart';
import 'package:chip_companion/widgets/tree_background.dart';
import 'package:chip_companion/widgets/tree_ui_components.dart';
import 'package:chip_companion/l10n/app_localizations.dart';

class ScannerManagementScreen extends StatefulWidget {
  const ScannerManagementScreen({super.key});

  @override
  State<ScannerManagementScreen> createState() =>
      _ScannerManagementScreenState();
}

class _ScannerManagementScreenState extends State<ScannerManagementScreen> {
  List<BluetoothDevice> _availableDevices = [];
  bool _isScanning = false;
  bool _isBluetoothEnabled = false;
  bool _isNFCEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final bluetoothStatus = await BluetoothScannerService.isBluetoothEnabled();
    final nfcStatus = await NFCScannerService.isNFCEnabled();
    final pairedDevices = await BluetoothScannerService.getPairedDevices();

    if (mounted) {
      setState(() {
        _isBluetoothEnabled = bluetoothStatus;
        _isNFCEnabled = nfcStatus;
        _availableDevices = pairedDevices;
      });
    }
  }

  Future<void> _startBluetoothScan() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_isBluetoothEnabled) {
      _showErrorSnackBar(l10n.bluetoothNotEnabledMessage);
      return;
    }

    setState(() {
      _isScanning = true;
    });

    try {
      await BluetoothScannerService.startScanning((chipId) {
        if (mounted) {
          setState(() {
            _isScanning = false;
          });
          _showScannedIdDialog(chipId);
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        _showErrorSnackBar('${l10n.bluetoothScanFailed}: $e');
      }
    }
  }

  Future<void> _startNFCScan() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_isNFCEnabled) {
      _showErrorSnackBar(l10n.nfcNotAvailable);
      return;
    }

    setState(() {
      _isScanning = true;
    });

    try {
      final (chipId, status) = await NFCScannerService.scanForChip();
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        if (chipId.isNotEmpty) {
          _showScannedIdDialog(chipId);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        _showErrorSnackBar('${l10n.nfcScanFailed}: $e');
      }
    }
  }

  void _showScannedIdDialog(String chipId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chipIdScannedTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${l10n.scannedIdLabel}: $chipId'),
            const SizedBox(height: 16),
            Text(l10n.validateThisChipQuestion),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
              ).pop(chipId); // Pass chipId back to home screen
            },
            child: Text(l10n.validate),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: TreeBackgroundAppBar(title: Text(l10n.scannerManagement)),
      body: TreeBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bluetooth Section
              TreeBackgroundCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bluetooth,
                            color: _isBluetoothEnabled
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.bluetoothScanners,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (!_isBluetoothEnabled)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.orange[700]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.bluetoothNotEnabledMessage,
                                  style: TextStyle(color: Colors.orange[700]),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: _isScanning ? null : _startBluetoothScan,
                          icon: _isScanning
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.search),
                          label: Text(
                            _isScanning
                                ? l10n.scanning
                                : l10n.startBluetoothScan,
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // NFC Section
              TreeBackgroundCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.nfc,
                            color: _isNFCEnabled ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.nfcScanning,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (!_isNFCEnabled)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.orange[700]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.nfcNotAvailable,
                                  style: TextStyle(color: Colors.orange[700]),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ElevatedButton.icon(
                          onPressed: _isScanning ? null : _startNFCScan,
                          icon: _isScanning
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.touch_app),
                          label: Text(
                            _isScanning ? l10n.scanning : l10n.scanWithNFC,
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Paired Devices Section
              TreeBackgroundCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.devices_other,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.pairedDevices,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_availableDevices.isEmpty)
                        Text(
                          l10n.noPairedDevicesMessage,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        )
                      else
                        ..._availableDevices.map(
                          (device) => ListTile(
                            leading: const Icon(Icons.bluetooth_connected),
                            title: Text(device.name),
                            subtitle: Text(device.address),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Scanner Disclaimers
              TreeBackgroundCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.scannerDisclaimers,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.scannerCompatibilityDisclaimer}\n\n${l10n.scannerDataDisclaimer}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
