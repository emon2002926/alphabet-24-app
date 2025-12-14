import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/const/string_const/image_path.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/feature/auth/controllers/signup_controller.dart';
import '../../../core/theme/text_theme.dart';
import '../../../routing/route_name.dart';
import '../widgets/s_full_btn.dart';
import '../../../core/universal_widgets/s_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final SignupController signupController = Get.put(SignupController());

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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: DynamicSize.horizontalLarge(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Login Form === //
              Text(
                'Sign Up',
                style: STextTheme.headLine().copyWith(fontSize: 24),
              ),
              SizedBox(
                height: DynamicSize.medium(context),
              ),

              // === Email Fields === //
              STextField(
                labelText: 'E-mail',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                controller: signupController.email,
              ),
              SizedBox(height: DynamicSize.medium(context)),

              // === Password Fields === //
              STextField(
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                controller: signupController.password,
                suffixIcon: Icon(Icons.visibility_off, color: SColor.borderColor),
                changedSuffixIcon: Icon(Icons.visibility, color: SColor.textPrimary),
              ),
              SizedBox(height: DynamicSize.medium(context)),

              // === Password Fields === //
              STextField(
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                controller: signupController.confirmPassword,
                suffixIcon: Icon(Icons.visibility_off, color: SColor.borderColor),
                changedSuffixIcon: Icon(Icons.visibility, color: SColor.textPrimary),
              ),



              SizedBox(height: DynamicSize.large(context)),

              // === Login Button === //
              Obx(
                  ()=>SFullBtn(
                    text: signupController.isLoading.value ? 'Signing Up...' : 'Sign Up',
                    onPressed: () {
                      if (!signupController.isLoading.value) {
                        signupController.signUp();
                      }
                    },
                  )
              ),
              SizedBox(height: DynamicSize.small(context)),

              // === Forgot Password === //
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'By clicking the “sign up” button, you accept the terms of the Privacy Policy.',
                  style: STextTheme.headLine().copyWith(fontSize: 12),
                ),
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
              'Already have an account? ',
              style: STextTheme.headLine().copyWith(fontSize: 12),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteNames.login);
              },
              child: Text(
                'Sign In',
                style: STextTheme.headLine().copyWith(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






