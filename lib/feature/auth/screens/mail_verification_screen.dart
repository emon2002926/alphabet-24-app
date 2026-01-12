import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/const/string_const/image_path.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/feature/auth/controllers/forget_password_controller.dart';

import '../../../core/theme/text_theme.dart';
import '../widgets/s_full_btn.dart';
import '../../../core/universal_widgets/s_text_field.dart';

class MailVerificationScreen extends StatelessWidget {
  const MailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordController controller = Get.put(ForgetPasswordController());
    final TextEditingController emailController = TextEditingController();

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
                'Forget Password',
                style: STextTheme.headLineBold().copyWith(fontSize: 24),
              ),
              SizedBox(
                height: DynamicSize.medium(context),
              ),

              // === Email Fields === //
              STextField(
                labelText: 'E-mail',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),


              SizedBox(height: DynamicSize.large(context)),

              // === Login Button === //
              Obx(
                () => SFullBtn(
                  text: controller.isLoading.value ? 'Sending...' : 'Send OTP',
                  onPressed: () {
                    controller.sendOTP(emailController.text.trim());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






