import 'package:api_learn/controllers/chapter_controller.dart';
import 'package:api_learn/models/book_model.dart';
import 'package:api_learn/route/my_app_routes_name.dart';
import 'package:api_learn/utils/color/my_app_color.dart';
import 'package:api_learn/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookItem extends StatelessWidget {
  const BookItem({
    super.key,
    required this.bookM,
  });

  final BookModel bookM;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          Get.put(ChapterController());
          ChapterController.to.selectedBookName.value = bookM.bookName!;
          Get.toNamed(MyAppRoutesName.chapterListcreen);
          ChapterController.to.getAllchapterList(bookSlug: bookM.bookSlug!);
        },
        child: Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1,
              color: const Color(0xff007C4A),
            ),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                width: 67,
                height: 72,
                decoration: const BoxDecoration(
                  color: MyAppColor.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'images/image/book.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Book Name : ${bookM.bookName!}',
                        style: const TextStyle(
                          color: MyAppColor.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      space1C,
                      Text(
                        'Writer Name : ${bookM.writerName!}',
                        style: const TextStyle(
                          color: MyAppColor.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      space1C,
                      Text(
                        'Total Hadis : ${bookM.hadithsCount!}',
                        style: const TextStyle(
                          color: MyAppColor.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
