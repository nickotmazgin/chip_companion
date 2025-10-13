import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chip_companion/l10n/app_localizations.dart';
import 'package:chip_companion/services/bluetooth_scanner_service.dart';
import 'package:chip_companion/services/nfc_scanner_service.dart';
import 'package:chip_companion/services/purchase_service.dart';
import 'package:chip_companion/services/settings_service.dart';
import 'package:chip_companion/services/device_store.dart';
import 'package:chip_companion/widgets/tree_background.dart';
import 'package:chip_companion/widgets/tree_ui_components.dart';
import 'package:chip_companion/widgets/pro_unlock_dialog.dart';

class DevicesScreen extends StatefulWidget {
  final PurchaseService purchaseService;
  final Function(String)? onChipIdScanned;
  final SettingsService settingsService;

  const DevicesScreen({
    super.key,
    required this.purchaseService,
    required this.settingsService,
    this.onChipIdScanned,
  });

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  bool _isBluetoothEnabled = false;
  bool _isNFCEnabled = false;
  bool _isScanning = false;
  List<BluetoothDevice> _pairedDevices = [];
  Timer? _statusCheckTimer;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    // Listen to purchase service changes
    widget.purchaseService.addListener(_onPurchaseStatusChanged);
    // Start periodic status checking (every 3 seconds)
    _statusCheckTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkDeviceStatus(),
    );
  }

  @override
  void dispose() {
    widget.purchaseService.removeListener(_onPurchaseStatusChanged);
    _statusCheckTimer?.cancel();
    super.dispose();
  }

  void _onPurchaseStatusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _checkDeviceStatus() async {
    if (!mounted) return;
    
    final bluetoothEnabled = await BluetoothScannerService.isBluetoothEnabled();
    final nfcEnabled = await NFCScannerService.isNFCAvailable();
    
    if (mounted && 
        (bluetoothEnabled != _isBluetoothEnabled || nfcEnabled != _isNFCEnabled)) {
      setState(() {
        _isBluetoothEnabled = bluetoothEnabled;
        _isNFCEnabled = nfcEnabled;
      });
    }
  }

  Future<void> _initializeServices() async {
    final bluetoothEnabled = await BluetoothScannerService.isBluetoothEnabled();
    final nfcEnabled = await NFCScannerService.isNFCAvailable();

    if (mounted) {
      setState(() {
        _isBluetoothEnabled = bluetoothEnabled;
        _isNFCEnabled = nfcEnabled;
      });
    }

    await _loadPairedDevices();
  }

  Future<void> _loadPairedDevices() async {
    final devices = await BluetoothScannerService.getPairedDevices();
    if (mounted) {
      setState(() {
        _pairedDevices = devices;
      });
    }
  }

  Future<void> _startBluetoothScan() async {
    setState(() {
      _isScanning = true;
    });

    try {
      await BluetoothScannerService.startScanning((chipId) {
        if (mounted) {
          setState(() {
            _isScanning = false;
          });
          // If auto-validate on scan is enabled, skip confirmation
          if (widget.settingsService.autoValidateOnScan) {
            _navigateToValidation(chipId);
          } else {
            _showScannedIdDialog(chipId);
          }
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        final l10n = AppLocalizations.of(context)!;
        _showErrorSnackBar('${l10n.bluetoothScanFailed}: $e');
      }
    }
  }

  Future<void> _startNFCScan() async {
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
          if (widget.settingsService.autoValidateOnScan) {
            _navigateToValidation(chipId);
          } else {
            _showScannedIdDialog(chipId);
          }
        } else {
          // NFC scan failed or was canceled
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('NFC scan failed or was canceled')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        final l10n = AppLocalizations.of(context)!;
        _showErrorSnackBar('${l10n.nfcScanFailed}: $e');
      }
    }
  }

  void _showScannedIdDialog(String chipId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chipIdScanned),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${l10n.scannedId}: $chipId'),
            const SizedBox(height: 16),
            Text(l10n.validateThisChip),
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
              _navigateToValidation(chipId);
            },
            child: Text(l10n.validate),
          ),
        ],
      ),
    );
  }

  void _navigateToValidation(String chipId) {
    // Call the callback to pass chip ID back to main navigation
    widget.onChipIdScanned?.call(chipId);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: TreeBackgroundAppBar(
        title: Text(l10n.devicesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeServices,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: TreeBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  _buildBluetoothSection(),
                  const SizedBox(height: 24),
                  _buildNFCSection(),
                  const SizedBox(height: 24),
                  _buildPairedDevicesSection(),
                  const SizedBox(height: 24),
                  _buildDisclaimersCard(),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final l10n = AppLocalizations.of(context)!;
    return TreeBackgroundCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.devices,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.deviceStatus,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<bool>(
              future: BluetoothScannerService.isBluetoothSupported(),
              builder: (context, btSnap) {
                final btSupported = btSnap.data ?? false;
                return FutureBuilder<bool>(
                  future: NFCScannerService.isNFCSupported(),
                  builder: (context, nfcSnap) {
                    final nfcSupported = nfcSnap.data ?? false;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusIndicator(
                          l10n.bluetooth,
                          supported: btSupported,
                          on: _isBluetoothEnabled,
                          iconOn: Icons.bluetooth,
                          iconOff: Icons.bluetooth_disabled,
                        ),
                        _buildStatusIndicator(
                          l10n.nfc,
                          supported: nfcSupported,
                          on: _isNFCEnabled,
                          iconOn: Icons.nfc,
                          iconOff: Icons.nfc,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(
    String label, {
    required bool supported,
    required bool on,
    required IconData iconOn,
    required IconData iconOff,
  }) {
    final l10n = AppLocalizations.of(context)!;
    Color iconColor;
    String stateText;
    Color textColor;
    IconData iconData;

    if (!supported) {
      iconColor = Colors.orange[700]!;
      textColor = Colors.orange[700]!;
      stateText = l10n.unsupported;
      iconData = iconOff;
    } else if (on) {
      iconColor = Colors.green[700]!;
      textColor = Colors.green[700]!;
      stateText = l10n.available;
      iconData = iconOn;
    } else {
      iconColor = Colors.red[600]!;
      textColor = Colors.red[600]!;
      stateText = l10n.off; // adapter present but off
      iconData = iconOff;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(iconData, size: 28, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          stateText,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildBluetoothSection() {
    final l10n = AppLocalizations.of(context)!;
    return TreeBackgroundCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bluetooth,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.bluetoothScanners,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.bluetoothScannersIntro,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (!_isBluetoothEnabled)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange[800]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.bluetoothNotEnabled,
                        style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            if (!_isBluetoothEnabled) ...[
              const SizedBox(height: 12),
              if (widget.purchaseService.isProUser)
                ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.search),
                  label: Text(l10n.startBluetoothScan),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                )
              else
                _buildProFeatureButton(
                  icon: Icons.search,
                  text: l10n.startBluetoothScan,
                  onTap: () => showProUnlockDialog(context, widget.purchaseService),
                ),
            ]
            else ...[
              if (widget.purchaseService.isProUser)
              ElevatedButton.icon(
                onPressed: _isScanning ? null : _startBluetoothScan,
                icon: _isScanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                  label: Text(
                    _isScanning ? l10n.scanning : l10n.startBluetoothScan,
                  ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                )
              else
                _buildProFeatureButton(
                  icon: Icons.search,
                  text: l10n.startBluetoothScan,
                  onTap: () =>
                      showProUnlockDialog(context, widget.purchaseService),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNFCSection() {
    final l10n = AppLocalizations.of(context)!;
    return TreeBackgroundCard(
      treeOpacity: 0.15,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.nfc, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.nfcScanning,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isNFCEnabled)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                      const SizedBox(height: 8),
                      Text(
                      l10n.nfcAvailableMessage,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.blue[700]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
            ),
            const SizedBox(height: 16),
            if (!_isNFCEnabled)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange[800]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.nfcNotAvailable,
                        style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            if (!_isNFCEnabled) ...[
              const SizedBox(height: 12),
              if (widget.purchaseService.isProUser)
                ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.touch_app),
                  label: Text(l10n.scanWithNFC),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                )
              else
                _buildProFeatureButton(
                  icon: Icons.touch_app,
                  text: l10n.scanWithNFC,
                  onTap: () => showProUnlockDialog(context, widget.purchaseService),
                ),
            ]
            else if (widget.purchaseService.isProUser)
              ElevatedButton.icon(
                onPressed: _isScanning ? null : _startNFCScan,
                icon: _isScanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.touch_app),
                label: Text(_isScanning ? l10n.scanning : l10n.scanWithNFC),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              )
            else
              _buildProFeatureButton(
                icon: Icons.touch_app,
                text: l10n.scanWithNFC,
                onTap: () =>
                    showProUnlockDialog(context, widget.purchaseService),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPairedDevicesSection() {
    final l10n = AppLocalizations.of(context)!;
    return TreeBackgroundCard(
      treeOpacity: 0.12,
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (widget.purchaseService.isProUser)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      l10n.pro,
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_pairedDevices.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                    const SizedBox(height: 8),
              Text(
                l10n.noPairedDevices,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.blue[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.pairedDevicesMessage,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.blue[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.nfcNoPairedListInfo,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.blue[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ..._pairedDevices.map(
                (device) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: device.isConnected
                        ? const Color(0xFFE8F5E8)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: device.isConnected
                          ? const Color(0xFF2E7D32).withValues(alpha: 0.3)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bluetooth_connected,
                        color: device.isConnected
                            ? const Color(0xFF2E7D32)
                            : Colors.grey[600],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<String?>(
                              future: DeviceStore.getAlias(device.address),
                              builder: (context, snap) {
                                final alias = snap.data;
                                final title = alias?.isNotEmpty == true
                                    ? alias!
                                    : device.name;
                                return Text(
                                  title,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: device.isConnected
                                        ? const Color(0xFF2E7D32)
                                        : Colors.grey[700],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 2),
                            Text(
                              device.address,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: device.isConnected
                                        ? const Color(0xFF1B5E20)
                                        : Colors.grey[600],
                                    fontFamily: 'monospace',
                                  ),
                            ),
                            if (device.deviceClass != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${AppLocalizations.of(context)!.deviceClass}: ${device.deviceClass}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: device.isConnected
                                          ? const Color(0xFF1B5E20)
                                          : Colors.grey[600],
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      FutureBuilder<bool>(
                        future: DeviceStore.isRemembered(device.address),
                        builder: (context, snap) {
                          final remembered = snap.data ?? false;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                device.isConnected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color:
                                    device.isConnected ? Colors.green : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              PopupMenuButton<String>(
                                tooltip: AppLocalizations.of(context)!.deviceActions,
                                onSelected: (value) async {
                                  if (value == 'remember') {
                                    await DeviceStore.rememberDevice(device.address);
                                    if (mounted) setState(() {});
                                  } else if (value == 'forget') {
                                    await DeviceStore.forgetDevice(device.address);
                                    if (mounted) setState(() {});
                                  } else if (value == 'alias') {
                                    final existingAlias =
                                        await DeviceStore.getAlias(device.address) ?? '';
                  if (!context.mounted) return;
                                    final controller =
                                        TextEditingController(text: existingAlias);
                                    final newName = await showDialog<String>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(AppLocalizations.of(ctx)!.setDeviceAlias),
                                        content: TextField(
                                          controller: controller,
                                          decoration: InputDecoration(
                                            labelText: AppLocalizations.of(ctx)!.alias,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: Text(AppLocalizations.of(ctx)!.cancel),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                                            child: Text(AppLocalizations.of(ctx)!.save),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (newName != null) {
                                      await DeviceStore.setAlias(device.address, newName);
                                      if (mounted) setState(() {});
                                    }
                                  } else if (value == 'disconnect') {
                                    await BluetoothScannerService.disconnect();
                                    if (mounted) setState(() {});
                                  }
                                },
                                itemBuilder: (ctx) => [
                                  if (!remembered)
                                    PopupMenuItem(
                                      value: 'remember',
                                      child: Text(AppLocalizations.of(ctx)!.rememberDevice),
                                    ),
                                  if (remembered)
                                    PopupMenuItem(
                                      value: 'forget',
                                      child: Text(AppLocalizations.of(ctx)!.forgetDevice),
                                    ),
                                  PopupMenuItem(
                                    value: 'alias',
                                    child: Text('${AppLocalizations.of(ctx)!.setAlias}…'),
                                  ),
                                  PopupMenuItem(
                                    value: 'disconnect',
                                    child: Text(AppLocalizations.of(ctx)!.disconnect),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimersCard() {
    final l10n = AppLocalizations.of(context)!;
    return TreeBackgroundCard(
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
              '• ${l10n.scannerCompatibilityDisclaimer}\n'
              '• ${l10n.scannerDataDisclaimer}\n'
              '• ${l10n.nfcNdefSupportNote}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build a Pro feature button that shows unlock dialog when tapped
  Widget _buildProFeatureButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[100]!, Colors.grey[200]!],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.pro,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
