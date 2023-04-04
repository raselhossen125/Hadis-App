import 'package:api_learn/models/hadis_model.dart';
import 'package:api_learn/services/api_service.dart';
import 'package:get/get.dart';

class HadisController extends GetxController {
  static HadisController get to => Get.find();

  /// hadis List Loading
  RxBool hadisListLoading = false.obs;

  /// hadis List
  RxList<HadisModel> hadisList = <HadisModel>[].obs;

  /// Get All hadis List
  Future<void> getAllhadisList({bool isPaginate = false}) async {
    hadisListLoading(true);
    final info = await ServiceAPI.getAllHadisList(isPaginate: isPaginate);
    hadisList.value = info;
    hadisListLoading(false);
  }
}
