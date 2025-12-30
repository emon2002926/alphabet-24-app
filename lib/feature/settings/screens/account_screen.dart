import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scaffassistant/core/const/string_const/image_path.dart';
import 'package:get/get.dart';
import 'package:scaffassistant/feature/settings/controllers/account_controller.dart';

import '../../../core/user_controller.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final AccountController controller = Get.put(AccountController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Show loading indicator while fetching user profile
        if (userController.isLoading.value && userController.userProfile.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = userController.userProfile.value;

        // Initialize text controllers with user data
        if (user != null && controller.nameController.text.isEmpty) {
          controller.nameController.text = user.fullName;
          controller.phoneController.text = user.phoneNumber;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (controller.isEditEnabled.value) {
                              controller.pickImage();
                            }
                          },
                          child: Obx(() {
                            ImageProvider imageProvider;

                            // Priority: 1. Newly picked image, 2. User's profile URL, 3. Default avatar
                            if (controller.picture.value != null) {
                              imageProvider = FileImage(controller.picture.value!);
                            } else if (user?.profilePictureUrl != null && user!.profilePictureUrl.isNotEmpty) {
                              imageProvider = NetworkImage(user.profilePictureUrl);
                            } else {
                              imageProvider = AssetImage(ImagePath.avater);
                            }

                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF00D9B5),
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: imageProvider,
                              ),
                            );
                          }),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              if (controller.isEditEnabled.value) {
                                controller.pickImage();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? const Color(0xFF1E1E1E)
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDarkMode
                                      ? const Color(0xFF2E2E2E)
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.fullName ?? "User Name",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.isPremium == true ? "Premium User" : "Free User",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Full Name Field
              Text(
                "Full Name",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF1E1E1E)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? const Color(0xFF2E2E2E)
                        : Colors.grey.shade300,
                  ),
                ),
                child: TextField(
                  controller: controller.nameController,
                  enabled: controller.isEditEnabled.value,
                  style: GoogleFonts.poppins(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Your User Name",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              )),

              const SizedBox(height: 20),

              // Email Address Field (if you add email to AccountModel)
              Text(
                "Email address",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? const Color(0xFF2E2E2E)
                        : Colors.grey.shade300,
                  ),
                ),
                child: TextField(
                  enabled: false,
                  style: GoogleFonts.poppins(
                    color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
                  decoration: InputDecoration(
                    hintText:  user?.email ?? "example@gmail.com",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Phone Field
              Text(
                "Phone",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF1E1E1E)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? const Color(0xFF2E2E2E)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    // Country Flag/Code
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "🇧🇩", // Bangladesh flag
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "+880",
                            style: GoogleFonts.poppins(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divider
                    Container(
                      width: 1,
                      height: 24,
                      color: isDarkMode
                          ? const Color(0xFF2E2E2E)
                          : Colors.grey.shade300,
                    ),
                    // Phone Input
                    Expanded(
                      child: TextField(
                        controller: controller.phoneController,
                        enabled: controller.isEditEnabled.value,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),

              const SizedBox(height: 40),

              // Edit/Save Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                    if (controller.isEditEnabled.value) {
                      // Save changes
                      await controller.updateAccount(
                        controller.nameController.text,
                        controller.phoneController.text,
                      );
                      // Refresh user profile after update
                      await userController.refreshProfile();
                    } else {
                      // Enable edit mode
                      controller.toggleEditMode();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? const Color(0xFF00D9B5)
                        : const Color(0xFF006B5A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: isDarkMode
                        ? const Color(0xFF00D9B5).withOpacity(0.5)
                        : const Color(0xFF006B5A).withOpacity(0.5),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    controller.isEditEnabled.value ? "Save Changes" : "Edit",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )),
            ],
          ),
        );
      }),
    );
  }
}

