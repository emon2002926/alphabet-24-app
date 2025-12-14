import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/core/theme/text_theme.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedIndex = -1; // For tracking selected plan

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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

            // 🔹 Monthly Plan
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F8FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selectedIndex == 0 ? SColor.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Monthly', style: STextTheme.headLine().copyWith(fontSize: 18)),
                    Text(
                      'First 7 days free - Then \$9.99/month',
                      style: STextTheme.subHeadLine().copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: DynamicSize.medium(context)),

            // 🔹 Yearly Plan
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F8FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selectedIndex == 1 ? SColor.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Yearly', style: STextTheme.headLine().copyWith(fontSize: 18)),
                    Text(
                      'Save 20% - \$99/year',
                      style: STextTheme.subHeadLine().copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: DynamicSize.large(context)),

            // 🔹 Subscribe Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIndex == -1
                    ? null
                    : () {
                  // TODO: Handle actual subscription logic
                  Get.snackbar(
                    'Subscribed!',
                    selectedIndex == 0
                        ? 'You selected Monthly Plan'
                        : 'You selected Yearly Plan',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: SColor.primary.withOpacity(0.1),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  selectedIndex == -1 ? Colors.grey : SColor.primary,
                  padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Subscribe Now',
                  style: STextTheme.headLine()
                      .copyWith(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            SizedBox(height: DynamicSize.small(context)),

            // 🔹 Terms & Conditions
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
      ),
    );
  }
}
