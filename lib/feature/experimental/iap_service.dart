// lib/services/iap_service.dart
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService extends GetxController {
  static IAPService get to => Get.find();

  final InAppPurchase _iap = InAppPurchase.instance;

  // Observable states
  RxBool isAvailable = false.obs;
  RxBool isPremium = false.obs;
  RxBool isPurchasing = false.obs;
  RxList<ProductDetails> products = <ProductDetails>[].obs;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Your product IDs (must match App Store Connect)
  static const Set<String> _productIds = {
    'com.yourapp.premium_monthly',
    'com.yourapp.premium_yearly',
  };

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    // Check if IAP is available
    isAvailable.value = await _iap.isAvailable();

    if (!isAvailable.value) {
      print('❌ In-App Purchase not available');
      return;
    }

    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) => print('❌ Purchase stream error: $error'),
    );

    // Load products
    await loadProducts();

    // Restore previous purchases
    await restorePurchases();
  }

  Future<void> loadProducts() async {
    final ProductDetailsResponse response =
    await _iap.queryProductDetails(_productIds);

    if (response.notFoundIDs.isNotEmpty) {
      print('⚠️ Products not found: ${response.notFoundIDs}');
    }

    products.value = response.productDetails;
    print('✅ Loaded ${products.length} products');
  }

  Future<void> buyProduct(ProductDetails product) async {
    if (isPurchasing.value) return;

    isPurchasing.value = true;

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
    );

    try {
      // For subscriptions
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      // For consumables use:
      // await _iap.buyConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      print('❌ Purchase error: $e');
      isPurchasing.value = false;
    }
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      _handlePurchase(purchase);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.pending) {
      // Show loading indicator
      isPurchasing.value = true;
    } else {
      isPurchasing.value = false;

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Verify purchase with your backend (recommended)
        final valid = await _verifyPurchase(purchase);

        if (valid) {
          isPremium.value = true;
          _showSuccessSnackbar();
        }
      } else if (purchase.status == PurchaseStatus.error) {
        _showErrorSnackbar(purchase.error?.message ?? 'Purchase failed');
      } else if (purchase.status == PurchaseStatus.canceled) {
        print('Purchase canceled');
      }

      // Complete the purchase
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // TODO: Send receipt to your backend for verification
    // This is important for security!

    // For now, return true (implement backend verification later)
    return true;
  }

  void _showSuccessSnackbar() {
    Get.snackbar(
      'Success! 🎉',
      'You now have Premium access!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xFF00D9B5),
      colorText: Colors.white,
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Purchase Failed',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}