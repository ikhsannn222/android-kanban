import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kanban_controller.dart';

class KanbanView extends GetView<KanbanController> {
  const KanbanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KanbanController());
    final int projectId = Get.arguments;

    // Mengambil task setelah frame pertama dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getTask(projectId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Project #$projectId'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = controller.kanbanResponse.value?.tasks ?? [];

        if (tasks.isEmpty) {
          return const Center(child: Text("Tidak ada task untuk project ini"));
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(task.name ?? 'No Task Name'),
                subtitle: Text(
                  'Status: ${task.status?.name?.isNotEmpty == true ? task.status?.name : 'Unknown'}',
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
