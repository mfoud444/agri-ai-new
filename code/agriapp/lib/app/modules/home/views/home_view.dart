import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agri_ai/app/modules/home/views/screen/home_screen.dart';
import '../controllers/home_controller.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
 @override
  Widget build(BuildContext context) {
    return   AppHomeScreen();
  }

}
