import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/pomodoro_session.dart';
import '../services/pomodoro_service.dart';

/// PomodoroScreen
/// Complete Pomodoro timer implementation with history and statistics
class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> with TickerProviderStateMixin {
  final PomodoroService _pomodoroService = PomodoroService();

  // Timer state
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  DateTime? _sessionStartTime;

  // Session management
  String _currentSessionType = 'work'; // 'work', 'short_break', 'long_break'
  int _completedWorkSessions = 0;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSettings();
    _loadStatistics();
    _loadRecentSessions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  /// Load Pomodoro settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('pomodoro_settings');

    if (settingsJson != null) {
      final Map<String, dynamic> settingsMap = json.decode(settingsJson);
      _settings = PomodoroSettings.fromJson(settingsMap);
    } else {
      _settings = PomodoroSettings();
    }

    // Initialize timer with work duration
    _remainingSeconds = _settings.workDuration * 60;

    setState(() {
      _isLoading = false;
    });
  }

  /// Save Pomodoro settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pomodoro_settings', json.encode(_settings.toJson()));
  }

  /// Load statistics
  Future<void> _loadStatistics() async {
    final stats = await _pomodoroService.getStatistics();
    setState(() {
      _todayWorkSessions = stats['todayWorkSessions'] ?? 0;
      _todayFocusTime = stats['todayMinutes'] ?? 0;
      _weekWorkSessions = stats['weekWorkSessions'] ?? 0;
      _weekFocusTime = stats['weekMinutes'] ?? 0;
    });
  }

  /// Load recent sessions
  Future<void> _loadRecentSessions() async {
    final sessions = await _pomodoroService.getAllSessions();
    setState(() {
      _recentSessions = sessions.take(10).toList();
    });
  }

  /// Start the timer
  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _sessionStartTime = DateTime.now();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _completeSession();
        }
      });
    });
  }

  /// Pause the timer
  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  /// Stop the timer (reset without saving)
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _sessionStartTime = null;
      _remainingSeconds = _getDurationForType(_currentSessionType) * 60;
    });
  }

  /// Complete the current session
  Future<void> _completeSession() async {
    _timer?.cancel();

    if (_sessionStartTime != null) {
      // Save session to database
      final session = PomodoroSession(
        type: _currentSessionType,
        durationMinutes: _getDurationForType(_currentSessionType),
        startTime: _sessionStartTime!,
        endTime: DateTime.now(),
        wasCompleted: true,
      );

      await _pomodoroService.createSession(session);

      // Update work session counter
      if (_currentSessionType == 'work') {
        _completedWorkSessions++;
      }

      // Reload statistics and history
      await _loadStatistics();
      await _loadRecentSessions();
    }

    setState(() {
      _isRunning = false;
      _sessionStartTime = null;
    });

    // Show completion dialog and suggest next session
    if (mounted) {
      _showCompletionDialog();
    }
  }

  /// Show session completion dialog
  void _showCompletionDialog() {
    String nextSessionType = _getNextSessionType();
    String message = _currentSessionType == 'work'
        ? 'Great work! Time for a break.'
        : 'Break complete! Ready for another work session?';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session Complete!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _switchSessionType(_currentSessionType); // Stay on same type
            },
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _switchSessionType(nextSessionType);
              if (_settings.autoStartPomodoros && nextSessionType == 'work') {
                _startTimer();
              } else if (_settings.autoStartBreaks && nextSessionType != 'work') {
                _startTimer();
              }
            },
            child: Text('Start ${_getTypeDisplayName(nextSessionType)}'),
          ),
        ],
      ),
    );
  }

  /// Get next session type based on completed work sessions
  String _getNextSessionType() {
    if (_currentSessionType == 'work') {
      // After work, take a break
      if (_completedWorkSessions >= _settings.sessionsBeforeLongBreak) {
        _completedWorkSessions = 0;
        return 'long_break';
      } else {
        return 'short_break';
      }
    } else {
      // After break, return to work
      return 'work';
    }
  }

  /// Switch session type
  void _switchSessionType(String type) {
    setState(() {
      _currentSessionType = type;
      _remainingSeconds = _getDurationForType(type) * 60;
      _isRunning = false;
      _sessionStartTime = null;
    });
    _timer?.cancel();
  }

  /// Get duration for session type
  int _getDurationForType(String type) {
    switch (type) {
      case 'work':
        return _settings.workDuration;
      case 'short_break':
        return _settings.shortBreakDuration;
      case 'long_break':
        return _settings.longBreakDuration;
      default:
        return _settings.workDuration;
    }
  }

  /// Get display name for session type
  String _getTypeDisplayName(String type) {
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

  /// Format seconds to MM:SS
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Show settings dialog
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Timer'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTimerTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  /// Build timer tab
  Widget _buildTimerTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadStatistics();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Session type selector
            _buildSessionTypeSelector(),
            const SizedBox(height: 32),

            // Timer display
            _buildTimerDisplay(),
            const SizedBox(height: 32),

            // Control buttons
            _buildControlButtons(),
            const SizedBox(height: 32),

            // Session counter
            _buildSessionCounter(),
            const SizedBox(height: 32),

            // Statistics
            _buildStatistics(),
          ],
        ),
      ),
    );
  }

  /// Build session type selector
  Widget _buildSessionTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildTypeButton('work', 'Work', Colors.red),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildTypeButton('short_break', 'Short Break', Colors.green),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildTypeButton('long_break', 'Long Break', Colors.blue),
        ),
      ],
    );
  }

  /// Build type selection button
  Widget _buildTypeButton(String type, String label, Color color) {
    bool isSelected = _currentSessionType == type;

    return ElevatedButton(
      onPressed: _isRunning ? null : () => _switchSessionType(type),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  /// Build timer display
  Widget _buildTimerDisplay() {
    Color timerColor;
    switch (_currentSessionType) {
      case 'work':
        timerColor = Colors.red;
        break;
      case 'short_break':
        timerColor = Colors.green;
        break;
      case 'long_break':
        timerColor = Colors.blue;
        break;
      default:
        timerColor = Colors.grey;
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
              _formatTime(_remainingSeconds),
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: timerColor,
                fontFeatureSettings: const [FontFeature.tabularFigures()],
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

  /// Build control buttons
  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Start/Pause button
        ElevatedButton.icon(
          onPressed: _isRunning ? _pauseTimer : _startTimer,
          icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 32),
          label: Text(
            _isRunning ? 'Pause' : 'Start',
            style: const TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isRunning ? Colors.orange : Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Stop button
        ElevatedButton.icon(
          onPressed: (_isRunning || _remainingSeconds != _getDurationForType(_currentSessionType) * 60)
              ? _stopTimer
              : null,
          icon: const Icon(Icons.stop, size: 32),
          label: const Text('Stop', style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  /// Build session counter
  Widget _buildSessionCounter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.checklist, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            'Session ${_completedWorkSessions + 1} of ${_settings.sessionsBeforeLongBreak}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// Build statistics section
  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Today',
                '$_todayWorkSessions sessions',
                '${_todayFocusTime}m focus',
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'This Week',
                '$_weekWorkSessions sessions',
                '${_weekFocusTime}m focus',
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build stat card
  Widget _buildStatCard(String title, String sessions, String time, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sessions,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// Build history tab
  Widget _buildHistoryTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadRecentSessions();
      },
      child: _recentSessions.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No sessions yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Complete your first Pomodoro session!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
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

  /// Build session history card
  Widget _buildSessionCard(PomodoroSession session) {
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
        title: Text(
          session.typeDisplayName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${session.durationMinutes} minutes • ${_formatDateTime(session.createdAt)}',
        ),
        trailing: session.wasCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.red),
      ),
    );
  }

  /// Format DateTime for display
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }
}

/// Settings Dialog Widget
class _SettingsDialog extends StatefulWidget {
  final PomodoroSettings settings;
  final Function(PomodoroSettings) onSave;

  const _SettingsDialog({
    required this.settings,
    required this.onSave,
  });

  @override
  State<_SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<_SettingsDialog> {
  late PomodoroSettings _settings;

  @override
  void initState() {
    super.initState();
    // Create a copy of settings
    _settings = PomodoroSettings(
      workDuration: widget.settings.workDuration,
      shortBreakDuration: widget.settings.shortBreakDuration,
      longBreakDuration: widget.settings.longBreakDuration,
      sessionsBeforeLongBreak: widget.settings.sessionsBeforeLongBreak,
      autoStartBreaks: widget.settings.autoStartBreaks,
      autoStartPomodoros: widget.settings.autoStartPomodoros,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pomodoro Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Work duration
            Text('Work Duration: ${_settings.workDuration} minutes'),
            Slider(
              value: _settings.workDuration.toDouble(),
              min: 15,
              max: 60,
              divisions: 9,
              label: '${_settings.workDuration}m',
              onChanged: (value) {
                setState(() {
                  _settings.workDuration = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),

            // Short break duration
            Text('Short Break: ${_settings.shortBreakDuration} minutes'),
            Slider(
              value: _settings.shortBreakDuration.toDouble(),
              min: 3,
              max: 15,
              divisions: 12,
              label: '${_settings.shortBreakDuration}m',
              onChanged: (value) {
                setState(() {
                  _settings.shortBreakDuration = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),

            // Long break duration
            Text('Long Break: ${_settings.longBreakDuration} minutes'),
            Slider(
              value: _settings.longBreakDuration.toDouble(),
              min: 10,
              max: 30,
              divisions: 4,
              label: '${_settings.longBreakDuration}m',
              onChanged: (value) {
                setState(() {
                  _settings.longBreakDuration = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),

            // Sessions before long break
            Text('Sessions before long break: ${_settings.sessionsBeforeLongBreak}'),
            Slider(
              value: _settings.sessionsBeforeLongBreak.toDouble(),
              min: 2,
              max: 8,
              divisions: 6,
              label: '${_settings.sessionsBeforeLongBreak}',
              onChanged: (value) {
                setState(() {
                  _settings.sessionsBeforeLongBreak = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),

            // Auto-start options
            SwitchListTile(
              title: const Text('Auto-start breaks'),
              value: _settings.autoStartBreaks,
              onChanged: (value) {
                setState(() {
                  _settings.autoStartBreaks = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Auto-start work sessions'),
              value: _settings.autoStartPomodoros,
              onChanged: (value) {
                setState(() {
                  _settings.autoStartPomodoros = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_settings);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
