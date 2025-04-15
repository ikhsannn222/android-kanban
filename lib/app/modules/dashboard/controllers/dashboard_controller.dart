import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:p5_kanban/app/data/project_response.dart';
import 'package:p5_kanban/app/modules/dashboard/views/beranda_1_view.dart';
import 'package:p5_kanban/app/modules/dashboard/views/board_view.dart';
import 'package:p5_kanban/app/modules/dashboard/views/profile_view.dart';
import 'package:p5_kanban/app/utils/api.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  var isLoading = false.obs;
  // final kanbanResponse = Rxn<KanbanResponse>();
  // final profileResponse = Rxn<ProfileResponse>();
  final projectResponse = Rxn<ProjectResponse>();
  
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    BerandaView(),
    BoardView(),
    ProfileView(),
  ];

  final _getConnect = GetConnect();
  final token = GetStorage().read('token');
// print("📌 Token di DashboardController: $token");

    void getProjects() async {
    isLoading.value = true;

    try {
      if (token == null) {
        Get.snackbar("Error", "Token tidak ditemukan!");
        return;
      }

      final response = await _getConnect.get(
        BaseUrl.project,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        projectResponse.value = ProjectResponse.fromJson(response.body);
      } else {
        Get.snackbar("Error", "Gagal mengambil data: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

//  Future<ProfileResponse?> getProfile() async {
//   try {
//     final response = await _getConnect.get(
//       BaseUrl.profile,
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.status.hasError) {
//       return Future.error(response.statusText ?? "Gagal mengambil profil");
//     }

//     if (response.body != null) {
//       final result = ProfileResponse.fromJson(response.body);
//       profileResponse.value = result;
//       return result;
//     }

//     return null;
//   } catch (e) {
//     return Future.error("Terjadi kesalahan: $e");
//   }
// }


  @override
  void onInit() {
    super.onInit();
    getProjects();
    // getProfile();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}