import '../database/database_helper.dart';

/// Todo Model
/// Represents a todo item in the database
class Todo {
  int? id;
  String title;
  String? description;
  bool isCompleted;
  String? dueDate; // ISO8601 date string
  String priority; // 'low', 'medium', 'high'
  DateTime createdAt;
  DateTime updatedAt;

  Todo({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
    this.priority = 'medium',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Convert Todo object to Map for database storage
  /// This is required by SQLite as it stores data in Map format
  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnTodoId: id,
      DatabaseHelper.columnTodoTitle: title,
      DatabaseHelper.columnTodoDescription: description,
      DatabaseHelper.columnTodoIsCompleted: isCompleted ? 1 : 0, // SQLite uses 0/1 for boolean
      DatabaseHelper.columnTodoDueDate: dueDate,
      DatabaseHelper.columnTodoPriority: priority,
      DatabaseHelper.columnTodoCreatedAt: createdAt.toIso8601String(),
      DatabaseHelper.columnTodoUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  /// Create Todo object from Map (from database)
  /// This factory constructor converts database Map back to Todo object
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map[DatabaseHelper.columnTodoId] as int?,
      title: map[DatabaseHelper.columnTodoTitle] as String,
      description: map[DatabaseHelper.columnTodoDescription] as String?,
      isCompleted: (map[DatabaseHelper.columnTodoIsCompleted] as int) == 1, // Convert 0/1 to bool
      dueDate: map[DatabaseHelper.columnTodoDueDate] as String?,
      priority: map[DatabaseHelper.columnTodoPriority] as String? ?? 'medium',
      createdAt: DateTime.parse(map[DatabaseHelper.columnTodoCreatedAt] as String),
      updatedAt: DateTime.parse(map[DatabaseHelper.columnTodoUpdatedAt] as String),
    );
  }

  /// Create a copy of Todo with updated fields
  /// This is useful for updating specific fields without modifying the original object
  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? dueDate,
    String? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get priority color based on priority level
  /// Helper method for UI display
  String getPriorityColor() {
    switch (priority) {
      case 'high':
        return 'red';
      case 'medium':
        return 'orange';
      case 'low':
        return 'green';
      default:
        return 'grey';
    }
  }

  /// Check if todo is overdue
  /// Returns true if due date is in the past and todo is not completed
  bool isOverdue() {
    if (dueDate == null || isCompleted) return false;
    try {
      final due = DateTime.parse(dueDate!);
      return due.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, isCompleted: $isCompleted, priority: $priority, dueDate: $dueDate}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Todo &&
        other.id == id &&
        other.title == title &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ isCompleted.hashCode;
  }
}
