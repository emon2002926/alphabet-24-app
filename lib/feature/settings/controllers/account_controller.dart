import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import 'package:scaffassistant/core/universal_widgets/s_snackbar.dart';

import '../../../core/user_controller.dart';

class AccountController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<File?> picture = Rx<File?>(null);
  final RxBool isEditEnabled = true.obs;

  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
  }

  Future<void> updateAccount(String fullName, String phoneNumber) async {
    try {
      isLoading.value = true;

      final token = UserInfo.getAccessToken();

      if (token == null || token.isEmpty) {
        SSnackbar.error('No access token found',
        );
        isLoading.value = false;
        return;
      }

      // Create multipart request for POST with form-data
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(APIEndpoint.userInfo),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add fields
      request.fields['full_name'] = fullName;
      request.fields['phone_number'] = phoneNumber;

      // Add profile picture if selected
      if (picture.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_picture',
            picture.value!.path,
          ),
        );
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        SSnackbar.success(
           jsonResponse['message'] ?? 'Profile updated successfully',
        );

        // Clear selected picture
        picture.value = null;

        // Disable edit mode
        isEditEnabled.value = false;
      } else if (response.statusCode == 401) {
        SSnackbar.error(
         'Unauthorized: Invalid or expired token',
        );
      } else {
        try {
          final jsonResponse = json.decode(response.body);
          SSnackbar.error(
             jsonResponse['message'] ?? 'Failed to update profile',
          );
        } catch (e) {
          SSnackbar.error(
           'Failed to update profile: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      SSnackbar.error(
       'An error occurred: $e',

      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        picture.value = File(image.path);
      }
    } catch (e) {
      SSnackbar.error(
'Failed to pick image: $e',
      );
    }
  }

  void toggleEditMode() {
    if (isEditEnabled.value) {
      // Canceling edit - restore original values from UserController
      final userController = Get.find<UserController>();
      final user = userController.userProfile.value;

      if (user != null) {
        nameController.text = user.fullName;
        phoneController.text = user.phoneNumber;
      }
      picture.value = null;
    }
    isEditEnabled.value = !isEditEnabled.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}