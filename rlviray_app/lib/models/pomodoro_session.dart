import '../database/database_helper.dart';

/// PomodoroSession Model
/// Represents a completed Pomodoro session
class PomodoroSession {
  int? id;
  String type; // 'work', 'short_break', 'long_break'
  int durationMinutes;
  DateTime startTime;
  DateTime endTime;
  bool wasCompleted; // Did the user complete the full session?
  String? notes;
  DateTime createdAt;

  PomodoroSession({
    this.id,
    required this.type,
    required this.durationMinutes,
    required this.startTime,
    required this.endTime,
    this.wasCompleted = true,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Convert PomodoroSession to Map for database
  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnPomodoroId: id,
      DatabaseHelper.columnPomodoroType: type,
      DatabaseHelper.columnPomodoroDuration: durationMinutes,
      DatabaseHelper.columnPomodoroStartTime: startTime.toIso8601String(),
      DatabaseHelper.columnPomodoroEndTime: endTime.toIso8601String(),
      DatabaseHelper.columnPomodoroCompleted: wasCompleted ? 1 : 0,
      DatabaseHelper.columnPomodoroNotes: notes,
      DatabaseHelper.columnPomodoroCreatedAt: createdAt.toIso8601String(),
    };
  }

  /// Create PomodoroSession from Map
  factory PomodoroSession.fromMap(Map<String, dynamic> map) {
    return PomodoroSession(
      id: map[DatabaseHelper.columnPomodoroId] as int?,
      type: map[DatabaseHelper.columnPomodoroType] as String,
      durationMinutes: map[DatabaseHelper.columnPomodoroDuration] as int,
      startTime: DateTime.parse(map[DatabaseHelper.columnPomodoroStartTime] as String),
      endTime: DateTime.parse(map[DatabaseHelper.columnPomodoroEndTime] as String),
      wasCompleted: (map[DatabaseHelper.columnPomodoroCompleted] as int) == 1,
      notes: map[DatabaseHelper.columnPomodoroNotes] as String?,
      createdAt: DateTime.parse(map[DatabaseHelper.columnPomodoroCreatedAt] as String),
    );
  }

  /// Get duration in minutes
  int get actualDurationMinutes {
    return endTime.difference(startTime).inMinutes;
  }

  /// Get display name for session type
  String get typeDisplayName {
    switch (type) {
      case 'work':
        return 'Work Session';
      case 'short_break':
        return 'Short Break';
      case 'long_break':
        return 'Long Break';
      default:
        return type;
    }
  }

  @override
  String toString() {
    return 'PomodoroSession{id: $id, type: $type, duration: $durationMinutes min, completed: $wasCompleted}';
  }
}

/// Pomodoro Settings
class PomodoroSettings {
  int workDuration; // in minutes
  int shortBreakDuration; // in minutes
  int longBreakDuration; // in minutes
  int sessionsBeforeLongBreak; // number of work sessions before long break
  bool autoStartBreaks;
  bool autoStartPomodoros;

  PomodoroSettings({
    this.workDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.sessionsBeforeLongBreak = 4,
    this.autoStartBreaks = false,
    this.autoStartPomodoros = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'workDuration': workDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'sessionsBeforeLongBreak': sessionsBeforeLongBreak,
      'autoStartBreaks': autoStartBreaks,
      'autoStartPomodoros': autoStartPomodoros,
    };
  }

  factory PomodoroSettings.fromJson(Map<String, dynamic> json) {
    return PomodoroSettings(
      workDuration: json['workDuration'] ?? 25,
      shortBreakDuration: json['shortBreakDuration'] ?? 5,
      longBreakDuration: json['longBreakDuration'] ?? 15,
      sessionsBeforeLongBreak: json['sessionsBeforeLongBreak'] ?? 4,
      autoStartBreaks: json['autoStartBreaks'] ?? false,
      autoStartPomodoros: json['autoStartPomodoros'] ?? false,
    );
  }
}
