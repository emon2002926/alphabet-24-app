import 'package:flutter/material.dart';
import 'package:scaffassistant/core/const/string_const/image_path.dart';
    import 'package:scaffassistant/core/theme/SColor.dart';
    import 'package:scaffassistant/core/theme/text_theme.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/feature/settings/controllers/account_controller.dart';

import '../../../core/universal_widgets/appbar.dart';
import '../../../core/universal_widgets/s_text_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountController controller = Get.put(AccountController());
  bool isEnabled = false;

  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SAppBar(title: "Profile"),
      body: Obx(() {
        if (controller.isLoading.value && controller.account.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.account.value;

        if (user != null) {
          nameController.text = user.fullName;
          phoneController.text = user.phoneNumber;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Image
              GestureDetector(
                onTap: () {
                  if (isEnabled) controller.pickImage();
                },
                child: Obx(() {
                  ImageProvider imageProvider;

                  // If user picked a new image (local file)
                  if (controller.picture.value != null) {
                    imageProvider = FileImage(controller.picture.value!);

                    // If API returned a profile picture URL
                  } else if (user?.profilePictureUrl != null &&
                      user!.profilePictureUrl.isNotEmpty) {
                    imageProvider = NetworkImage(user.profilePictureUrl);

                    // Otherwise fallback to default avatar
                  } else {
                    imageProvider = AssetImage(ImagePath.avater);
                  }

                  return CircleAvatar(
                    radius: 45,
                    backgroundImage: imageProvider,
                  );
                })

              ),

              SizedBox(height: 10),

              Text(
                user?.fullName ?? "",
                style: STextTheme.headLine().copyWith(fontSize: 20),
              ),

              Text(
                user?.isPremium == true ? "Premium User" : "Free User",
                style: STextTheme.subHeadLine(),
              ),

              SizedBox(height: 30),

              Align(
                alignment: Alignment.centerLeft,
                child: Text("Full Name", style: STextTheme.headLine()),
              ),
              STextField(
                isEnabled: isEnabled,
                controller: nameController,
                hintText: "Enter your full name",
              ),

              SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text("Phone", style: STextTheme.headLine()),
              ),
              STextField(
                isEnabled: isEnabled,
                controller: phoneController,
                hintText: "Enter your phone number",
              ),

              SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (isEnabled) {
                      controller.updateAccount(
                        nameController.text,
                        phoneController.text,
                      );
                    }
                    setState(() {
                      isEnabled = !isEnabled;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: controller.isLoading.value ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ) : Text(
        isEnabled ? "Save Changes" : "Edit Profile",
        style: STextTheme.headLine()
            .copyWith(color: Colors.white, fontSize: 18),
        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}



