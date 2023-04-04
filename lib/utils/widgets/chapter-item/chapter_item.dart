import 'package:api_learn/controllers/chapter_controller.dart';
import 'package:api_learn/controllers/hadis_controller.dart';
import 'package:api_learn/models/chapterModel.dart';
import 'package:api_learn/route/my_app_routes_name.dart';
import 'package:api_learn/utils/color/my_app_color.dart';
import 'package:api_learn/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChapterItem extends StatelessWidget {
  const ChapterItem({
    super.key,
    required this.chapterM,
  });

  final ChapterModel chapterM;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Get.put(HadisController());
          ChapterController.to.selectedChapterNumber.value =
              chapterM.chapterNumber!;
          ChapterController.to.selectedChapterName.value =
              chapterM.chapterEnglish!;
          Get.toNamed(MyAppRoutesName.hadisListcreen);
          HadisController.to.getAllhadisList();
        },
        child: Container(
          height: 65,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
              color: const Color(0xff007C4A),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Chapter Number : ${chapterM.chapterNumber}',
                  style: const TextStyle(
                    color: MyAppColor.primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                space1C,
                Text(
                  'Chapter Name : ${chapterM.chapterEnglish!}',
                  style: const TextStyle(
                    color: MyAppColor.primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
