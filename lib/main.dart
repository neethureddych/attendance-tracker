import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_student_screen.dart';
import 'api_users_screen.dart';
import 'animations_screen.dart';
import 'providers/attendance_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AttendanceProvider(),
      child: const AttendanceTrackerApp(),
    ),
  );
}

class AttendanceTrackerApp extends StatelessWidget {
  const AttendanceTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Tracker',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/students': (context) => const StudentsScreen(),
        '/add-student': (context) => const AddStudentScreen(),
        '/mark-attendance': (context) => const MarkAttendanceScreen(),
        '/attendance': (context) => const AttendanceScreen(),
        '/api': (context) => const ApiUsersScreen(),
        '/animations': (context) => const AnimationsScreen(),
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Tracker')),
      drawer: const AppDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final desktop = width >= 900;
          final tablet = width >= 600;

          return SingleChildScrollView(
            padding: EdgeInsets.all(desktop ? 32 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.indigo, Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Manage student attendance easily.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(
                          Icons.school,
                          size: 70,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Attendance Overview',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Consumer<AttendanceProvider>(
                  builder: (context, provider, child) {
                    final cards = [
                      SummaryCard(
                        title: 'Total Students',
                        value: '${provider.totalStudents}',
                        icon: Icons.people,
                        color: Colors.indigo,
                      ),
                      SummaryCard(
                        title: 'Present',
                        value: '${provider.presentStudents}',
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                      SummaryCard(
                        title: 'Absent',
                        value: '${provider.absentStudents}',
                        icon: Icons.cancel,
                        color: Colors.red,
                      ),
                      SummaryCard(
                        title: 'Attendance',
                        value:
                            '${provider.attendancePercentage.toStringAsFixed(1)}%',
                        icon: Icons.analytics,
                        color: Colors.orange,
                      ),
                    ];

                    if (tablet) {
                      return GridView.count(
                        crossAxisCount: desktop ? 4 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: desktop ? 1.5 : 1.8,
                        children: cards,
                      );
                    }

                    return Column(
                      children: cards
                          .map(
                            (card) =>
                                SizedBox(width: double.infinity, child: card),
                          )
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                QuickAction(
                  title: 'View Students',
                  icon: Icons.people,
                  onTap: () => Navigator.pushNamed(context, '/students'),
                ),
                QuickAction(
                  title: 'Mark Attendance',
                  icon: Icons.edit_calendar,
                  onTap: () => Navigator.pushNamed(context, '/mark-attendance'),
                ),
                QuickAction(
                  title: 'Attendance Report',
                  icon: Icons.bar_chart,
                  onTap: () => Navigator.pushNamed(context, '/attendance'),
                ),
                QuickAction(
                  title: 'Animation Demo',
                  icon: Icons.animation,
                  onTap: () => Navigator.pushNamed(context, '/animations'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const QuickAction({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Attendance Tracker',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _item(context, 'Dashboard', Icons.dashboard, '/'),
            _item(context, 'Students', Icons.people, '/students'),
            _item(context, 'Add Student', Icons.person_add, '/add-student'),
            _item(
              context,
              'Mark Attendance',
              Icons.edit_calendar,
              '/mark-attendance',
            ),
            _item(context, 'Attendance Report', Icons.bar_chart, '/attendance'),
            _item(context, 'API Data', Icons.cloud_download, '/api'),
            _item(context, 'Animations', Icons.animation, '/animations'),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          final students = provider.attendance.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final name = students[index];
              final details = provider.studentDetails[name];
              final present = provider.attendance[name] ?? false;

              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(name[0].toUpperCase())),
                  title: Text(name),
                  subtitle: Text(
                    '${details?['rollNumber'] ?? ''} • ${details?['department'] ?? ''} • ${present ? 'Present' : 'Absent'}',
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-student'),
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class MarkAttendanceScreen extends StatelessWidget {
  const MarkAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          final students = provider.attendance.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final name = students[index];
              final present = provider.attendance[name] ?? false;

              return Card(
                child: SwitchListTile(
                  title: Text(name),
                  subtitle: Text(present ? 'Present' : 'Absent'),
                  value: present,
                  onChanged: (value) => provider.updateAttendance(name, value),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Report')),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.analytics,
                          size: 55,
                          color: Colors.indigo,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Overall Attendance',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${provider.attendancePercentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        Text(
                          '${provider.presentStudents} present out of ${provider.totalStudents} students',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: provider.attendance.entries.map((entry) {
                      return Card(
                        child: ListTile(
                          title: Text(entry.key),
                          trailing: Text(
                            entry.value ? 'Present' : 'Absent',
                            style: TextStyle(
                              color: entry.value ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ApiScreen extends StatelessWidget {
  const ApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Data')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'REST API integration will be implemented in Practical 9.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
