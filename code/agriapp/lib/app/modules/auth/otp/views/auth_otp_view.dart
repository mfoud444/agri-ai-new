import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_otp_controller.dart';

class AuthOtpView extends GetView<AuthOtpController> {
  const AuthOtpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthOtpView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AuthOtpView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
