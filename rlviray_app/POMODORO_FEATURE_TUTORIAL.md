# Pomodoro Timer Feature - Complete Implementation Tutorial

## Table of Contents
1. [Introduction](#introduction)
2. [What is Pomodoro Technique?](#what-is-pomodoro-technique)
3. [Architecture Overview](#architecture-overview)
4. [Implementation Steps](#implementation-steps)
5. [Code Deep Dive](#code-deep-dive)
6. [Key Concepts Explained](#key-concepts-explained)
7. [Best Practices](#best-practices)
8. [Testing and Debugging](#testing-and-debugging)
9. [Summary](#summary)

---

## Introduction

This tutorial explains how we built a complete Pomodoro timer feature for the Flutter app. You'll learn about timer management, session tracking, statistics calculation, and settings persistence.

### What You'll Learn

- How to implement a countdown timer in Flutter
- Session state management
- Database session tracking
- SharedPreferences for settings
- TabController for multi-tab UI
- Real-time UI updates
- DateTime operations and formatting
- Statistics aggregation

### Prerequisites

- Basic Flutter knowledge
- Understanding of StatefulWidget
- Familiarity with async/await
- SQLite basics (covered in previous tutorials)

---

## What is Pomodoro Technique?

The Pomodoro Technique is a time management method:

1. **Work Session** (25 minutes): Focus on a single task
2. **Short Break** (5 minutes): Rest and recharge
3. **Repeat**: After 4 work sessions, take a longer break
4. **Long Break** (15 minutes): Extended rest period

### Benefits

- Improved focus and concentration
- Better time awareness
- Reduced mental fatigue
- Increased productivity
- Clear work-rest boundaries

---

## Architecture Overview

### Layered Architecture

```
┌─────────────────────────────────────┐
│     PomodoroScreen (UI Layer)       │
│  - Timer display                    │
│  - Control buttons                  │
│  - Session history                  │
│  - Settings dialog                  │
└──────────────┬──────────────────────┘
               │
               │ calls methods
               ▼
┌─────────────────────────────────────┐
│  PomodoroService (Business Logic)   │
│  - CRUD operations                  │
│  - Session filtering                │
│  - Statistics calculation           │
└──────────────┬──────────────────────┘
               │
               │ uses
               ▼
┌─────────────────────────────────────┐
│  PomodoroSession (Model Layer)      │
│  - Data structure                   │
│  - toMap() / fromMap()              │
│  - Helper methods                   │
└──────────────┬──────────────────────┘
               │
               │ converts to/from
               ▼
┌─────────────────────────────────────┐
│  DatabaseHelper (Data Layer)        │
│  - Generic CRUD methods             │
│  - SQLite operations                │
└──────────────┬──────────────────────┘
               │
               │ stores in
               ▼
┌─────────────────────────────────────┐
│  SQLite Database                    │
│  - pomodoro_sessions table          │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  SharedPreferences                  │
│  - Settings persistence (JSON)      │
└─────────────────────────────────────┘
```

### Data Flow

#### Starting a Session
```
User taps Start
   ↓
Timer starts (Timer.periodic)
   ↓
Every second: _remainingSeconds--
   ↓
setState() updates UI
   ↓
When reaches 0: _completeSession()
   ↓
Save to database via PomodoroService
   ↓
Update statistics
   ↓
Show completion dialog
```

#### Loading Statistics
```
Screen opens
   ↓
Call PomodoroService.getStatistics()
   ↓
Service queries database
   ↓
Filter sessions by date/type
   ↓
Aggregate counts and durations
   ↓
Return to UI
   ↓
setState() displays stats
```

---

## Implementation Steps

### Step 1: Create the Data Model

**File**: `lib/models/pomodoro_session.dart`

The model represents a completed Pomodoro session with all relevant data.

```dart
class PomodoroSession {
  int? id;                    // Database primary key
  String type;                // 'work', 'short_break', 'long_break'
  int durationMinutes;        // Planned duration
  DateTime startTime;         // When session started
  DateTime endTime;           // When session ended
  bool wasCompleted;          // Did user complete it?
  String? notes;              // Optional notes
  DateTime createdAt;         // Record creation time

  // Constructor with required fields
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
}
```

**Key Methods:**

1. **toMap()** - Convert to database format:
```dart
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'type': type,
    'duration_minutes': durationMinutes,
    'start_time': startTime.toIso8601String(),  // Store as ISO string
    'end_time': endTime.toIso8601String(),
    'was_completed': wasCompleted ? 1 : 0,      // Boolean → Integer
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
  };
}
```

2. **fromMap()** - Create from database:
```dart
factory PomodoroSession.fromMap(Map<String, dynamic> map) {
  return PomodoroSession(
    id: map['id'] as int?,
    type: map['type'] as String,
    durationMinutes: map['duration_minutes'] as int,
    startTime: DateTime.parse(map['start_time'] as String),
    endTime: DateTime.parse(map['end_time'] as String),
    wasCompleted: (map['was_completed'] as int) == 1,  // Integer → Boolean
    notes: map['notes'] as String?,
    createdAt: DateTime.parse(map['created_at'] as String),
  );
}
```

3. **Helper Getters:**
```dart
// Calculate actual duration from start/end times
int get actualDurationMinutes {
  return endTime.difference(startTime).inMinutes;
}

// Get user-friendly display name
String get typeDisplayName {
  switch (type) {
    case 'work': return 'Work Session';
    case 'short_break': return 'Short Break';
    case 'long_break': return 'Long Break';
    default: return type;
  }
}
```

**PomodoroSettings Class:**

Stores user preferences for timer durations and behavior.

```dart
class PomodoroSettings {
  int workDuration;              // Default: 25 minutes
  int shortBreakDuration;        // Default: 5 minutes
  int longBreakDuration;         // Default: 15 minutes
  int sessionsBeforeLongBreak;   // Default: 4 sessions
  bool autoStartBreaks;          // Auto-start break after work?
  bool autoStartPomodoros;       // Auto-start work after break?

  PomodoroSettings({
    this.workDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.sessionsBeforeLongBreak = 4,
    this.autoStartBreaks = false,
    this.autoStartPomodoros = false,
  });

  // Serialize to JSON for SharedPreferences
  Map<String, dynamic> toJson() { ... }

  // Deserialize from JSON
  factory PomodoroSettings.fromJson(Map<String, dynamic> json) { ... }
}
```

### Step 2: Update Database Schema

**File**: `lib/database/database_helper.dart`

Add table name and column constants:

```dart
// Table name
static const String tablePomodoroSessions = 'pomodoro_sessions';

// Column names
static const String columnPomodoroId = 'id';
static const String columnPomodoroType = 'type';
static const String columnPomodoroDuration = 'duration_minutes';
static const String columnPomodoroStartTime = 'start_time';
static const String columnPomodoroEndTime = 'end_time';
static const String columnPomodoroCompleted = 'was_completed';
static const String columnPomodoroNotes = 'notes';
static const String columnPomodoroCreatedAt = 'created_at';
```

Create the table in `_onCreate()`:

```dart
await db.execute('''
  CREATE TABLE $tablePomodoroSessions (
    $columnPomodoroId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnPomodoroType TEXT NOT NULL,
    $columnPomodoroDuration INTEGER NOT NULL,
    $columnPomodoroStartTime TEXT NOT NULL,
    $columnPomodoroEndTime TEXT NOT NULL,
    $columnPomodoroCompleted INTEGER NOT NULL DEFAULT 1,
    $columnPomodoroNotes TEXT,
    $columnPomodoroCreatedAt TEXT NOT NULL
  )
''');
```

**Why this schema?**
- `type TEXT`: Stores session type as string ('work', 'short_break', 'long_break')
- `duration_minutes INTEGER`: Planned duration for reference
- `start_time/end_time TEXT`: ISO8601 timestamps for accurate tracking
- `was_completed INTEGER`: Boolean as 0/1 (SQLite standard)
- `notes TEXT`: Optional field for session notes

### Step 3: Create the Service Layer

**File**: `lib/services/pomodoro_service.dart`

The service handles all business logic and database interactions.

**CRUD Operations:**

```dart
class PomodoroService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create a session
  Future<int> createSession(PomodoroSession session) async {
    return await _dbHelper.insert(
      DatabaseHelper.tablePomodoroSessions,
      session.toMap(),
    );
  }

  // Get all sessions (newest first)
  Future<List<PomodoroSession>> getAllSessions() async {
    final maps = await _dbHelper.queryAll(
      DatabaseHelper.tablePomodoroSessions,
      orderBy: '${DatabaseHelper.columnPomodoroCreatedAt} DESC',
    );
    return maps.map((m) => PomodoroSession.fromMap(m)).toList();
  }

  // Get specific session
  Future<PomodoroSession?> getSessionById(int id) async {
    final map = await _dbHelper.queryById(
      DatabaseHelper.tablePomodoroSessions,
      id,
      DatabaseHelper.columnPomodoroId,
    );
    return map != null ? PomodoroSession.fromMap(map) : null;
  }

  // Delete session
  Future<int> deleteSession(int id) async {
    return await _dbHelper.delete(
      DatabaseHelper.tablePomodoroSessions,
      id,
      DatabaseHelper.columnPomodoroId,
    );
  }
}
```

**Filtering Methods:**

```dart
// Get sessions for today
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
  return maps.map((m) => PomodoroSession.fromMap(m)).toList();
}

// Get sessions for this week
Future<List<PomodoroSession>> getWeekSessions() async {
  final now = DateTime.now();
  // Monday is weekday 1, Sunday is weekday 7
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

  final maps = await _dbHelper.queryWhere(
    DatabaseHelper.tablePomodoroSessions,
    '${DatabaseHelper.columnPomodoroCreatedAt} >= ?',
    [startOfWeekDay.toIso8601String()],
    orderBy: '${DatabaseHelper.columnPomodoroCreatedAt} DESC',
  );
  return maps.map((m) => PomodoroSession.fromMap(m)).toList();
}
```

**Statistics Methods:**

```dart
// Get today's completed work session count
Future<int> getTodayWorkSessionCount() async {
  final todaySessions = await getTodaySessions();
  return todaySessions.where((s) => s.type == 'work' && s.wasCompleted).length;
}

// Get total focus time for today (in minutes)
Future<int> getTodayFocusTime() async {
  final todaySessions = await getTodaySessions();
  final workSessions = todaySessions.where((s) => s.type == 'work' && s.wasCompleted);
  return workSessions.fold(0, (sum, session) => sum + session.durationMinutes);
}

// Get comprehensive statistics
Future<Map<String, int>> getStatistics() async {
  final allSessions = await getAllSessions();
  final todaySessions = await getTodaySessions();
  final weekSessions = await getWeekSessions();

  return {
    'totalSessions': allSessions.length,
    'totalWorkSessions': allSessions.where((s) => s.type == 'work' && s.wasCompleted).length,
    'todayWorkSessions': todaySessions.where((s) => s.type == 'work' && s.wasCompleted).length,
    'weekWorkSessions': weekSessions.where((s) => s.type == 'work' && s.wasCompleted).length,
    'totalMinutes': allSessions.where((s) => s.type == 'work' && s.wasCompleted)
        .fold(0, (sum, s) => sum + s.durationMinutes),
    'todayMinutes': todaySessions.where((s) => s.type == 'work' && s.wasCompleted)
        .fold(0, (sum, s) => sum + s.durationMinutes),
    'weekMinutes': weekSessions.where((s) => s.type == 'work' && s.wasCompleted)
        .fold(0, (sum, s) => sum + s.durationMinutes),
  };
}
```

### Step 4: Create the UI Screen

**File**: `lib/screens/pomodoro_screen.dart`

This is a complex screen with multiple components. Let's break it down.

**State Variables:**

```dart
class _PomodoroScreenState extends State<PomodoroScreen>
    with TickerProviderStateMixin {  // Needed for TabController

  // Service
  final PomodoroService _pomodoroService = PomodoroService();

  // Timer state
  Timer? _timer;                    // The countdown timer
  int _remainingSeconds = 0;        // Time left in current session
  bool _isRunning = false;          // Is timer actively running?
  DateTime? _sessionStartTime;      // When current session started

  // Session management
  String _currentSessionType = 'work';    // Current type
  int _completedWorkSessions = 0;         // Count for long break logic

  // Settings
  late PomodoroSettings _settings;

  // Statistics
  int _todayWorkSessions = 0;
  int _todayFocusTime = 0;
  int _weekWorkSessions = 0;
  int _weekFocusTime = 0;

  // History
  List<PomodoroSession> _recentSessions = [];

  // UI state
  late TabController _tabController;
  bool _isLoading = true;
}
```

**Initialization:**

```dart
@override
void initState() {
  super.initState();
  _tabController = TabController(length: 2, vsync: this);
  _loadSettings();      // Load from SharedPreferences
  _loadStatistics();    // Load from database
  _loadRecentSessions();
}

@override
void dispose() {
  _timer?.cancel();           // IMPORTANT: Cancel timer
  _tabController.dispose();   // Dispose controller
  super.dispose();
}
```

**Loading Settings:**

```dart
Future<void> _loadSettings() async {
  final prefs = await SharedPreferences.getInstance();
  final settingsJson = prefs.getString('pomodoro_settings');

  if (settingsJson != null) {
    final Map<String, dynamic> settingsMap = json.decode(settingsJson);
    _settings = PomodoroSettings.fromJson(settingsMap);
  } else {
    _settings = PomodoroSettings();  // Use defaults
  }

  // Initialize timer with work duration
  _remainingSeconds = _settings.workDuration * 60;

  setState(() {
    _isLoading = false;
  });
}

Future<void> _saveSettings() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('pomodoro_settings', json.encode(_settings.toJson()));
}
```

**Timer Control Methods:**

```dart
void _startTimer() {
  if (_isRunning) return;  // Already running

  setState(() {
    _isRunning = true;
    _sessionStartTime = DateTime.now();  // Record start time
  });

  // Create repeating timer
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    setState(() {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;  // Count down
      } else {
        _completeSession();   // Session finished
      }
    });
  });
}

void _pauseTimer() {
  setState(() {
    _isRunning = false;
  });
  _timer?.cancel();  // Stop the timer
}

void _stopTimer() {
  _timer?.cancel();
  setState(() {
    _isRunning = false;
    _sessionStartTime = null;
    // Reset to full duration
    _remainingSeconds = _getDurationForType(_currentSessionType) * 60;
  });
}
```

**Session Completion:**

```dart
Future<void> _completeSession() async {
  _timer?.cancel();

  if (_sessionStartTime != null) {
    // Create session record
    final session = PomodoroSession(
      type: _currentSessionType,
      durationMinutes: _getDurationForType(_currentSessionType),
      startTime: _sessionStartTime!,
      endTime: DateTime.now(),
      wasCompleted: true,
    );

    // Save to database
    await _pomodoroService.createSession(session);

    // Update counter
    if (_currentSessionType == 'work') {
      _completedWorkSessions++;
    }

    // Reload data
    await _loadStatistics();
    await _loadRecentSessions();
  }

  setState(() {
    _isRunning = false;
    _sessionStartTime = null;
  });

  // Show completion dialog
  if (mounted) {
    _showCompletionDialog();
  }
}
```

**Session Type Switching:**

```dart
void _switchSessionType(String type) {
  setState(() {
    _currentSessionType = type;
    _remainingSeconds = _getDurationForType(type) * 60;
    _isRunning = false;
    _sessionStartTime = null;
  });
  _timer?.cancel();
}

int _getDurationForType(String type) {
  switch (type) {
    case 'work': return _settings.workDuration;
    case 'short_break': return _settings.shortBreakDuration;
    case 'long_break': return _settings.longBreakDuration;
    default: return _settings.workDuration;
  }
}

String _getNextSessionType() {
  if (_currentSessionType == 'work') {
    // After work, take a break
    if (_completedWorkSessions >= _settings.sessionsBeforeLongBreak) {
      _completedWorkSessions = 0;  // Reset counter
      return 'long_break';
    } else {
      return 'short_break';
    }
  } else {
    // After break, return to work
    return 'work';
  }
}
```

**Timer Display:**

```dart
Widget _buildTimerDisplay() {
  // Color based on session type
  Color timerColor;
  switch (_currentSessionType) {
    case 'work': timerColor = Colors.red; break;
    case 'short_break': timerColor = Colors.green; break;
    case 'long_break': timerColor = Colors.blue; break;
    default: timerColor = Colors.grey;
  }

  return Container(
    width: 280,
    height: 280,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: timerColor.withOpacity(0.1),
      border: Border.all(color: timerColor, width: 8),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(_remainingSeconds),  // MM:SS format
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: timerColor,
              fontFeatureSettings: const [
                FontFeature.tabularFigures()  // Monospace numbers
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getTypeDisplayName(_currentSessionType),
            style: TextStyle(
              fontSize: 18,
              color: timerColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

String _formatTime(int seconds) {
  int minutes = seconds ~/ 60;      // Integer division
  int secs = seconds % 60;          // Remainder
  return '${minutes.toString().padLeft(2, '0')}:'
         '${secs.toString().padLeft(2, '0')}';
}
```

**Control Buttons:**

```dart
Widget _buildControlButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Start/Pause button
      ElevatedButton.icon(
        onPressed: _isRunning ? _pauseTimer : _startTimer,
        icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 32),
        label: Text(_isRunning ? 'Pause' : 'Start'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isRunning ? Colors.orange : Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      const SizedBox(width: 16),

      // Stop button (only enabled if timer was started)
      ElevatedButton.icon(
        onPressed: (_isRunning || _remainingSeconds != _getDurationForType(_currentSessionType) * 60)
            ? _stopTimer
            : null,  // Disabled if at full duration
        icon: const Icon(Icons.stop, size: 32),
        label: const Text('Stop'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
    ],
  );
}
```

**History Tab:**

```dart
Widget _buildHistoryTab() {
  return RefreshIndicator(
    onRefresh: () async {
      await _loadRecentSessions();
    },
    child: _recentSessions.isEmpty
        ? const Center(child: Text('No sessions yet'))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _recentSessions.length,
            itemBuilder: (context, index) {
              final session = _recentSessions[index];
              return _buildSessionCard(session);
            },
          ),
  );
}

Widget _buildSessionCard(PomodoroSession session) {
  // Determine icon and color based on type
  Color typeColor;
  IconData typeIcon;
  switch (session.type) {
    case 'work':
      typeColor = Colors.red;
      typeIcon = Icons.work;
      break;
    case 'short_break':
      typeColor = Colors.green;
      typeIcon = Icons.coffee;
      break;
    case 'long_break':
      typeColor = Colors.blue;
      typeIcon = Icons.beach_access;
      break;
    default:
      typeColor = Colors.grey;
      typeIcon = Icons.timer;
  }

  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: typeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(typeIcon, color: typeColor),
      ),
      title: Text(session.typeDisplayName),
      subtitle: Text(
        '${session.durationMinutes} minutes • ${_formatDateTime(session.createdAt)}',
      ),
      trailing: session.wasCompleted
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.cancel, color: Colors.red),
    ),
  );
}
```

**Settings Dialog:**

```dart
void _showSettingsDialog() {
  showDialog(
    context: context,
    builder: (context) => _SettingsDialog(
      settings: _settings,
      onSave: (newSettings) {
        setState(() {
          _settings = newSettings;
          _remainingSeconds = _getDurationForType(_currentSessionType) * 60;
        });
        _saveSettings();
      },
    ),
  );
}

// Separate widget for settings dialog
class _SettingsDialog extends StatefulWidget {
  final PomodoroSettings settings;
  final Function(PomodoroSettings) onSave;
  // ... implementation with sliders and switches
}
```

### Step 5: Integrate with Home Screen

**File**: `lib/screens/home_screen.dart`

Add imports:
```dart
import '../services/pomodoro_service.dart';
import 'pomodoro_screen.dart';
```

Add variables:
```dart
final PomodoroService _pomodoroService = PomodoroService();
int _pomodoroTodaySessions = 0;
int _pomodoroTodayFocusTime = 0;
```

Update `_loadCounts()`:
```dart
final pomodoroTodaySessions = await _pomodoroService.getTodayWorkSessionCount();
final pomodoroTodayFocusTime = await _pomodoroService.getTodayFocusTime();
setState(() {
  // ... other counts
  _pomodoroTodaySessions = pomodoroTodaySessions;
  _pomodoroTodayFocusTime = pomodoroTodayFocusTime;
});
```

Add stat card:
```dart
_buildStatCard(
  title: 'Pomodoro',
  count: _pomodoroTodaySessions,
  icon: Icons.timer,
  color: Colors.orange,
  onTap: () => _navigateToPomodoro(),
  subtitle: '$_pomodoroTodayFocusTime minutes today',
),
```

Add navigation method:
```dart
void _navigateToPomodoro() async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PomodoroScreen()),
  );
  _loadCounts();
}
```

---

## Code Deep Dive

### Timer Management Deep Dive

**Why Timer.periodic?**

```dart
_timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  // This callback runs every second
  setState(() {
    if (_remainingSeconds > 0) {
      _remainingSeconds--;
    } else {
      _completeSession();
    }
  });
});
```

- `Timer.periodic` creates a repeating timer
- Runs callback every 1 second
- Updates UI with `setState()`
- Automatically managed - no manual loop needed

**Timer Lifecycle:**

1. **Created**: `Timer.periodic(...)` starts immediately
2. **Running**: Callback fires every second
3. **Cancelled**: `timer.cancel()` stops execution
4. **Disposed**: Must cancel in `dispose()` to prevent memory leaks

**Common Pitfalls:**

```dart
// ❌ BAD: Timer not cancelled
@override
void dispose() {
  super.dispose();  // Timer keeps running!
}

// ✅ GOOD: Timer properly cancelled
@override
void dispose() {
  _timer?.cancel();  // Stop timer
  _tabController.dispose();
  super.dispose();
}
```

### DateTime Operations Explained

**Today's Sessions:**

```dart
final now = DateTime.now();                                    // 2024-01-15 14:30:00
final startOfDay = DateTime(now.year, now.month, now.day);   // 2024-01-15 00:00:00
final endOfDay = startOfDay.add(const Duration(days: 1));    // 2024-01-16 00:00:00

// Query: WHERE created_at >= '2024-01-15T00:00:00' AND created_at < '2024-01-16T00:00:00'
```

Why this approach?
- Precise: Includes all of today, none of tomorrow
- Time zone safe: Uses local time
- Database efficient: Simple comparison

**This Week's Sessions:**

```dart
final now = DateTime.now();                                      // Monday 2024-01-15
final startOfWeek = now.subtract(Duration(days: now.weekday - 1));  // Goes back to Monday
final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

// Query: WHERE created_at >= '2024-01-15T00:00:00' (Monday at midnight)
```

Understanding `weekday`:
- Monday = 1
- Tuesday = 2
- ...
- Sunday = 7

If today is Wednesday (3):
- `now.weekday - 1` = 2
- Subtract 2 days → Monday

**ISO8601 String Format:**

```dart
DateTime.now().toIso8601String()  // "2024-01-15T14:30:00.000Z"

// Stored in database as TEXT
// Parsed back with DateTime.parse()
```

Benefits:
- Sortable as strings (lexicographic order matches chronological)
- Standardized format
- Time zone information preserved

### Statistics Aggregation

**The Fold Pattern:**

```dart
final totalMinutes = sessions
    .where((s) => s.type == 'work' && s.wasCompleted)
    .fold(0, (sum, session) => sum + session.durationMinutes);
```

Breaking it down:
1. `where()`: Filter to work sessions that were completed
2. `fold(0, ...)`: Start with sum = 0
3. For each session: `sum = sum + session.durationMinutes`
4. Return final sum

Example:
```dart
// Sessions: [25 min, 25 min, 25 min]
// fold(0, ...) executes:
// sum = 0 + 25 = 25
// sum = 25 + 25 = 50
// sum = 50 + 25 = 75
// Returns: 75
```

**Why not a for loop?**

```dart
// ❌ Verbose imperative style
int total = 0;
for (var session in sessions) {
  if (session.type == 'work' && session.wasCompleted) {
    total += session.durationMinutes;
  }
}

// ✅ Concise functional style
final total = sessions
    .where((s) => s.type == 'work' && s.wasCompleted)
    .fold(0, (sum, s) => sum + s.durationMinutes);
```

### SharedPreferences vs Database

**When to use SharedPreferences:**
- Small amounts of data
- User preferences/settings
- Key-value pairs
- No querying needed

**When to use Database:**
- Structured data
- Need to query/filter
- Relational data
- Large datasets

In our app:
- Settings → SharedPreferences (JSON object)
- Sessions → Database (need to query by date, type, etc.)

### State Management Patterns

**Local State with setState:**

```dart
class _PomodoroScreenState extends State<PomodoroScreen> {
  int _remainingSeconds = 0;  // Private, local state

  void _startTimer() {
    setState(() {
      _remainingSeconds--;  // Triggers rebuild
    });
  }
}
```

When `setState()` is called:
1. Flutter marks widget as needing rebuild
2. `build()` method runs again
3. New UI reflects updated state

**Why local state is sufficient here:**
- Timer state doesn't need to be shared
- Screen is self-contained
- No cross-screen communication needed

For more complex apps, consider:
- Provider for shared state
- Bloc for business logic separation
- GetX for reactive state management

---

## Key Concepts Explained

### 1. Mixins (TickerProviderStateMixin)

```dart
class _PomodoroScreenState extends State<PomodoroScreen>
    with TickerProviderStateMixin {
```

**What's a Mixin?**
- Adds functionality to a class
- Like inheriting, but from multiple sources
- Use `with` keyword

**TickerProviderStateMixin:**
- Provides `vsync` parameter for animations
- Required for `TabController`
- Manages ticker lifecycle automatically

**Why needed:**
```dart
_tabController = TabController(
  length: 2,
  vsync: this,  // 'this' provides TickerProvider
);
```

Without mixin:
```
Error: The argument type '_PomodoroScreenState' can't be assigned to parameter type 'TickerProvider'
```

### 2. Null Safety

**Null-aware operators:**

```dart
Timer? _timer;              // Can be null
_timer?.cancel();           // Only call if not null
_timer = null;              // Explicitly set to null

DateTime? _sessionStartTime;
if (_sessionStartTime != null) {
  // Dart knows it's not null here (smart cast)
  final duration = DateTime.now().difference(_sessionStartTime);
}
```

**Late initialization:**

```dart
late PomodoroSettings _settings;  // Will be initialized later

@override
void initState() {
  _settings = PomodoroSettings();  // Initialization
}
```

Benefits:
- Prevents null reference errors at compile time
- Makes code more explicit about nullability
- Reduces runtime crashes

### 3. Async/Await

**Understanding Futures:**

```dart
Future<List<PomodoroSession>> getTodaySessions() async {
  final maps = await _dbHelper.queryWhere(...);  // Wait for database
  return maps.map((m) => PomodoroSession.fromMap(m)).toList();
}
```

**What happens:**
1. `async` marks function as asynchronous
2. `await` pauses execution until Future completes
3. Other code can run during wait (non-blocking)
4. Returns `Future<T>` instead of `T`

**Calling async functions:**

```dart
// ✅ In async function - use await
Future<void> _loadStatistics() async {
  final stats = await _pomodoroService.getStatistics();  // Wait
  setState(() {
    _todayWorkSessions = stats['todayWorkSessions'];
  });
}

// ❌ Without await - doesn't wait!
void _loadStatistics() {
  _pomodoroService.getStatistics();  // Returns Future immediately
  setState(() {
    _todayWorkSessions = ???;  // Not loaded yet!
  });
}
```

### 4. Factory Constructors

```dart
factory PomodoroSession.fromMap(Map<String, dynamic> map) {
  return PomodoroSession(
    id: map['id'] as int?,
    type: map['type'] as String,
    // ...
  );
}
```

**Why factory?**
- Doesn't always create new instance
- Can return cached objects
- Can return subclass instances
- Named constructor alternative

**Usage:**
```dart
final session = PomodoroSession.fromMap(databaseMap);
```

### 5. Getters

```dart
int get actualDurationMinutes {
  return endTime.difference(startTime).inMinutes;
}

// Usage (no parentheses)
print(session.actualDurationMinutes);  // Not actualDurationMinutes()
```

**Getter vs Method:**
- Getter: For computed properties (no side effects)
- Method: For actions (may have side effects)

```dart
// ✅ Good - property-like access
int get actualDurationMinutes => endTime.difference(startTime).inMinutes;

// ❌ Bad - should be getter
int calculateDuration() => endTime.difference(startTime).inMinutes;
```

### 6. JSON Serialization

```dart
class PomodoroSettings {
  Map<String, dynamic> toJson() {
    return {
      'workDuration': workDuration,
      'shortBreakDuration': shortBreakDuration,
      // ...
    };
  }

  factory PomodoroSettings.fromJson(Map<String, dynamic> json) {
    return PomodoroSettings(
      workDuration: json['workDuration'] ?? 25,  // Default if missing
      // ...
    );
  }
}
```

**Saving to SharedPreferences:**
```dart
final prefs = await SharedPreferences.getInstance();
final jsonString = json.encode(_settings.toJson());  // Map → JSON string
await prefs.setString('pomodoro_settings', jsonString);
```

**Loading from SharedPreferences:**
```dart
final prefs = await SharedPreferences.getInstance();
final jsonString = prefs.getString('pomodoro_settings');
if (jsonString != null) {
  final jsonMap = json.decode(jsonString);  // JSON string → Map
  _settings = PomodoroSettings.fromJson(jsonMap);
}
```

---

## Best Practices

### 1. Resource Management

**Always dispose resources:**

```dart
@override
void dispose() {
  _timer?.cancel();          // Cancel timer
  _tabController.dispose();  // Dispose controller
  super.dispose();           // Call parent dispose
}
```

**Why important:**
- Prevents memory leaks
- Stops background tasks
- Releases system resources

### 2. Error Handling

```dart
Future<void> _loadCounts() async {
  setState(() => _isLoading = true);
  try {
    final stats = await _pomodoroService.getStatistics();
    setState(() {
      _todayWorkSessions = stats['todayWorkSessions'] ?? 0;
      _isLoading = false;
    });
  } catch (e) {
    print('Error loading statistics: $e');
    setState(() => _isLoading = false);
    // Optional: Show error to user
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load statistics')),
      );
    }
  }
}
```

### 3. Widget Extraction

**Extract complex widgets:**

```dart
// ❌ BAD: Everything in build()
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        Container(
          // 50 lines of timer UI
        ),
        Row(
          // 30 lines of buttons
        ),
        // ...
      ],
    ),
  );
}

// ✅ GOOD: Extracted methods
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        _buildTimerDisplay(),
        _buildControlButtons(),
        _buildStatistics(),
      ],
    ),
  );
}

Widget _buildTimerDisplay() {
  // Timer UI here
}
```

Benefits:
- Easier to read
- Easier to test
- Better performance (const constructors)
- Reusable components

### 4. Const Constructors

```dart
// ✅ Use const when possible
const SizedBox(height: 16)
const Text('Hello')
const Icon(Icons.timer)

// ❌ Don't use const when values change
Text(_formatTime(_remainingSeconds))  // Changes every second
```

Why const?
- Flutter reuses widgets instead of rebuilding
- Better performance
- Lower memory usage

### 5. Null Safety Best Practices

```dart
// ✅ Use ?? for default values
final duration = json['workDuration'] ?? 25;

// ✅ Use ?. for safe navigation
_timer?.cancel();

// ✅ Use ! only when absolutely sure
final startTime = _sessionStartTime!;  // We checked it's not null

// ❌ Avoid unnecessary null checks
if (_settings != null) {  // _settings is non-nullable!
  // ...
}
```

### 6. Code Organization

**File structure:**
```
lib/
  models/
    pomodoro_session.dart      ← Data models
  services/
    pomodoro_service.dart      ← Business logic
  screens/
    pomodoro_screen.dart       ← UI
  database/
    database_helper.dart       ← Data access
```

**Class organization:**
```dart
class _PomodoroScreenState extends State<PomodoroScreen> {
  // 1. Constants
  static const int defaultDuration = 25;

  // 2. Services
  final PomodoroService _pomodoroService = PomodoroService();

  // 3. State variables
  Timer? _timer;
  int _remainingSeconds = 0;

  // 4. Lifecycle methods
  @override
  void initState() { }

  @override
  void dispose() { }

  // 5. Build method
  @override
  Widget build(BuildContext context) { }

  // 6. Widget builders (alphabetical)
  Widget _buildControlButtons() { }
  Widget _buildTimerDisplay() { }

  // 7. Helper methods (alphabetical)
  void _completeSession() { }
  String _formatTime(int seconds) { }
  void _loadStatistics() { }
  void _startTimer() { }
}
```

---

## Testing and Debugging

### Manual Testing Checklist

**Timer Functionality:**
- [ ] Start button begins countdown
- [ ] Pause button stops countdown
- [ ] Resume continues from paused time
- [ ] Stop button resets to full duration
- [ ] Timer reaches 0:00 and completes
- [ ] Completion dialog appears

**Session Types:**
- [ ] Work session is red
- [ ] Short break is green
- [ ] Long break is blue
- [ ] Type selector only works when stopped
- [ ] Duration changes when switching types

**Session Progression:**
- [ ] After work → short break
- [ ] After 4 work → long break
- [ ] After break → work
- [ ] Counter resets after long break

**Settings:**
- [ ] Sliders adjust durations
- [ ] Toggles work for auto-start
- [ ] Save button persists settings
- [ ] Settings load on app restart
- [ ] Changing settings updates timer

**Statistics:**
- [ ] Today's count updates after session
- [ ] Week's count includes today
- [ ] Focus time calculated correctly
- [ ] Pull-to-refresh works
- [ ] Home screen shows correct stats

**History:**
- [ ] Completed sessions appear in list
- [ ] Most recent first
- [ ] Correct icon/color for type
- [ ] Timestamps show relative time
- [ ] Pull-to-refresh works

### Common Issues

**Issue: Timer doesn't stop**
```dart
// ❌ Forgot to cancel
void _pauseTimer() {
  setState(() {
    _isRunning = false;
  });
  // Timer keeps running!
}

// ✅ Cancel timer
void _pauseTimer() {
  setState(() {
    _isRunning = false;
  });
  _timer?.cancel();
}
```

**Issue: Sessions not saving**
```dart
// ❌ Start time never recorded
void _startTimer() {
  _isRunning = true;
  // _sessionStartTime not set!
}

// ✅ Record start time
void _startTimer() {
  setState(() {
    _isRunning = true;
    _sessionStartTime = DateTime.now();
  });
}
```

**Issue: Settings not persisting**
```dart
// ❌ Settings changed but not saved
void _showSettingsDialog() {
  showDialog(
    context: context,
    builder: (context) => _SettingsDialog(
      settings: _settings,
      onSave: (newSettings) {
        _settings = newSettings;
        // Forgot to call _saveSettings()!
      },
    ),
  );
}

// ✅ Save to SharedPreferences
onSave: (newSettings) {
  setState(() {
    _settings = newSettings;
  });
  _saveSettings();  // Persist to storage
}
```

### Debugging Tips

**1. Print statements:**
```dart
void _startTimer() {
  print('Starting timer at ${DateTime.now()}');
  print('Duration: $_remainingSeconds seconds');
  setState(() {
    _isRunning = true;
    _sessionStartTime = DateTime.now();
  });
}
```

**2. Breakpoints in IDE:**
- Click line number gutter to set breakpoint
- Run in debug mode
- Inspect variables when breakpoint hits

**3. Flutter DevTools:**
- View widget tree
- Inspect state
- Monitor performance
- Check memory usage

**4. Database inspection:**
```dart
// Temporary debug method
Future<void> _debugPrintSessions() async {
  final sessions = await _pomodoroService.getAllSessions();
  for (var session in sessions) {
    print(session.toString());
  }
}
```

---

## Summary

### What You Built

A complete Pomodoro timer application with:
- Countdown timer with start/pause/stop
- Three session types (work, short break, long break)
- Automatic session progression
- Session tracking in SQLite database
- Statistics (today, this week)
- Session history
- Customizable settings
- Home screen integration

### Architecture Learned

- **Model-View-Service pattern**
- **Database abstraction layer**
- **Settings persistence**
- **State management**
- **Widget composition**

### Dart/Flutter Concepts Mastered

- Timer management
- DateTime operations
- Async/await patterns
- SharedPreferences
- StatefulWidget lifecycle
- TabController
- JSON serialization
- Null safety
- Factory constructors
- Getters

### Best Practices Applied

- Resource disposal
- Error handling
- Widget extraction
- Const optimization
- Code organization
- Null safety patterns

### Next Steps

To extend this feature:
1. Add notifications when session completes
2. Add sound effects
3. Add session notes/labels
4. Add charts/graphs for statistics
5. Add daily/weekly goals
6. Add session categories
7. Add data export

### Additional Resources

- [Flutter Timer documentation](https://api.flutter.dev/flutter/dart-async/Timer-class.html)
- [SharedPreferences package](https://pub.dev/packages/shared_preferences)
- [DateTime class](https://api.flutter.dev/flutter/dart-core/DateTime-class.html)
- [Pomodoro Technique](https://en.wikipedia.org/wiki/Pomodoro_Technique)

---

Congratulations! You now have a solid understanding of building timer-based applications with session tracking and statistics. This knowledge applies to many other time-tracking scenarios like exercise timers, meditation apps, study trackers, and more.

Happy coding!
