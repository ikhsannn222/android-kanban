import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p5_kanban/app/data/kanban_response.dart';
import '../controllers/kanban_controller.dart';

class KanbanView extends GetView<KanbanController> {
  const KanbanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KanbanController());

    // Ambil projectId dari argument
    final int projectId = Get.arguments;

    // Simpan projectId ke controller (jika ingin digunakan lebih lanjut)
    controller.currentProjectId.value = projectId;

    // Load data hanya setelah build pertama selesai
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getTaskStatuses();
      await controller.getTask(projectId); // ambil task berdasarkan projectId
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Kanban Board - Project $projectId'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = controller.kanbanResponse.value?.tasks ?? [];

        if (controller.taskStatuses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Filter task hanya dari project saat ini
        final projectTasks = tasks.where((t) => t.projectId == projectId).toList();
        final groupedTasks = controller.groupTasksByStatus(projectTasks);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.taskStatuses
                .where((status) => status.name?.toLowerCase() != 'archived')
                .map((status) {
              final taskList = groupedTasks[status.name] ?? [];
              return _buildStatusColumn(
                status.name ?? 'Unknown',
                taskList,
                controller,
                status,
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildStatusColumn(
    String statusName,
    List<Task> tasks,
    KanbanController controller,
    statusObj,
  ) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _hexToColor(statusObj.color ?? '#000000'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: MediaQuery.of(Get.context!).size.height * 0.7,
                  child: DragTarget<Task>(
                    onAccept: (receivedTask) {
                      debugPrint("Task ${receivedTask.name} dropped on $statusName");
                      if (receivedTask.statusId != statusObj.id) {
                        controller.updateTaskStatus(
                          taskId: receivedTask.id!,
                          newStatusId: statusObj.id!,
                          newStatusName: statusObj.name ?? 'Unknown',
                          newStatusColor: statusObj.color ?? '#000000',
                        );
                      }
                    },
                    builder: (context, candidateData, rejectedData) => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView(
                        children: tasks.map((task) {
                          return Draggable<Task>(
                            data: task,
                            feedback: Material(
                              type: MaterialType.transparency,
                              child: SizedBox(
                                width: 280,
                                child: _buildTaskCard(task),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.5,
                              child: _buildTaskCard(task),
                            ),
                            child: _buildTaskCard(task),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              task.name ?? 'No Task Name',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Staff
            Row(
              children: const [
                Icon(Icons.person_pin_circle_outlined, size: 16),
                SizedBox(width: 4),
                Text("Staff", style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),

            // Status
            Row(
              children: [
                const Icon(Icons.check_box_outlined, size: 16),
                const SizedBox(width: 4),
                _buildBadge(task.status?.name ?? 'Unknown',
                    color: task.status?.color ?? '#000000'),
              ],
            ),
            const SizedBox(height: 4),

            // Priority
            Row(
              children: const [
                Icon(Icons.flag_outlined, size: 16),
                SizedBox(width: 4),
                Text("High", style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),

            // Type
            Row(
              children: const [
                Icon(Icons.label_outline, size: 16),
                SizedBox(width: 4),
                Text("Task", style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),

            // Date Range
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  "${task.startDate ?? 'Start'} - ${task.endDate ?? 'End'}",
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
                const Spacer(),
                const Icon(Icons.remove_red_eye_outlined, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, {String color = '#000000'}) {
    Color badgeColor = _hexToColor(color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        border: Border.all(color: badgeColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: badgeColor,
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Tambahkan alpha jika tidak ada
    }
    return Color(int.parse(hex, radix: 16));
  }
}
