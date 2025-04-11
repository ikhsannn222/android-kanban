import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:p5_kanban/app/data/profile_response.dart';
import 'package:p5_kanban/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.defaultDialog(
                title: "Konfirmasi",
                middleText: "Apakah anda ingin Logout ?",
                textConfirm: "Ya",
                textCancel: "Tidak",
                confirmTextColor: Colors.white,
                onConfirm: () {
                  controller.logout();
                  Get.back();
                },
                onCancel: () {
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<ProfileResponse>(
            future: controller.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      'assets/lottie/profile.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text("Failed to load profile"),
                );
              }

              final data = snapshot.data;

              if (data == null || data.email == null || data.email!.isEmpty) {
                return const Center(child: Text("No profile data available"));
              }

              // Assuming you have data for names (departmentName, jabatanName, etc.)
              final departmentName = data.departementId != null ? "Department Name" : "Not Available";  // Replace with real name data
              final jabatanName = data.jabatanId != null ? "Jabatan Name" : "Not Available"; // Replace with real name data
              final bagianName = data.bagianId != null ? "Bagian Name" : "Not Available"; // Replace with real name data

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (data.avatar != null)
                        CircleAvatar(
                          backgroundImage: NetworkImage(data.avatar!),
                          radius: 70, // Increase the size
                        ),
                      const SizedBox(height: 16),
                      Text(
                        "${data.name}",
                        style: const TextStyle(
                          fontSize: 24, // Larger font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Email: ${data.email}",
                        style: const TextStyle(
                          fontSize: 18, // Larger font size
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "NRP: ${data.nrp ?? 'Not Available'}",
                        style: const TextStyle(
                          fontSize: 18, // Larger font size
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Active: ${data.isActive == 1 ? 'Yes' : 'No'}",
                        style: const TextStyle(
                          fontSize: 18, // Larger font size
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Departemen: $departmentName",
                        style: const TextStyle(
                          fontSize: 18, // Larger font size
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Jabatan: $jabatanName",
                        style: const TextStyle(
                          fontSize: 18, // Larger font size
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Bagian: $bagianName",
                        style: const TextStyle(
                          fontSize: 18, // Larger font size
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
