import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../models/iap_product.dart';
import 'storage_service.dart';

class IAPService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final StorageService _storageService;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _purchasePending = false;

  IAPService(this._storageService);

  Future<void> init() async {
    // Check if IAP is available
    _isAvailable = await _iap.isAvailable();

    if (!_isAvailable) {
      return;
    }

    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) {
        // Handle error
      },
    );

    // Load products
    await _loadProducts();

    // Restore previous purchases
    await restorePurchases();
  }

  Future<void> _loadProducts() async {
    if (!_isAvailable) return;

    final productIds = IAPProduct.allProducts.map((p) => p.id).toSet();

    try {
      final response = await _iap.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        // Some products were not found
        print('Products not found: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _purchasePending = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _purchasePending = false;
          // Handle error
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _purchasePending = false;
          _handleSuccessfulPurchase(purchaseDetails);
        }

        // Complete the purchase
        if (purchaseDetails.pendingCompletePurchase) {
          _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails details) async {
    final product = IAPProduct.getById(details.productID);
    if (product == null) return;

    // Save non-consumable purchases
    if (product.type == IAPProductType.nonConsumable ||
        product.type == IAPProductType.subscription) {
      await _storageService.savePurchasedItem(product.id);
    }

    // The actual granting of items (coins, gems, etc.) should be handled
    // by the GameProvider when it receives notification of the purchase
  }

  Future<bool> purchaseProduct(String productId) async {
    if (!_isAvailable || _purchasePending) return false;

    final productDetails = _products.firstWhere(
      (product) => product.id == productId,
      orElse: () => throw Exception('Product not found'),
    );

    final purchaseParam = PurchaseParam(productDetails: productDetails);

    try {
      final success = await _iap.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );
      return success;
    } catch (e) {
      print('Error purchasing product: $e');
      return false;
    }
  }

  Future<bool> purchaseNonConsumable(String productId) async {
    if (!_isAvailable || _purchasePending) return false;

    final productDetails = _products.firstWhere(
      (product) => product.id == productId,
      orElse: () => throw Exception('Product not found'),
    );

    final purchaseParam = PurchaseParam(productDetails: productDetails);

    try {
      final success = await _iap.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      return success;
    } catch (e) {
      print('Error purchasing product: $e');
      return false;
    }
  }

  Future<void> restorePurchases() async {
    if (!_isAvailable) return;

    try {
      await _iap.restorePurchases();
    } catch (e) {
      print('Error restoring purchases: $e');
    }
  }

  ProductDetails? getProductDetails(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  List<ProductDetails> get availableProducts => _products;
  bool get isAvailable => _isAvailable;
  bool get isPurchasePending => _purchasePending;

  void dispose() {
    _subscription?.cancel();
  }
}
