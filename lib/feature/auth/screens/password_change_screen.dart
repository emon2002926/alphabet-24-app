import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/core/const/size_const/dynamic_size.dart';
    import 'package:scaffassistant/core/theme/SColor.dart';
    import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:scaffassistant/feature/auth/controllers/change_password_controller.dart';

import '../../../core/universal_widgets/appbar.dart';
import '../../../core/universal_widgets/s_text_field.dart';

    class PasswordChangeScreen extends StatelessWidget {
      const PasswordChangeScreen({super.key});

      @override
      Widget build(BuildContext context) {

        final TextEditingController oldPasswordController = TextEditingController();
        final TextEditingController newPasswordController = TextEditingController();
        final TextEditingController confirmNewPasswordController = TextEditingController();
        final ChangePasswordController controller = ChangePasswordController();

        return Scaffold(
          appBar: SAppBar(
            title: 'Change Password',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: DynamicSize.large(context)),



                  Text(
                    'Enter your old password',
                    style: STextTheme.headLineBold(),
                  ),
                  SizedBox(height: DynamicSize.small(context)),
                  STextField(
                    labelText: 'Old Password',
                    hintText: 'Enter your old password',
                    obscureText: true,
                    controller: oldPasswordController,
                    suffixIcon: Icon(Icons.visibility_off, color: SColor.borderColor),
                    changedSuffixIcon: Icon(Icons.visibility, color: SColor.textPrimary),
                  ),
                  SizedBox(height: DynamicSize.medium(context)),


                  Text(
                    'Enter New Password',
                    style: STextTheme.headLineBold(),
                  ),
                  SizedBox(height: DynamicSize.small(context)),
                  STextField(
                    labelText: 'New Password',
                    hintText: 'Enter your new password',
                    obscureText: true,
                    controller: newPasswordController,
                    suffixIcon: Icon(Icons.visibility_off, color: SColor.borderColor),
                    changedSuffixIcon: Icon(Icons.visibility, color: SColor.textPrimary),
                  ),
                  SizedBox(height: DynamicSize.medium(context)),


                  Text(
                    'Re-Enter New Password',
                    style: STextTheme.headLineBold(),
                  ),
                  SizedBox(height: DynamicSize.small(context)),
                  STextField(
                    labelText: 'Re-Enter Password',
                    hintText: 'Re-Enter your new password',
                    obscureText: true,
                    controller: confirmNewPasswordController,
                    suffixIcon: Icon(Icons.visibility_off, color: SColor.borderColor),
                    changedSuffixIcon: Icon(Icons.visibility, color: SColor.textPrimary),
                  ),
                  SizedBox(height: DynamicSize.large(context)*2),
                  Obx(
                      (){
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SColor.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              controller.changePassword(
                                oldPasswordController.text,
                                newPasswordController.text,
                                confirmNewPasswordController.text,
                              );
                            },
                            child: controller.isLoading.value ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(SColor.primary),
                            ) : Text(
                              'Change Password',
                              style: STextTheme.headLineBold()
                                  .copyWith(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        );
                      }
                  )
                ],
              ),
            ),
          ),
        );
      }
    }

