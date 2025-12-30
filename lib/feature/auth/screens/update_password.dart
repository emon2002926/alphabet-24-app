import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
import 'package:scaffassistant/core/const/string_const/image_path.dart';
import 'package:scaffassistant/core/theme/SColor.dart';
import 'package:scaffassistant/feature/auth/controllers/forget_password_controller.dart';

import '../../../core/theme/text_theme.dart';
import '../widgets/s_full_btn.dart';
import '../../../core/universal_widgets/s_text_field.dart';

class UpdatePassword extends StatelessWidget {
  String token = '';
   UpdatePassword({super.key, required this.token});

  @override
  Widget build(BuildContext context) {

    final ForgetPasswordController controller = Get.put(ForgetPasswordController());
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmNewPasswordController = TextEditingController();


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
                'Reset Your Password  ',
                style: STextTheme.headLine().copyWith(fontSize: 24),
              ),
              SizedBox(
                height: DynamicSize.medium(context),
              ),

              // === Email Fields === //
              STextField(
                labelText: 'Password',
                hintText: 'Enter your new password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: newPasswordController,
                suffixIcon: Icon(Icons.visibility_off, color: SColor.borderColor),
                changedSuffixIcon: Icon(Icons.visibility, color: SColor.textPrimary)
              ),


              SizedBox(
                height: DynamicSize.medium(context),
              ),

              // === Email Fields === //
              STextField(
                labelText: 'Re-Type Password',
                hintText: 'Re-Enter your new password',
                keyboardType: TextInputType.visiblePassword,
                controller: confirmNewPasswordController,
                suffixIcon: Icon(Icons.visibility_off, color: SColor.borderColor),
                changedSuffixIcon: Icon(Icons.visibility, color: SColor.textPrimary),
                obscureText: true,
              ),


              SizedBox(height: DynamicSize.large(context)),

              // === Login Button === //
              Obx(
                ()=>SFullBtn(
                  text: controller.isLoading.value ? 'Updating...' : 'Update Password',
                  onPressed: () {
                    if (!controller.isLoading.value) {
                      controller.resetPassword(
                        token,
                        newPasswordController.text.trim(),
                        confirmNewPasswordController.text.trim(),
                      );
                    }
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






