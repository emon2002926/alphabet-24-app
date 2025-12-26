import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/const/string_const/API_endpoint.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/local_storage/user_info.dart';
import '../views/checkout_webView.dart';

class SubscriptionController extends GetxController {
  // Observables
  var isLoading = false.obs;
  var plans = <PlanModel>[].obs;
  var selectedPlanIndex = (-1).obs;
  var errorMessage = ''.obs;

  // Base URL - Replace with your actual base URL
  final String baseUrl = "https://alfabets.dsrt321.online/api";
  // Auth token - Replace with your actual token retrieval logic
  String? get authToken => UserInfo.getAccessToken();

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  // Fetch all subscription plans
  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('$baseUrl/payment/plans/'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          // If API returns single plan
          if (data['plan'] != null) {
            plans.value = [PlanModel.fromJson(data['plan'])];
          }
          // If API returns multiple plans
          else if (data['plans'] != null) {
            plans.value = (data['plans'] as List)
                .map((plan) => PlanModel.fromJson(plan))
                .toList();
          }
        } else {
          errorMessage.value = 'Failed to load plans';
        }
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print('Error fetching plans: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Select a plan
  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  // Get selected plan
  PlanModel? get selectedPlan {
    if (selectedPlanIndex.value >= 0 && selectedPlanIndex.value < plans.length) {
      return plans[selectedPlanIndex.value];
    }
    return null;
  }

  // Create checkout session and get payment URL
// Create checkout session and get payment URL
  Future<CheckoutResponse?> createCheckoutSession(String planId) async {
    try {
      print('🔄 Creating checkout session for plan: $planId');

      final response = await http.post(
        Uri.parse('$baseUrl/payment/checkout/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'plan_id': planId,
        }),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return CheckoutResponse(
            success: true,
            sessionId: data['session_id'],
            checkoutUrl: data['checkout_url'],
          );
        } else {
          // Show the exact error message from backend
          final errorMsg = data['error'] ?? 'Failed to create checkout session';
          Get.snackbar(
            'Error',
            errorMsg,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
          );
          return null;
        }
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Authentication Error',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      } else {
        // Parse error message from non-200 responses too
        try {
          final data = json.decode(response.body);
          final errorMsg = data['error'] ?? 'Server error: ${response.statusCode}';
          Get.snackbar(
            'Error',
            errorMsg,
            snackPosition: SnackPosition.BOTTOM,
          );
        } catch (e) {
          // If JSON parsing fails, show status code
          Get.snackbar(
            'Error',
            'Server error: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        return null;
      }
    } catch (e) {
      print('❌ Error creating checkout session: $e');
      Get.snackbar(
        'Error',
        'Failed to create checkout session: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
  // Subscribe to selected plan - Opens WebView for payment
  Future<void> subscribeToPlan() async {
    if (selectedPlan == null) {
      Get.snackbar(
        'Error',
        'Please select a plan',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Create checkout session
      final checkoutResponse = await createCheckoutSession(selectedPlan!.id);

      if (checkoutResponse != null && checkoutResponse.checkoutUrl.isNotEmpty) {
        print('✅ Checkout URL received: ${checkoutResponse.checkoutUrl}');

        // Navigate to WebView with checkout URL
        Get.to(
              () => CheckoutWebView(url: checkoutResponse.checkoutUrl),
          fullscreenDialog: true,
          transition: Transition.cupertino,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to get payment URL',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Error in subscribeToPlan: $e');
      Get.snackbar(
        'Error',
        'Subscription failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Retry fetching plans
  void retry() {
    fetchPlans();
  }
}

// Checkout Response Model
class CheckoutResponse {
  final bool success;
  final String sessionId;
  final String checkoutUrl;

  CheckoutResponse({
    required this.success,
    required this.sessionId,
    required this.checkoutUrl,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      success: json['success'] ?? false,
      sessionId: json['session_id'] ?? '',
      checkoutUrl: json['checkout_url'] ?? '',
    );
  }
}

// Plan Model
class PlanModel {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String shortDescription;
  final String planType;
  final String price;
  final String? originalPrice;
  final String currency;
  final String interval;
  final int intervalCount;
  final int trialPeriodDays;
  final List<String> features;
  final int? maxApiCalls;
  final int? maxUsers;
  final int? maxProjects;
  final int? maxStorageGb;
  final bool isFeatured;
  final bool isPopular;
  final String? badgeText;
  final bool isLifetime;
  final bool isRecurring;
  final bool isUnlimitedApi;
  final String displayPrice;
  final int discountPercentage;

  PlanModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.shortDescription,
    required this.planType,
    required this.price,
    this.originalPrice,
    required this.currency,
    required this.interval,
    required this.intervalCount,
    required this.trialPeriodDays,
    required this.features,
    this.maxApiCalls,
    this.maxUsers,
    this.maxProjects,
    this.maxStorageGb,
    required this.isFeatured,
    required this.isPopular,
    this.badgeText,
    required this.isLifetime,
    required this.isRecurring,
    required this.isUnlimitedApi,
    required this.displayPrice,
    required this.discountPercentage,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['short_description'] ?? '',
      planType: json['plan_type'] ?? '',
      price: json['price']?.toString() ?? '0.00',
      originalPrice: json['original_price']?.toString(),
      currency: json['currency'] ?? 'usd',
      interval: json['interval'] ?? 'month',
      intervalCount: json['interval_count'] ?? 1,
      trialPeriodDays: json['trial_period_days'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
      maxApiCalls: json['max_api_calls'],
      maxUsers: json['max_users'],
      maxProjects: json['max_projects'],
      maxStorageGb: json['max_storage_gb'],
      isFeatured: json['is_featured'] ?? false,
      isPopular: json['is_popular'] ?? false,
      badgeText: json['badge_text'],
      isLifetime: json['is_lifetime'] ?? false,
      isRecurring: json['is_recurring'] ?? false,
      isUnlimitedApi: json['is_unlimited_api'] ?? false,
      displayPrice: json['display_price'] ?? '',
      discountPercentage: json['discount_percentage'] ?? 0,
    );
  }
}