import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing in-app purchases and Pro features
class PurchaseService extends ChangeNotifier {
  static const String _proProductId =
      'com.nickotmazgin.chipcompanion.pro_unlock';
  static const String _proStatusKey = 'pro_user_status';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isProUser = false;
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isProUser => _isProUser;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Initialize the purchase service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Check if user is already a Pro user
      await _loadProStatus();

      // Skip IAP initialization on web for now
      if (kIsWeb) {
        if (kDebugMode) debugPrint('Running on web - IAP features disabled');
        _isInitialized = true;
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Set up purchase stream listener
      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () {
          if (kDebugMode) debugPrint('Purchase stream closed');
        },
        onError: (error) {
          if (kDebugMode) debugPrint('Purchase stream error: $error');
          _errorMessage = 'Purchase system error: $error';
          _isLoading = false;
          notifyListeners();
        },
      );

      // Check if purchases are available
      final isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        _errorMessage = 'In-app purchases are not available on this device';
        if (kDebugMode) debugPrint('In-app purchases not available');
      }

      _isInitialized = true;
      _isLoading = false;
      notifyListeners();

      if (kDebugMode) {
        debugPrint('PurchaseService initialized. Pro user: $_isProUser');
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize purchase service: $e';
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
      if (kDebugMode) debugPrint('Error initializing PurchaseService: $e');
    }
  }

  /// Load Pro status from shared preferences
  Future<void> _loadProStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isProUser = prefs.getBool(_proStatusKey) ?? false;
      if (kDebugMode) debugPrint('Loaded Pro status: $_isProUser');
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading Pro status: $e');
      _isProUser = false;
    }
  }

  /// Save Pro status to shared preferences
  Future<void> _saveProStatus(bool isPro) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_proStatusKey, isPro);
      if (kDebugMode) debugPrint('Saved Pro status: $isPro');
    } catch (e) {
      if (kDebugMode) debugPrint('Error saving Pro status: $e');
    }
  }

  /// Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.productID == _proProductId) {
        _handleProPurchase(purchaseDetails);
      }
    }
  }

  /// Handle Pro purchase
  Future<void> _handleProPurchase(PurchaseDetails purchaseDetails) async {
    try {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Purchase successful
        _isProUser = true;
        await _saveProStatus(true);
        _errorMessage = null;

        if (kDebugMode) debugPrint('Pro purchase successful');

        // Complete the purchase
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        _errorMessage =
            'Purchase failed: ${purchaseDetails.error?.message ?? 'Unknown error'}';
        if (kDebugMode) debugPrint('Purchase error: ${purchaseDetails.error}');
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        _errorMessage = 'Purchase was canceled';
        if (kDebugMode) debugPrint('Purchase canceled');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error handling purchase: $e';
      _isLoading = false;
      notifyListeners();
      if (kDebugMode) debugPrint('Error handling Pro purchase: $e');
    }
  }

  /// Buy Pro unlock
  Future<bool> buyProUnlock() async {
    if (!_isInitialized) {
      _errorMessage = 'Purchase service not initialized';
      return false;
    }

    // On web, show a message that IAP is not available
    if (kIsWeb) {
      _errorMessage =
          'In-app purchases are not available on web. Please use the mobile app.';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Get product details
      final productDetailsResponse = await _inAppPurchase.queryProductDetails({
        _proProductId,
      });

      if (productDetailsResponse.error != null) {
        _errorMessage =
            'Failed to get product details: ${productDetailsResponse.error!.message}';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (productDetailsResponse.productDetails.isEmpty) {
        _errorMessage = 'Pro unlock product not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Start purchase
      final productDetails = productDetailsResponse.productDetails.first;
      final purchaseParam = PurchaseParam(productDetails: productDetails);

      final success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (!success) {
        _errorMessage = 'Failed to start purchase';
        _isLoading = false;
        notifyListeners();
      }

      return success;
    } catch (e) {
      _errorMessage = 'Error starting purchase: $e';
      _isLoading = false;
      notifyListeners();
      if (kDebugMode) debugPrint('Error buying Pro unlock: $e');
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    if (!_isInitialized) {
      _errorMessage = 'Purchase service not initialized';
      return false;
    }

    // On web, show a message that IAP is not available
    if (kIsWeb) {
      _errorMessage =
          'In-app purchases are not available on web. Please use the mobile app.';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _inAppPurchase.restorePurchases();

      // The purchase stream will handle the restoration
      return true;
    } catch (e) {
      _errorMessage = 'Error restoring purchases: $e';
      _isLoading = false;
      notifyListeners();
      if (kDebugMode) debugPrint('Error restoring purchases: $e');
      return false;
    }
  }

  /// Get product details for display
  Future<ProductDetails?> getProductDetails() async {
    if (!_isInitialized) return null;
    // Skip querying product details on web
    if (kIsWeb) return null;

    try {
      final productDetailsResponse = await _inAppPurchase.queryProductDetails({
        _proProductId,
      });

      if (productDetailsResponse.error != null ||
          productDetailsResponse.productDetails.isEmpty) {
        return null;
      }

      return productDetailsResponse.productDetails.first;
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting product details: $e');
      return null;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
