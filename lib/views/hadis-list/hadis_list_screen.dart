import 'package:api_learn/controllers/chapter_controller.dart';
import 'package:api_learn/controllers/hadis_controller.dart';
import 'package:api_learn/utils/color/my_app_color.dart';
import 'package:api_learn/utils/widgets/hadis-item/hadis_item.dart';
import 'package:api_learn/utils/widgets/loading/loading.dart';
import 'package:api_learn/utils/widgets/my-app-bar/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HadisListScreen extends StatelessWidget {
  const HadisListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColor.bgColor,
      appBar: MyAppBar(
        title: ChapterController.to.selectedChapterName.value,
        isBack: true,
        centerTitle: true,
      ),
      body: Obx(
        () => HadisController.to.hadisListLoading.value
            ? const Center(
                child: Loading(),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(top: 12, bottom: 4),
                itemCount: HadisController.to.hadisList.length,
                itemBuilder: (context, index) {
                  final info = HadisController.to.hadisList[index];
                  return HadisItem(hadisM: info);
                },
              ),
      ),
    );
  }
}
