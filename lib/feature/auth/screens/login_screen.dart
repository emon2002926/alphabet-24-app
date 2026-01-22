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

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: DynamicSize.horizontalLarge(context),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // 🔑 important
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // === Logo (centered) ===
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            ImagePath.logo,
                            width: 200,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // === Title ===
                        Text(
                          'Sign In',
                          style: STextTheme.headLineBold()
                              .copyWith(fontSize: 24),
                        ),

                        SizedBox(height: DynamicSize.medium(context)),

                        // === Email ===
                        STextField(
                          labelText: 'E-mail',
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          controller: loginController.emailController,
                        ),

                        SizedBox(height: DynamicSize.medium(context)),

                        // === Password ===
                        STextField(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          obscureText: true,
                          controller: loginController.passwordController,
                          suffixIcon: Icon(
                            Icons.visibility_off,
                            color: SColor.borderColor,
                          ),
                          changedSuffixIcon: Icon(
                            Icons.visibility,
                            color: SColor.textPrimary,
                          ),
                        ),

                        SizedBox(height: DynamicSize.small(context)),

                        // === Forgot Password ===
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed(RouteNames.mailVerification);
                            },
                            child: Text(
                              'Forgot password?',
                              style: STextTheme.headLineBold()
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                        ),

                        SizedBox(height: DynamicSize.medium(context)),

                        // === Login Button ===
                        Obx(
                              () => SFullBtn(
                            text: loginController.isLoading.value
                                ? 'Signing In...'
                                : 'Sign In',
                            onPressed: loginController.login,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // === Bottom Sheet ===
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          bottom: DynamicSize.large(context),
        ),
        color: SColor.bodyColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account? ',
              style: STextTheme.headLineBold().copyWith(fontSize: 12),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(RouteNames.signup),
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

