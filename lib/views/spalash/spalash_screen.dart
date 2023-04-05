import 'package:api_learn/route/my_app_routes_name.dart';
import 'package:api_learn/utils/color/my_app_color.dart';
import 'package:api_learn/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpalashScreen extends StatelessWidget {
  const SpalashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(MyAppRoutesName.bookListcreen);
    });
    return Scaffold(
        backgroundColor: MyAppColor.primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/image/book.png', height: 150),
              const Text(
                'HADIS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ));
  }
}
