import 'package:agri_ai/config/translations/strings_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.profile.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                TextField(
                  controller: controller.firstNameC,
                  decoration: InputDecoration(
                    labelText: Strings.firstName.tr,
                    prefixIcon: const Icon(Icons.person),
                    errorText: controller.firstNameError.value,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: controller.lastNameC,
                  decoration: InputDecoration(
                    labelText: Strings.lastName.tr,
                    prefixIcon: const Icon(Icons.person),
                    errorText: controller.lastNameError.value,
                  ),
                ),
                SizedBox(height: 16.h),
                // TextField(
                //   controller: controller.dateOfBirthC,
                //   decoration: InputDecoration(
                //     labelText: Strings.dateOfBirth.tr,
                //     prefixIcon: Icon(Icons.calendar_today),
                //   ),
                //   readOnly: true,
                //   onTap: () => _selectDate(context),
                // ),
                // SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: Strings.gender.tr,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  value: controller.genderC.text.isEmpty
                      ? null
                      : controller.genderC.text,
                  items: ['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    controller.genderC.text = newValue ?? '';
                  },
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: controller.countryC,
                  decoration: InputDecoration(
                    labelText: Strings.country.tr,
                    prefixIcon: const Icon(Icons.public),
                  ),
                  readOnly: true,
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      onSelect: (Country country) {
                         controller.countryC.text = country.name;
                        // Save country code for the database
                        controller.selectedCountryCode = country.countryCode;
                      },
                    );
                  },
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.updateProfile(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, 
                 
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0), // Optional: Adjust padding
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors
                                .white, // Set the loading indicator color to white
                          ),
                        )
                      : Text(
                          Strings.updateProfile.tr,
                          style: const TextStyle(
                              color:
                                  Colors.white), // Ensure text color is white
                        ),
                ),
              ],
            )),
      ),
    );
  }

  void _updateProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.updateProfileImage(image.path);
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.dateOfBirthC.text = picked.toIso8601String().split('T')[0];
    }
  }
}
