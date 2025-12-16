import '../database/database_helper.dart';
import '../models/user.dart';

class UserService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create a new user
  Future<int> createUser(User user) async {
    user.updatedAt = DateTime.now();
    return await _dbHelper.insert(
      DatabaseHelper.tableUsers,
      user.toMap(),
    );
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAll(
      DatabaseHelper.tableUsers,
      orderBy: '${DatabaseHelper.columnUserCreatedAt} DESC',
    );
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  // Get user by id
  Future<User?> getUserById(int id) async {
    final map = await _dbHelper.queryById(
      DatabaseHelper.tableUsers,
      id,
      DatabaseHelper.columnUserId,
    );
    return map != null ? User.fromMap(map) : null;
  }

  // Get user by email
  Future<User?> getUserByEmail(String email) async {
    final maps = await _dbHelper.queryWhere(
      DatabaseHelper.tableUsers,
      '${DatabaseHelper.columnUserEmail} = ?',
      [email],
    );
    return maps.isNotEmpty ? User.fromMap(maps.first) : null;
  }

  // Update user
  Future<int> updateUser(User user) async {
    user.updatedAt = DateTime.now();
    return await _dbHelper.update(
      DatabaseHelper.tableUsers,
      user.toMap(),
      user.id!,
      DatabaseHelper.columnUserId,
    );
  }

  // Delete user
  Future<int> deleteUser(int id) async {
    return await _dbHelper.delete(
      DatabaseHelper.tableUsers,
      id,
      DatabaseHelper.columnUserId,
    );
  }

  // Get user count
  Future<int> getUserCount() async {
    return await _dbHelper.getCount(DatabaseHelper.tableUsers);
  }

  // Search users by name
  Future<List<User>> searchUsersByName(String searchTerm) async {
    final maps = await _dbHelper.queryWhere(
      DatabaseHelper.tableUsers,
      '${DatabaseHelper.columnUserName} LIKE ?',
      ['%$searchTerm%'],
      orderBy: DatabaseHelper.columnUserName,
    );
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }
}
