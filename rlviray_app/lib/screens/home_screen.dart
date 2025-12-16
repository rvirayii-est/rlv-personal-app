import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/note_service.dart';
import '../services/todo_service.dart';
import '../services/pomodoro_service.dart';
import 'user_list_screen.dart';
import 'note_list_screen.dart';
import 'todo_list_screen.dart';
import 'pomodoro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  final NoteService _noteService = NoteService();
  final TodoService _todoService = TodoService();
  final PomodoroService _pomodoroService = PomodoroService();

  int _userCount = 0;
  int _noteCount = 0;
  int _todoCount = 0;
  int _pendingTodoCount = 0;
  int _pomodoroTodaySessions = 0;
  int _pomodoroTodayFocusTime = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    setState(() => _isLoading = true);
    try {
      final userCount = await _userService.getUserCount();
      final noteCount = await _noteService.getNoteCount();
      final todoCount = await _todoService.getTodoCount();
      final pendingCount = await _todoService.getPendingCount();
      final pomodoroTodaySessions = await _pomodoroService.getTodayWorkSessionCount();
      final pomodoroTodayFocusTime = await _pomodoroService.getTodayFocusTime();
      setState(() {
        _userCount = userCount;
        _noteCount = noteCount;
        _todoCount = todoCount;
        _pendingTodoCount = pendingCount;
        _pomodoroTodaySessions = pomodoroTodaySessions;
        _pomodoroTodayFocusTime = pomodoroTodayFocusTime;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading counts: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RLViray App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCounts,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Welcome to RLViray App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'SQLite Offline Database Example',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildStatCard(
                    title: 'Users',
                    count: _userCount,
                    icon: Icons.people,
                    color: Colors.blue,
                    onTap: () => _navigateToUsers(),
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Notes',
                    count: _noteCount,
                    icon: Icons.note,
                    color: Colors.green,
                    onTap: () => _navigateToNotes(),
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Todos',
                    count: _todoCount,
                    icon: Icons.check_circle,
                    color: Colors.purple,
                    onTap: () => _navigateToTodos(),
                    subtitle: '$_pendingTodoCount pending',
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Pomodoro',
                    count: _pomodoroTodaySessions,
                    icon: Icons.timer,
                    color: Colors.orange,
                    onTap: () => _navigateToPomodoro(),
                    subtitle: '$_pomodoroTodayFocusTime minutes today',
                  ),
                  const SizedBox(height: 32),
                  _buildFeatureList(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count ${title.toLowerCase()}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              icon: Icons.storage,
              title: 'SQLite Database',
              subtitle: 'Offline local storage',
            ),
            _buildFeatureItem(
              icon: Icons.sync,
              title: 'CRUD Operations',
              subtitle: 'Create, Read, Update, Delete',
            ),
            _buildFeatureItem(
              icon: Icons.architecture,
              title: 'Clean Architecture',
              subtitle: 'Organized code structure',
            ),
            _buildFeatureItem(
              icon: Icons.security,
              title: 'Data Persistence',
              subtitle: 'Data saved locally',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToUsers() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserListScreen()),
    );
    _loadCounts();
  }

  void _navigateToNotes() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoteListScreen()),
    );
    _loadCounts();
  }

  void _navigateToTodos() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TodoListScreen()),
    );
    _loadCounts();
  }

  void _navigateToPomodoro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PomodoroScreen()),
    );
    _loadCounts();
  }
}
