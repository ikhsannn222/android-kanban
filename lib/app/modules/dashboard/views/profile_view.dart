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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: FutureBuilder<ProfileResponse>(
        future: controller.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset('assets/lottie/profile.json', width: 150),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('Failed to load profile 😢'),
            );
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildAvatar(data),
                  const SizedBox(height: 30),
                  _buildProfileCard(
                    icon: Icons.person,
                    title: data.name ?? 'No Name',
                  ),
                  const SizedBox(height: 10),
                  _buildProfileCard(
                    icon: Icons.badge,
                    title: data.nrp ?? 'No NRP',
                  ),
                  const SizedBox(height: 10),
                  _buildProfileCard(
                    icon: Icons.email,
                    title: data.email ?? 'No Email',
                  ),
                  const SizedBox(height: 10),
                  _buildProfileCard(
                    icon: Icons.business,
                    title: data.departementId != null ? "Department Name" : "Not Available",
                  ),
                  const SizedBox(height: 10),
                  _buildProfileCard(
                    icon: Icons.work,
                    title: data.jabatanId != null ? "Jabatan Name" : "Not Available",
                  ),
                  const SizedBox(height: 10),
                  _buildProfileCard(
                    icon: Icons.group,
                    title: data.bagianId != null ? "Bagian Name" : "Not Available",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(ProfileResponse data) {
    final avatarUrl = data.avatar;
    if (avatarUrl != null && avatarUrl.isNotEmpty && (avatarUrl.startsWith('http') || avatarUrl.startsWith('https'))) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(avatarUrl),
        backgroundColor: Colors.grey.shade200,
      );
    } else {
      String initials = '';
      if (data.name != null && data.name!.isNotEmpty) {
        initials = data.name![0].toUpperCase();
      }
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.blue.shade300,
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  Widget _buildProfileCard({required IconData icon, required String title}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, size: 48, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                "Logout",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Yakin mau logout bro?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.logout();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
