// kanban_response.dart

class TaskStatusResponse {
  bool? success;
  String? message;
  List<TaskStatus>? taskStatus;

  TaskStatusResponse({this.success, this.message, this.taskStatus});

  TaskStatusResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['taskStatus'] != null) {
      taskStatus = <TaskStatus>[];
      json['taskStatus'].forEach((v) {
        taskStatus!.add(TaskStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (taskStatus != null) {
      data['taskStatus'] = taskStatus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskStatus {
  int? id;
  String? name;
  String? color;
  int? isDefault;
  int? order;
  String? createdAt;
  String? updatedAt;

  TaskStatus({
    this.id,
    this.name,
    this.color,
    this.isDefault,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  TaskStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    isDefault = json['is_default'];
    order = json['order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['color'] = color;
    data['is_default'] = isDefault;
    data['order'] = order;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}