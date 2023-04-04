import 'package:api_learn/views/book-list/book_list_screen.dart';
import 'package:api_learn/views/chapter-list/chapter_list_screen.dart';
import 'package:api_learn/views/hadis-list/hadis_list_screen.dart';
import 'package:api_learn/views/spalash/spalash_screen.dart';
import 'package:get/get.dart';
import 'my_app_routes_name.dart';

class MyAppRoutes {
  static appRoute() => [
        GetPage(
          name: MyAppRoutesName.spalashScreen,
          page: () => const SpalashScreen(),
        ),
        GetPage(
          name: MyAppRoutesName.bookListcreen,
          page: () => const BookListScreen(),
        ),
        GetPage(
          name: MyAppRoutesName.chapterListcreen,
          page: () => const ChapterListScreen(),
        ),
        GetPage(
          name: MyAppRoutesName.hadisListcreen,
          page: () => const HadisListScreen(),
        ),
      ];
}
