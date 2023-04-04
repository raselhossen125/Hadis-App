import 'package:api_learn/controllers/hadis_controller.dart';
import 'package:api_learn/utils/color/my_app_color.dart';
import 'package:api_learn/utils/widgets/hadis-item/hadis_item.dart';
import 'package:api_learn/utils/widgets/loading/loading.dart';
import 'package:api_learn/utils/widgets/my-app-bar/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HadisListScreen extends StatefulWidget {
  const HadisListScreen({super.key});

  @override
  State<HadisListScreen> createState() => _HadisListScreenState();
}

class _HadisListScreenState extends State<HadisListScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (HadisController.to.hadisNextPageUrl.value.isNotEmpty &&
          HadisController.to.hadisListAddLoading.value == false) {
        await HadisController.to.getAllhadisList(isPaginate: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColor.bgColor,
      appBar: MyAppBar(
        title: 'Chapter ${HadisController.to.selectedChapterName.value}',
        isBack: true,
        centerTitle: true,
      ),
      body: Obx(
        () => HadisController.to.hadisListLoading.value
            ? const Center(
                child: Loading(),
              )
            : SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16)
                          .copyWith(top: 12, bottom: 4),
                      itemCount: HadisController.to.hadisList.length,
                      itemBuilder: (context, index) {
                        final info = HadisController.to.hadisList[index];
                        return HadisItem(hadisM: info);
                      },
                    ),
                    if (HadisController.to.hadisListAddLoading.value)
                      const Loading(
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      )
                  ],
                ),
              ),
      ),
    );
  }
}
