import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:scaffassistant/core/const/string_const/API_endpoint.dart';
import 'package:scaffassistant/core/local_storage/user_info.dart';
import 'package:scaffassistant/core/universal_widgets/s_snackbar.dart';
import 'package:scaffassistant/feature/settings/models/account_model.dart';

class AccountController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isEditing = false.obs;
  Rx<AccountModel?> account = Rx<AccountModel?>(null);

  /// picked image holder
  final Rx<File?> picture = Rx<File?>(null);

  @override
  void onInit() {
    fetchAccount();
    super.onInit();
  }

  //======================================
  //      FETCH ACCOUNT API
  //======================================
  Future<void> fetchAccount() async {
    try {
      isLoading.value = true;

      final token = UserInfo.getAccessToken();

      final response = await http.get(
        Uri.parse('${APIEndpoint.baseURL}authentication/profile/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Fetch Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        final data = decode["data"];
        account.value = AccountModel.fromJson(data);
      } else {
        print("Fetch Failed: ${response.body}");
      }
    } catch (e) {
      print("Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //======================================
  //        IMAGE PICKER
  //======================================
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      picture.value = File(image.path);
      print("Image Selected: ${image.path}");
    }
  }

  //======================================
  //        UPDATE ACCOUNT API
  //======================================
  Future<void> updateAccount(String fullName, String phoneNumber) async {
    try {
      isLoading.value = true;

      final token = UserInfo.getAccessToken();

      var request = http.MultipartRequest(
        "PUT",
        Uri.parse('${APIEndpoint.baseURL}authentication/profile/'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Text fields
      request.fields['full_name'] = fullName;
      request.fields['phone_number'] = phoneNumber;

      // Attach image only if selected
      if (picture.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_picture',
            picture.value!.path,
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("Update Status: ${response.statusCode}");
      print("Update Response: $responseBody");

      if (response.statusCode == 200) {
        fetchAccount(); // refresh profile
        picture.value = null; // clear selected image
        SSnackbar.success("Profile updated successfully.");
      }else if(response.statusCode == 413 || response.statusCode == 400){
        SSnackbar.info("Image size is too large or invalid data provided.");
      } else {
        print("Update Failed: $responseBody");
      }
    } catch (e) {
      print("Update Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
