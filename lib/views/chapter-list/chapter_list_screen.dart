import 'package:api_learn/controllers/book_controller.dart';
import 'package:api_learn/controllers/chapter_controller.dart';
import 'package:api_learn/utils/color/my_app_color.dart';
import 'package:api_learn/utils/widgets/chapter-item/chapter_item.dart';
import 'package:api_learn/utils/widgets/loading/loading.dart';
import 'package:api_learn/utils/widgets/my-app-bar/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChapterListScreen extends StatelessWidget {
  const ChapterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColor.bgColor,
      appBar: MyAppBar(
        title: BookController.to.selectedBookName.value,
        isBack: true,
        centerTitle: true,
      ),
      body: Obx(
        () => ChapterController.to.chapterListLoading.value
            ? const Center(
                child: Loading(),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(top: 12, bottom: 4),
                itemCount: ChapterController.to.chapterList.length,
                itemBuilder: (context, index) {
                  final info = ChapterController.to.chapterList[index];
                  return ChapterItem(chapterM: info);
                },
              ),
      ),
    );
  }
}
