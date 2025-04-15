import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:p5_kanban/app/modules/dashboard/controllers/dashboard_controller.dart';

class BerandaView extends StatelessWidget {
  const BerandaView({super.key});

  String _getCurrentTime() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Beranda',
          style: TextStyle(color: Color(0xFF1E293B)),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final projects = controller.projectResponse.value?.projects ?? [];

        final totalProjects = projects.length;
        final projectsSelesai = projects.where((project) => project.statusId == 3).length;
        final projectsBelumSelesai = totalProjects - projectsSelesai;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _greetingCard(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      title: "Belum Selesai",
                      value: "$projectsBelumSelesai",
                      icon: Icons.schedule,
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 8, 243, 255),
                          Color.fromARGB(255, 11, 178, 186)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _statCard(
                      title: "Selesai",
                      value: "$projectsSelesai",
                      icon: Icons.check_circle,
                      gradient: const LinearGradient(
                        colors: [Color.fromARGB(255, 9, 234, 114), Color(0xFF22D3EE)],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _statCard(
                title: "Total Project",
                value: "$totalProjects",
                icon: Icons.assignment,
                gradient: const LinearGradient(
                  colors: [Color(0xFF818CF8), Color(0xFFEC4899)],
                ),
                isFull: true,
              ),
              const SizedBox(height: 32),
              _tipsCard(),
            ],
          ),
        );
      }),
    );
  }

  Widget _greetingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF60A5FA), Color(0xFF6366F1)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "👋 Hai!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              final time = DateFormat('HH:mm:ss').format(DateTime.now());
              return Text(
                "Jam: $time",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            "Selamat datang kembali di Intra-Sub. Yuk, kelola proyekmu hari ini!",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Gradient gradient,
    bool isFull = false,
  }) {
    return Container(
      margin: isFull ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget _tipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.lightbulb, color: Color(0xFFFACC15)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Tips: Gunakan fitur drag & drop di board untuk memindahkan tugas antar kolom dengan mudah dan efisien.",
              style: TextStyle(fontSize: 15, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }
}
