import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/error_launch_controller.dart';

class ErrorLaunchView extends GetView<ErrorLaunchController> {
  const ErrorLaunchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add image at the top
            Image.asset(
              'assets/images/error_connection.png', 
              width: 200, // Adjust size as needed
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 40), 
            const Text(
              'An error occurred!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Obx(() => GestureDetector(
                  onTap: controller.isLoading.value
                      ? null
                      : () => controller.handleError(),
                  child: Container(
                    height: 58,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 56.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(38.0),
                      color: controller.isLoading.value
                          ? Colors.grey
                          : const Color(0xff132137),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            "Retry",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
