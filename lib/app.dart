import 'package:flutter/material.dart';

import 'package:remindly_app/pages/courses_page.dart';
import 'package:remindly_app/pages/home_page.dart';
import 'package:remindly_app/pages/task_list_page.dart';
import 'package:remindly_app/theme/app_theme.dart';

/// Root app. NavigationBar 3 destinasi sesuai spec 02.
class RemindlyApp extends StatefulWidget {
  const new({super.key});

  @override
  State<RemindlyApp> createState() => _RemindlyAppState();
}

class _RemindlyAppState extends State<RemindlyApp> {
  int _index = 0;

  static const _pages = <Widget>[HomePage(), TaskListPage(), CoursesPage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remindly',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: Scaffold(
        body: _pages[_index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_outlined),
              selectedIcon: Icon(Icons.list),
              label: 'Tugas',
            ),
            NavigationDestination(
              icon: Icon(Icons.book_outlined),
              selectedIcon: Icon(Icons.book),
              label: 'Matkul',
            ),
          ],
        ),
      ),
    );
  }
}
