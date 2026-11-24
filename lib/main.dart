import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/study_task.dart';
import 'services/task_repository.dart';
import 'screens/health_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/tasks_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(const StudentPortalApp());
  } catch (error) {
    runApp(MaterialApp(home: Scaffold(body: SafeArea(child: Center(
      child: Padding(padding: const EdgeInsets.all(24),
        child: SelectableText('Не вдалося підключитися до Firebase.\n'
          'Запустіть flutterfire configure для створення firebase_options.dart.\n\n$error')),
    )))));
  }
}

class StudentPortalApp extends StatelessWidget {
  const StudentPortalApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Dracula Academia',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snapshot.data == null ? const LoginScreen() : const PortalShell();
      },
    ),
  );
}

class PortalShell extends StatefulWidget {
  const PortalShell({super.key});
  @override
  State<PortalShell> createState() => _PortalShellState();
}

class _PortalShellState extends State<PortalShell> {
  int _tab = 0;
  Set<int> _completedHabits = {};

  String get _todayKey {
    final now = DateTime.now();
    return 'habits_${now.year}_${now.month}_${now.day}';
  }

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final habitValues = prefs.getStringList(_todayKey) ?? [];
    if (!mounted) return;
    setState(() {
      _completedHabits = habitValues.map(int.tryParse).whereType<int>().toSet();
    });
  }

  Future<void> _toggleHabit(int index, bool selected) async {
    setState(() {
      if (selected) { _completedHabits.add(index); } else { _completedHabits.remove(index); }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_todayKey, _completedHabits.map((i) => '$i').toList());
  }

  void _navigate(int next) => setState(() => _tab = next);

  @override
  Widget build(BuildContext context) {
    final pages = [
      StreamBuilder<List<StudyTask>>(
        stream: TaskRepository.instance.watchTasks(),
        builder: (context, snapshot) {
          final tasks = snapshot.data ?? [];
          return HomeScreen(onNavigate: _navigate,
            completedTasks: tasks.where((task) => task.completed).length,
            totalTasks: tasks.length);
        },
      ),
      const TasksScreen(),
      const ProfileScreen(),
      HealthScreen(completed: _completedHabits, onToggle: _toggleHabit),
    ];
    return PopScope(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _tab != 0) _navigate(0);
      },
      child: Scaffold(
        body: SafeArea(child: IndexedStack(index: _tab, children: pages)),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(color: Palette.panel, border: Border(top: BorderSide(color: Palette.border))),
          child: NavigationBar(
            height: 74,
            backgroundColor: Palette.panel,
            indicatorColor: Palette.wine,
            labelTextStyle: const WidgetStatePropertyAll(TextStyle(fontFamily: 'Roboto', fontSize: 11, color: Palette.parchment)),
            selectedIndex: _tab,
            onDestinationSelected: _navigate,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.castle_outlined), selectedIcon: Icon(Icons.castle, color: Palette.parchment), label: 'Замок'),
              NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book, color: Palette.parchment), label: 'Справи'),
              NavigationDestination(icon: Icon(Icons.badge_outlined), selectedIcon: Icon(Icons.badge, color: Palette.parchment), label: 'Профіль'),
              NavigationDestination(icon: Icon(Icons.local_fire_department_outlined), selectedIcon: Icon(Icons.local_fire_department, color: Palette.parchment), label: 'Ритуали'),
            ],
          ),
        ),
      ),
    );
  }
}
