import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:p5_kanban/app/data/kanban_response.dart';
import 'package:p5_kanban/app/modules/board/views/board_view.dart';
import 'package:p5_kanban/app/modules/profile/views/profile_view.dart';
import 'package:p5_kanban/app/utils/api.dart';


class DashboardController extends GetxController {
  //TODO: Implement DashboardController
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    BoardView(),
    ProfileView(),
  ];

  final _getConnect = GetConnect();

  final token = GetStorage().read('token');

  Future<KanbanResponse> getEvent() async {
    final response = await _getConnect.get(
      BaseUrl.task,
      headers: {'Authorization': 'Bearer $token'},
      contentType: 'application/json',
    );
    return KanbanResponse.fromJson(response.body);
  }

  // final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // void increment() => count.value++;
}