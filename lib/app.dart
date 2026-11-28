import 'package:flutter/material.dart';

import 'package:remindly_app/pages/courses_page.dart';
import 'package:remindly_app/pages/home_page.dart';
import 'package:remindly_app/pages/task_list_page.dart';
import 'package:remindly_app/theme/app_theme.dart';
import 'package:remindly_app/theme/theme_mode_scope.dart';

class RemindlyApp extends StatefulWidget {
  const new({super.key});

  @override
  State<RemindlyApp> createState() => _RemindlyAppState();
}

class _RemindlyAppState extends State<RemindlyApp> {
  final _tema = ThemeModeController();
  int _index = 0;

  @override
  void dispose() {
    _tema.dispose();
    super.dispose();
  }

  static const _pages = <Widget>[HomePage(), TaskListPage(), CoursesPage()];

  static const _pageIds = <String>[
    'halaman-beranda',
    'halaman-tugas',
    'halaman-matkul',
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _tema,
      builder: (context, _) {
        return AppThemeScope(
          controller: _tema,
          child: MaterialApp(
            title: 'Remindly',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: _tema.mode,
            home: Scaffold(
              body: Semantics(
                identifier: _pageIds[_index],
                container: true,
                explicitChildNodes: true,
                child: _pages[_index],
              ),
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
          ),
        );
      },
    );
  }
}
