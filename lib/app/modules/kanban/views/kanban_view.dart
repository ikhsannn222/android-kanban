import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p5_kanban/app/data/kanban_response.dart';
import '../controllers/kanban_controller.dart';

class KanbanView extends GetView<KanbanController> {
  const KanbanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KanbanController());
    final int projectId = Get.arguments;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getTaskStatuses();
      await controller.getTask(projectId);
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

        if (controller.taskStatuses.isEmpty) {
          return const Center(child: Text("Belum ada data status"));
        }

        final groupedTasks = controller.groupTasksByStatus(tasks);

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
    return Container(
      width: 300,
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
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
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(task.name ?? ''),
                            ),
                          ),
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
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(task.name ?? 'No Task Name'),
        subtitle: Text('Status: ${task.status?.name ?? 'Unknown'}'),
      ),
    );
  }
}
