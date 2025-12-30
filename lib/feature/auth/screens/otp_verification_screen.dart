import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/const/string_const/image_path.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/feature/auth/controllers/forget_password_controller.dart';
import 'package:scaffassistant/feature/auth/controllers/signup_controller.dart';

import '../../../core/theme/text_theme.dart';
import '../widgets/s_full_btn.dart';
import '../../../core/universal_widgets/s_text_field.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.put(SignupController());
    final Map<String, dynamic> args = Get.arguments ?? {};
    final TextEditingController otpController = TextEditingController();

    final ForgetPasswordController forgetPasswordController = Get.put(ForgetPasswordController());


    final String email = args['email'] ?? '';
    final bool isSignup = args['isSignup'] ?? true;

    return Scaffold(
      backgroundColor: SColor.bodyColor,

      // === App Bar === //
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 200),
        child: AppBar(
          backgroundColor: SColor.bodyColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Align(
            alignment: Alignment.center,
            child: Image(image: AssetImage(ImagePath.logo), width: 200),
          ),
          toolbarHeight: 200,
        ),
      ),

      // === Body === //
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: DynamicSize.horizontalLarge(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Login Form === //
              Text(
                'Enter OTP',
                style: STextTheme.headLine().copyWith(fontSize: 24),
              ),
              SizedBox(
                height: DynamicSize.medium(context),
              ),

              // === Email Fields === //
              STextField(
                labelText: 'OTP',
                hintText: 'Enter your OTP',
                controller: otpController,
                keyboardType: TextInputType.number,
              ),


              SizedBox(height: DynamicSize.large(context)),

              // === Login Button === //
              Obx(
                  ()=>SFullBtn(
                    text: signupController.isLoading.value ? 'Verifying...' : 'Verify',
                    onPressed: () {
                      if(isSignup == true){
                        if (!signupController.isLoading.value) {
                          signupController.registerOTPVerification(
                            otpController.text.trim(),
                            email,
                          );
                        }
                      } else {
                        forgetPasswordController.verifyOTP(email, otpController.text.trim());
                      }
                    }
                  )
              ),
              SizedBox(height: DynamicSize.large(context)),

              RichText(
                text: TextSpan(
                  text: "We sent a verification code to your email. Please check.If not, resend in 0:22 minutes. ",
                  style: STextTheme.subHeadLine(),
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: GestureDetector(
                        onTap: () {
                          // Resend OTP action
                        },
                        child: Text(
                          "Resend",
                          style: STextTheme.subHeadLine().copyWith(
                            color: SColor.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}






