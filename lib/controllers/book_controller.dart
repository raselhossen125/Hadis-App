import 'package:api_learn/models/book_model.dart';
import 'package:api_learn/services/api_service.dart';
import 'package:get/get.dart';

class BookController extends GetxController {
  static BookController get to => Get.find();

  /// Book List Loading
  RxBool bookListLoading = false.obs;

  /// Book List
  RxList<BookModel> bookList = <BookModel>[].obs;

  @override
  onReady() async {
    await getAllBookList();
    super.onReady();
  }

  /// Get All Book List
  Future<void> getAllBookList() async {
    bookListLoading(true);
    final info = await ServiceAPI.getAllBookList();
    bookList.value = info;
    bookListLoading(false);
  }
}
