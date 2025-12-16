import '../database/database_helper.dart';
import '../models/pomodoro_session.dart';

/// PomodoroService
/// Service layer for managing Pomodoro sessions
class PomodoroService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Create a new pomodoro session
  Future<int> createSession(PomodoroSession session) async {
    return await _dbHelper.insert(
      DatabaseHelper.tablePomodoroSessions,
      session.toMap(),
    );
  }

  /// Get all sessions
  Future<List<PomodoroSession>> getAllSessions() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.queryAll(
      DatabaseHelper.tablePomodoroSessions,
      orderBy: '${DatabaseHelper.columnPomodoroCreatedAt} DESC',
    );
    return List.generate(maps.length, (i) => PomodoroSession.fromMap(maps[i]));
  }

  /// Get session by id
  Future<PomodoroSession?> getSessionById(int id) async {
    final map = await _dbHelper.queryById(
      DatabaseHelper.tablePomodoroSessions,
      id,
      DatabaseHelper.columnPomodoroId,
    );
    return map != null ? PomodoroSession.fromMap(map) : null;
  }

  /// Get sessions by type
  Future<List<PomodoroSession>> getSessionsByType(String type) async {
    final maps = await _dbHelper.queryWhere(
      DatabaseHelper.tablePomodoroSessions,
      '${DatabaseHelper.columnPomodoroType} = ?',
      [type],
      orderBy: '${DatabaseHelper.columnPomodoroCreatedAt} DESC',
    );
    return List.generate(maps.length, (i) => PomodoroSession.fromMap(maps[i]));
  }

  /// Get completed sessions
  Future<List<PomodoroSession>> getCompletedSessions() async {
    final maps = await _dbHelper.queryWhere(
      DatabaseHelper.tablePomodoroSessions,
      '${DatabaseHelper.columnPomodoroCompleted} = ?',
      [1],
      orderBy: '${DatabaseHelper.columnPomodoroCreatedAt} DESC',
    );
    return List.generate(maps.length, (i) => PomodoroSession.fromMap(maps[i]));
  }

  /// Get sessions for today
  Future<List<PomodoroSession>> getTodaySessions() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final maps = await _dbHelper.queryWhere(
      DatabaseHelper.tablePomodoroSessions,
      '${DatabaseHelper.columnPomodoroCreatedAt} >= ? AND ${DatabaseHelper.columnPomodoroCreatedAt} < ?',
      [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
      orderBy: '${DatabaseHelper.columnPomodoroCreatedAt} DESC',
    );
    return List.generate(maps.length, (i) => PomodoroSession.fromMap(maps[i]));
  }

  /// Get sessions for this week
  Future<List<PomodoroSession>> getWeekSessions() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    final maps = await _dbHelper.queryWhere(
      DatabaseHelper.tablePomodoroSessions,
      '${DatabaseHelper.columnPomodoroCreatedAt} >= ?',
      [startOfWeekDay.toIso8601String()],
      orderBy: '${DatabaseHelper.columnPomodoroCreatedAt} DESC',
    );
    return List.generate(maps.length, (i) => PomodoroSession.fromMap(maps[i]));
  }

  /// Delete session
  Future<int> deleteSession(int id) async {
    return await _dbHelper.delete(
      DatabaseHelper.tablePomodoroSessions,
      id,
      DatabaseHelper.columnPomodoroId,
    );
  }

  /// Get total session count
  Future<int> getSessionCount() async {
    return await _dbHelper.getCount(DatabaseHelper.tablePomodoroSessions);
  }

  /// Get today's work session count
  Future<int> getTodayWorkSessionCount() async {
    final todaySessions = await getTodaySessions();
    return todaySessions.where((s) => s.type == 'work' && s.wasCompleted).length;
  }

  /// Get today's completed work sessions count
  Future<int> getTodayCompletedCount() async {
    final todaySessions = await getTodaySessions();
    return todaySessions.where((s) => s.wasCompleted).length;
  }

  /// Get total focus time in minutes for today
  Future<int> getTodayFocusTime() async {
    final todaySessions = await getTodaySessions();
    final workSessions = todaySessions.where((s) => s.type == 'work' && s.wasCompleted);
    return workSessions.fold(0, (sum, session) => sum + session.durationMinutes);
  }

  /// Get total focus time in minutes for this week
  Future<int> getWeekFocusTime() async {
    final weekSessions = await getWeekSessions();
    final workSessions = weekSessions.where((s) => s.type == 'work' && s.wasCompleted);
    return workSessions.fold(0, (sum, session) => sum + session.durationMinutes);
  }

  /// Get statistics
  Future<Map<String, int>> getStatistics() async {
    final allSessions = await getAllSessions();
    final todaySessions = await getTodaySessions();
    final weekSessions = await getWeekSessions();

    final totalWork = allSessions.where((s) => s.type == 'work' && s.wasCompleted).length;
    final todayWork = todaySessions.where((s) => s.type == 'work' && s.wasCompleted).length;
    final weekWork = weekSessions.where((s) => s.type == 'work' && s.wasCompleted).length;

    final totalTime = allSessions
        .where((s) => s.type == 'work' && s.wasCompleted)
        .fold(0, (sum, s) => sum + s.durationMinutes);
    final todayTime = todaySessions
        .where((s) => s.type == 'work' && s.wasCompleted)
        .fold(0, (sum, s) => sum + s.durationMinutes);
    final weekTime = weekSessions
        .where((s) => s.type == 'work' && s.wasCompleted)
        .fold(0, (sum, s) => sum + s.durationMinutes);

    return {
      'totalSessions': allSessions.length,
      'totalWorkSessions': totalWork,
      'todayWorkSessions': todayWork,
      'weekWorkSessions': weekWork,
      'totalMinutes': totalTime,
      'todayMinutes': todayTime,
      'weekMinutes': weekTime,
    };
  }
}
