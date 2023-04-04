import 'package:api_learn/route/my_app_routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpalashScreen extends StatelessWidget {
  const SpalashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(MyAppRoutesName.bookListcreen);
    });
    return const Scaffold(
      body: Center(
        child: Text('Hadis'),
      ),
    );
  }
}
