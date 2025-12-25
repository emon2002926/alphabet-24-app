import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/subscription_controller.dart';
// Import your controller file
// import 'subscription_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(SubscriptionController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subscription',
          style: STextTheme.headLine(),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: CircleAvatar(
              backgroundColor: SColor.primary,
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.favorite, color: SColor.primary),
          ),
        ],
      ),
      body: Obx(() {
        // Show loading indicator on initial load
        if (controller.isLoading.value && controller.plans.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Show error message with retry option
        if (controller.errorMessage.value.isNotEmpty && controller.plans.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load plans',
                  style: STextTheme.headLine(),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    controller.errorMessage.value,
                    style: STextTheme.subHeadLine(),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.retry,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColor.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        // Main content - keeping original design exactly
        return SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Get Premium',
                style: STextTheme.headLine().copyWith(fontSize: 32),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: DynamicSize.small(context)),
              Text(
                'Subscribe to our premium plan and enjoy exclusive benefits!',
                style: STextTheme.subHeadLine().copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: DynamicSize.small(context)),
              Image.asset(
                'assets/images/subscriptiom.png',
                width: double.infinity,
              ),
              SizedBox(height: DynamicSize.medium(context)),

              // 🔹 Dynamic plans from API or fallback to static plans
              if (controller.plans.isNotEmpty)
              // Render plans from API
                ...List.generate(
                  controller.plans.length,
                      (index) {
                    final plan = controller.plans[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: DynamicSize.medium(context),
                      ),
                      child: Obx(() => GestureDetector(
                        onTap: () {
                          controller.selectPlan(index);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF2C2C2C)
                                : const Color(0xFFF0F8FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: controller.selectedPlanIndex.value == index
                                  ? SColor.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.name,
                                style: STextTheme.headLine().copyWith(fontSize: 18),
                              ),
                              Text(
                                _buildPlanDescription(plan),
                                style: STextTheme.subHeadLine().copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      )),
                    );
                  },
                )
              else
              // Fallback to original static design
                ...[
                  // 🔹 Monthly Plan
                  Obx(() => GestureDetector(
                    onTap: () {
                      controller.selectPlan(0);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF2C2C2C)
                            : const Color(0xFFF0F8FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: controller.selectedPlanIndex.value == 0
                              ? SColor.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Monthly',
                              style: STextTheme.headLine().copyWith(fontSize: 18)),
                          Text(
                            'First 7 days free - Then \$9.99/month',
                            style: STextTheme.subHeadLine().copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )),
                  SizedBox(height: DynamicSize.medium(context)),

                  // 🔹 Yearly Plan
                  Obx(() => GestureDetector(
                    onTap: () {
                      controller.selectPlan(1);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF2C2C2C)
                            : const Color(0xFFF0F8FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: controller.selectedPlanIndex.value == 1
                              ? SColor.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Yearly',
                              style: STextTheme.headLine().copyWith(fontSize: 18)),
                          Text(
                            'Save 20% - \$99/year',
                            style: STextTheme.subHeadLine().copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],

              SizedBox(height: DynamicSize.large(context)),

              // 🔹 Subscribe Button - Original design with loading state
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.selectedPlanIndex.value == -1
                      ? null
                      : controller.isLoading.value
                      ? null
                      : controller.subscribeToPlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.selectedPlanIndex.value == -1
                        ? Colors.grey
                        : SColor.primary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
                    'Subscribe Now',
                    style: STextTheme.headLine()
                        .copyWith(color: Colors.white, fontSize: 18),
                  ),
                )),
              ),

              SizedBox(height: DynamicSize.small(context)),

              // 🔹 Terms & Conditions - Original design
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'By placing this order, you agree to the ',
                  style: STextTheme.subHeadLine()
                      .copyWith(fontSize: 12, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Terms of Service',
                      style: STextTheme.subHeadLine().copyWith(
                          fontSize: 12,
                          color: SColor.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: STextTheme.subHeadLine().copyWith(
                          fontSize: 12,
                          color: SColor.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text:
                      '. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Helper method to build plan description from API data
  String _buildPlanDescription(PlanModel plan) {
    String description = '';

    if (plan.trialPeriodDays > 0) {
      description += 'First ${plan.trialPeriodDays} days free - Then ';
    }

    description += plan.displayPrice;

    if (plan.discountPercentage > 0) {
      description += ' (Save ${plan.discountPercentage}%)';
    }

    return description;
  }
}