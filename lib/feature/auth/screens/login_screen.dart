import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/const/string_const/image_path.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/feature/auth/controllers/login_controller.dart';

import '../../../core/theme/text_theme.dart';
import '../../../routing/route_name.dart';
import '../widgets/s_full_btn.dart';
import '../../../core/universal_widgets/s_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginController loginController = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {

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
                'Sign In',
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
                controller: loginController.emailController,
              ),
              SizedBox(height: DynamicSize.medium(context)),

              // === Password Fields === //
              STextField(
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                controller: loginController.passwordController,
                suffixIcon: Icon(Icons.visibility_off, color: SColor.borderColor),
                changedSuffixIcon: Icon(Icons.visibility, color: SColor.textPrimary),
              ),

              SizedBox(height: DynamicSize.small(context)),

              // === Forgot Password === //
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(RouteNames.mailVerification);
                  },
                  child: Text(
                    'Forgot password?',
                    style: STextTheme.headLineBold().copyWith(fontSize: 14),
                  ),
                ),
              ),

              SizedBox(height: DynamicSize.small(context)),

              // === Login Button === //
              Obx(()=>SFullBtn(
                text: loginController.isLoading.value ? 'Signing In...' : 'Sign In',
                onPressed: () {
                  loginController.login();
                },
              )
              ),

            ],
          ),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: DynamicSize.large(context)),
        decoration: BoxDecoration(
          color: SColor.bodyColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account? ',
              style: STextTheme.headLineBold().copyWith(fontSize: 12),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteNames.signup);
              },
              child: Text(
                'Sign Up',
                style: STextTheme.headLineBold().copyWith(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






