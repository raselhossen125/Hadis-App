import 'package:api_learn/models/chapterModel.dart';
import 'package:api_learn/services/api_service.dart';
import 'package:get/get.dart';

class ChapterController extends GetxController {
  static ChapterController get to => Get.find();

  /// chapter List Loading
  RxBool chapterListLoading = false.obs;

  /// Selected Book Name
  RxString selectedBookName = ''.obs;

  /// chapter List
  RxList<ChapterModel> chapterList = <ChapterModel>[].obs;

  /// Get All chapter List
  Future<void> getAllchapterList({required String bookSlug}) async {
    chapterListLoading(true);
    final info = await ServiceAPI.getAllChapterList(bookSlug: bookSlug);
    chapterList.value = info;
    chapterListLoading(false);
  }
}
