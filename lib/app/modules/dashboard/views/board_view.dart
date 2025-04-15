import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:p5_kanban/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:p5_kanban/app/modules/kanban/views/kanban_view.dart';

class BoardView extends GetView<DashboardController> {
  const BoardView({Key? key}) : super(key: key);

  // Function to remove HTML tags from text
  String stripHtmlTags(String? htmlString) {
    if (htmlString == null || htmlString.isEmpty) {
      return 'No Description';
    }
    // Remove HTML tags with a RegExp
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                controller.getProjects(), // Ganti ini sesuai method-mu
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Lottie.network(
                  'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                  repeat: true,
                  width: MediaQuery.of(context).size.width / 1,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text("Loading animation failed");
                  },
                ),
              ),
            );
          }

          final projects = controller.projectResponse.value?.projects;

          if (projects == null || projects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Tidak ada data project"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.getProjects(),
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: projects.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              final project = projects[index];

              return GestureDetector(
                onTap: () {
                  Get.to(() => const KanbanView(), arguments: project.id);
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stripHtmlTags(project.description) ?? 'No Description',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              label: Text("ID: ${project.id}"),
                              backgroundColor: Colors.blue.shade100,
                            ),
                            Text(
                              "Status: ${project.status?.name ?? 'Unknown'}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (project.owner != null)
                          Text(
                            "Owner: ${project.owner!.name ?? 'No Name'}",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
