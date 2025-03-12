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
          middleText: "Apakah Anda yakin ingin logout?",
          textConfirm: "Ya",
          textCancel: "Tidak",
          confirmTextColor: Colors.white,
          onConfirm: () {
            controller.logout();
            Get.back();
          },
          onCancel: Get.back,
          
          // Ganti styling teks title dan middleText
          titleStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue, // Warna untuk title
          ),
          middleTextStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey[700], // Warna untuk middle text
          ),

          // Tambahkan widget kustom untuk button konfirmasi dan cancel
          buttonColor: Colors.green, // Warna button
          radius: 15.0, // Radius border dialog
          backgroundColor: Colors.white, // Warna latar belakang dialog
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning, color: Colors.red, size: 50), // Icon kustom
              SizedBox(height: 10),
              Text(
                "Peringatan: Anda akan keluar dari aplikasi",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
                  child: Lottie.network(
                    'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                    repeat: true,
                    width: MediaQuery.of(context).size.width / 1,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("Loading animation failed");
                    },
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

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (data.avatar != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(data.avatar!),
                      radius: 50,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    "${data.name}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(" ${data.email}"),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}