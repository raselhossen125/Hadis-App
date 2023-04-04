// ignore_for_file: prefer_const_constructors

import 'package:api_learn/controllers/book_controller.dart';
import 'package:api_learn/utils/color/my_app_color.dart';
import 'package:api_learn/utils/widgets/book-item/book_item.dart';
import 'package:api_learn/utils/widgets/loading/loading.dart';
import 'package:api_learn/utils/widgets/my-app-bar/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BookController());
    return Scaffold(
      backgroundColor: MyAppColor.bgColor,
      appBar: MyAppBar(
        title: 'Book List',
        isBack: false,
        centerTitle: true,
      ),
      body: Obx(
        () => BookController.to.bookListLoading.value
            ? Center(
                child: Loading(),
              )
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(top: 12, bottom: 4),
                itemCount: BookController.to.bookList.length,
                itemBuilder: (context, index) {
                  final info = BookController.to.bookList[index];
                  return BookItem(bookM: info);
                },
              ),
      ),
    );
  }
}
