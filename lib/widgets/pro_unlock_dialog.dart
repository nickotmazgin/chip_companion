import 'package:flutter/material.dart';
import 'package:chip_companion/l10n/app_localizations.dart';
import 'package:chip_companion/services/purchase_service.dart';
import 'package:chip_companion/widgets/tree_ui_components.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Dialog for unlocking Pro features
class ProUnlockDialog extends StatefulWidget {
  final PurchaseService purchaseService;

  const ProUnlockDialog({super.key, required this.purchaseService});

  @override
  State<ProUnlockDialog> createState() => _ProUnlockDialogState();
}

class _ProUnlockDialogState extends State<ProUnlockDialog> {
  ProductDetails? _productDetails;
  bool _isLoadingProduct = true;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    final details = await widget.purchaseService.getProductDetails();
    if (mounted) {
      setState(() {
        _productDetails = details;
        _isLoadingProduct = false;
      });
    }
  }

  Future<void> _buyPro() async {
    if (widget.purchaseService.isLoading) return; // Prevent double-tap
    
    final l10n = AppLocalizations.of(context)!;
    final success = await widget.purchaseService.buyProUnlock();
    
    if (!mounted) return; // Guard against widget disposal
    
    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.proUnlocked),
          backgroundColor: Colors.green,
        ),
      );
    } else if (widget.purchaseService.errorMessage != null) {
      // Show error if present
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.purchaseService.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _restorePurchases() async {
    if (widget.purchaseService.isLoading) return; // Prevent double-tap
    
    final l10n = AppLocalizations.of(context)!;
    
    // Show checking message immediately
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.checkingPurchases),
          backgroundColor: Colors.blue,
        ),
      );
    }
    
    final success = await widget.purchaseService.restorePurchases();
    
    if (!mounted) return; // Guard against widget disposal
    
    if (!success && widget.purchaseService.errorMessage != null) {
      // Show error if present
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.purchaseService.errorMessage!),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TreeBackgroundCard(
        treeOpacity: 0.08,
        elevation: 8,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.star, size: 48, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      l10n.unlockProFeatures,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.proFeatures,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Features list
                    _buildFeatureItem(
                      Icons.bluetooth,
                      l10n.bluetoothScanningPro,
                      l10n.connectExternalScanners,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      Icons.nfc,
                      l10n.nfcScanningPro,
                      l10n.tapToScanNFC,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      Icons.devices_other,
                      l10n.deviceManagementPro,
                      l10n.enhancedDeviceInfo,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      Icons.support,
                      l10n.prioritySupportPro,
                      l10n.getHelpWhenNeeded,
                    ),

                    const SizedBox(height: 24),

                    // Price display
                    if (_isLoadingProduct)
                      const Center(child: CircularProgressIndicator())
                    else if (_productDetails != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${l10n.oneTimePurchase}: ',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  _productDetails!.price,
                                  style: Theme.of(context).textTheme.headlineSmall
                                      ?.copyWith(
                                        color: const Color(0xFF2E7D32),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.noSubscriptionLifetimeAccess,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF1B5E20),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      )
                    else if (!kIsWeb)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.unableToLoadPricing,
                                style: TextStyle(color: Colors.orange[700]),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (kIsWeb) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.proWebPurchaseNotice,
                                style: TextStyle(color: Colors.blue[800]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: widget.purchaseService.isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: Text(l10n.maybeLater),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: kIsWeb
                                ? null
                                : (_isLoadingProduct || widget.purchaseService.isLoading
                                    ? null
                                    : _buyPro),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: widget.purchaseService.isLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(l10n.unlockPro),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Restore purchases button (always visible, especially important for iOS)
                    Center(
                      child: TextButton(
                        onPressed: kIsWeb
                            ? null
                            : (_isLoadingProduct || widget.purchaseService.isLoading
                                ? null
                                : _restorePurchases),
                        child: Text(l10n.restorePurchases),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2E7D32), size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Show Pro unlock dialog
void showProUnlockDialog(
  BuildContext context,
  PurchaseService purchaseService,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ProUnlockDialog(purchaseService: purchaseService),
  );
}
