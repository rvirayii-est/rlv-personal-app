import '../database/database_helper.dart';
import '../models/todo.dart';

/// TodoService
/// Service layer for managing Todo CRUD operations
/// This class acts as a bridge between the UI and the database
class TodoService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Create a new todo
  /// Returns the ID of the newly created todo
  Future<int> createTodo(Todo todo) async {
    todo.updatedAt = DateTime.now();
    return await _dbHelper.insert(
      DatabaseHelper.tableTodos,
      todo.toMap(),
    );
  }

  /// Get all todos
  /// Returns a list of all todos ordered by creation date (newest first)
  Future<List<Todo>> getAllTodos() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAll(
      DatabaseHelper.tableTodos,
      orderBy: '${DatabaseHelper.columnTodoCreatedAt} DESC',
    );
    return List.generate(maps.length, (i) => Todo.fromMap(maps[i]));
  }

  /// Get todo by id
  /// Returns a single todo or null if not found
  Future<Todo?> getTodoById(int id) async {
    final map = await _dbHelper.queryById(
      DatabaseHelper.tableTodos,
      id,
      DatabaseHelper.columnTodoId,
    );
    return map != null ? Todo.fromMap(map) : null;
  }

  /// Get todos by completion status
  /// Pass true for completed todos, false for pending todos
  Future<List<Todo>> getTodosByStatus(bool isCompleted) async {
    final maps = await _dbHelper.queryWhere(
      DatabaseHelper.tableTodos,
      '${DatabaseHelper.columnTodoIsCompleted} = ?',
      [isCompleted ? 1 : 0],
      orderBy: '${DatabaseHelper.columnTodoCreatedAt} DESC',
    );
    return List.generate(maps.length, (i) => Todo.fromMap(maps[i]));
  }

  /// Get todos by priority
  /// Priority can be 'low', 'medium', or 'high'
  Future<List<Todo>> getTodosByPriority(String priority) async {
    final maps = await _dbHelper.queryWhere(
      DatabaseHelper.tableTodos,
      '${DatabaseHelper.columnTodoPriority} = ?',
      [priority],
      orderBy: '${DatabaseHelper.columnTodoCreatedAt} DESC',
    );
    return List.generate(maps.length, (i) => Todo.fromMap(maps[i]));
  }

  /// Get pending (not completed) todos
  Future<List<Todo>> getPendingTodos() async {
    return await getTodosByStatus(false);
  }

  /// Get completed todos
  Future<List<Todo>> getCompletedTodos() async {
    return await getTodosByStatus(true);
  }

  /// Get overdue todos
  /// Returns todos that are past their due date and not completed
  Future<List<Todo>> getOverdueTodos() async {
    final allPending = await getPendingTodos();
    final now = DateTime.now();

    return allPending.where((todo) {
      if (todo.dueDate == null) return false;
      try {
        final dueDate = DateTime.parse(todo.dueDate!);
        return dueDate.isBefore(now);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  /// Update todo
  /// Returns the number of rows affected (should be 1)
  Future<int> updateTodo(Todo todo) async {
    todo.updatedAt = DateTime.now();
    return await _dbHelper.update(
      DatabaseHelper.tableTodos,
      todo.toMap(),
      todo.id!,
      DatabaseHelper.columnTodoId,
    );
  }

  /// Toggle todo completion status
  /// This is a convenience method for quickly marking todos as done/undone
  Future<int> toggleTodoStatus(int id) async {
    final todo = await getTodoById(id);
    if (todo == null) return 0;

    final updatedTodo = todo.copyWith(
      isCompleted: !todo.isCompleted,
      updatedAt: DateTime.now(),
    );

    return await updateTodo(updatedTodo);
  }

  /// Delete todo
  /// Returns the number of rows affected (should be 1)
  Future<int> deleteTodo(int id) async {
    return await _dbHelper.delete(
      DatabaseHelper.tableTodos,
      id,
      DatabaseHelper.columnTodoId,
    );
  }

  /// Delete all completed todos
  /// Useful for cleaning up old completed tasks
  Future<int> deleteCompletedTodos() async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableTodos,
      where: '${DatabaseHelper.columnTodoIsCompleted} = ?',
      whereArgs: [1],
    );
  }

  /// Get count of all todos
  Future<int> getTodoCount() async {
    return await _dbHelper.getCount(DatabaseHelper.tableTodos);
  }

  /// Get count of pending todos
  Future<int> getPendingCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${DatabaseHelper.tableTodos} WHERE ${DatabaseHelper.columnTodoIsCompleted} = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get count of completed todos
  Future<int> getCompletedCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM ${DatabaseHelper.tableTodos} WHERE ${DatabaseHelper.columnTodoIsCompleted} = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Search todos by title or description
  Future<List<Todo>> searchTodos(String searchTerm) async {
    final maps = await _dbHelper.queryWhere(
      DatabaseHelper.tableTodos,
      '${DatabaseHelper.columnTodoTitle} LIKE ? OR ${DatabaseHelper.columnTodoDescription} LIKE ?',
      ['%$searchTerm%', '%$searchTerm%'],
      orderBy: DatabaseHelper.columnTodoCreatedAt,
    );
    return List.generate(maps.length, (i) => Todo.fromMap(maps[i]));
  }

  /// Get todo statistics
  /// Returns a map with various statistics
  Future<Map<String, int>> getTodoStatistics() async {
    final total = await getTodoCount();
    final pending = await getPendingCount();
    final completed = await getCompletedCount();
    final overdue = (await getOverdueTodos()).length;

    return {
      'total': total,
      'pending': pending,
      'completed': completed,
      'overdue': overdue,
    };
  }
}
