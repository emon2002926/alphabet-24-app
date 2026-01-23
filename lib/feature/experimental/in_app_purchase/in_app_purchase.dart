// lib/screens/premium_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// lib/screens/premium_screen.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// ========== IAP CONTROLLER ==========
class IAPController extends GetxController {
  final InAppPurchase _iap = InAppPurchase.instance;

  RxBool isAvailable = false.obs;
  RxBool isPremium = false.obs;
  RxBool isLoading = false.obs;
  RxList<ProductDetails> products = <ProductDetails>[].obs;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Enable this for testing without store setup
  static const bool _testMode = true;

  // Product IDs - Must match App Store Connect & Google Play Console
  static const Set<String> _productIds = {
    'com.mariakampli.alphabets.premium_monthly',
    'com.mariakampli.alphabets.premium_yearly',
  };

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    isLoading.value = true;

    // Test mode - skip store connection
    if (_testMode) {
      await _loadMockProducts();
      isAvailable.value = true;
      isLoading.value = false;
      return;
    }

    // Real mode - connect to stores
    isAvailable.value = await _iap.isAvailable();

    if (!isAvailable.value) {
      isLoading.value = false;
      return;
    }

    _subscription = _iap.purchaseStream.listen(_handlePurchaseUpdates);

    final response = await _iap.queryProductDetails(_productIds);
    products.value = response.productDetails;

    await _iap.restorePurchases();
    isLoading.value = false;
  }

  // Mock products for testing
  Future<void> _loadMockProducts() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate loading

    products.value = [
      _MockProductDetails(
        id: 'com.yourapp.premium_monthly',
        title: 'Premium Monthly',
        description: 'Unlock all features for 1 month',
        price: '\$4.99',
        rawPrice: 4.99,
        currencyCode: 'USD',
      ),
      _MockProductDetails(
        id: 'com.yourapp.premium_yearly',
        title: 'Premium Yearly',
        description: 'Unlock all features for 1 year (Save 50%)',
        price: '\$29.99',
        rawPrice: 29.99,
        currencyCode: 'USD',
      ),
    ];
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        isLoading.value = true;
      } else {
        isLoading.value = false;

        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          isPremium.value = true;
          _showSnackbar('Success! 🎉', 'You now have Premium access!', Color(0xFF00D9B5));
        } else if (purchase.status == PurchaseStatus.error) {
          _showSnackbar('Error', purchase.error?.message ?? 'Purchase failed', Colors.red);
        }

        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
    }
  }

  Future<void> buy(ProductDetails product) async {
    if (isLoading.value) return;
    isLoading.value = true;

    // Test mode - simulate purchase
    if (_testMode) {
      await Future.delayed(Duration(seconds: 2)); // Simulate processing
      isPremium.value = true;
      isLoading.value = false;
      _showSnackbar('Success! 🎉', 'Test purchase completed!', Color(0xFF00D9B5));
      return;
    }

    // Real purchase
    try {
      await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
    } catch (e) {
      isLoading.value = false;
      _showSnackbar('Error', e.toString(), Colors.red);
    }
  }

  Future<void> restore() async {
    isLoading.value = true;

    // Test mode
    if (_testMode) {
      await Future.delayed(Duration(seconds: 1));
      isLoading.value = false;
      _showSnackbar('Info', 'No previous purchases found (Test Mode)', Colors.orange);
      return;
    }

    await _iap.restorePurchases();
    isLoading.value = false;
  }

  void _showSnackbar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(12),
      borderRadius: 8,
    );
  }

  // Get current platform
  String get currentPlatform {
    if (Platform.isIOS) return 'Apple App Store';
    if (Platform.isAndroid) return 'Google Play';
    return 'Unknown';
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}

// ========== MOCK PRODUCT DETAILS ==========
class _MockProductDetails extends ProductDetails {
  _MockProductDetails({
    required String id,
    required String title,
    required String description,
    required String price,
    required double rawPrice,
    required String currencyCode,
  }) : super(
    id: id,
    title: title,
    description: description,
    price: price,
    rawPrice: rawPrice,
    currencyCode: currencyCode,
  );
}

// ========== PREMIUM SCREEN ==========
class PremiumScreen extends StatelessWidget {
  final controller = Get.put(IAPController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121212) : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Go Premium',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value && controller.products.isEmpty) {
          return Center(child: CircularProgressIndicator(color: Color(0xFF00D9B5)));
        }

        // Not available
        if (!controller.isAvailable.value) {
          return _buildNotAvailable(isDark);
        }

        // No products
        if (controller.products.isEmpty) {
          return Center(
            child: Text('No products available', style: TextStyle(fontFamily: 'Poppins')),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Test Mode Banner
              if (IAPController._testMode) _buildTestModeBanner(),

              // Premium Banner
              _buildBanner(),
              SizedBox(height: 24),

              // Product Cards
              ...controller.products.map((p) => _buildProductCard(p, isDark)),

              SizedBox(height: 16),

              // Restore Button
              TextButton(
                onPressed: controller.isLoading.value ? null : () => controller.restore(),
                child: Text(
                  'Restore Purchases',
                  style: TextStyle(color: Color(0xFF00D9B5), fontFamily: 'Poppins'),
                ),
              ),

              SizedBox(height: 8),

              // Platform Info
              Text(
                'Platform: ${controller.currentPlatform}',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
              ),

              SizedBox(height: 8),

              // Terms
              Text(
                Platform.isIOS
                    ? 'Payment will be charged to your Apple ID account. Subscription automatically renews unless canceled at least 24 hours before the end of the current period.'
                    : 'Payment will be charged to your Google Play account. Subscription automatically renews unless canceled at least 24 hours before the end of the current period.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Poppins'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTestModeBanner() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          Icon(Icons.bug_report, color: Colors.orange, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'TEST MODE - No real charges will be made',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotAvailable(bool isDark) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'In-App Purchases Not Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 8),
            Text(
              Platform.isIOS
                  ? 'Please ensure you have set up In-App Purchases in App Store Connect and are signed in with a Sandbox tester account.'
                  : 'Please ensure you have set up In-App Purchases in Google Play Console and are using a test account.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => controller._init(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00D9B5),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00D9B5), Color(0xFF00B894)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.workspace_premium, size: 56, color: Colors.white),
          SizedBox(height: 12),
          Text(
            'Unlock Premium',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 16),
          _feature('Unlimited Predictions'),
          _feature('Advanced Statistics'),
          _feature('Ad-Free Experience'),
          _feature('Priority Support'),
        ],
      ),
    );
  }

  Widget _feature(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductDetails product, bool isDark) {
    final isYearly = product.id.contains('yearly');

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isYearly ? Color(0xFF00D9B5) : Colors.grey.withOpacity(0.3),
          width: isYearly ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          // Best Value Badge
          if (isYearly)
            Positioned(
              top: 0,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF00D9B5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  'BEST VALUE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),

          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Platform Icon
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.grey).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Platform.isIOS ? Icons.apple : Icons.android,
                    color: Platform.isIOS ? (isDark ? Colors.white : Colors.black) : Colors.green,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title.replaceAll(RegExp(r'\(.*\)'), '').trim(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        product.description,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                // Buy Button
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.buy(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00D9B5),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : Text(
                    product.price,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}