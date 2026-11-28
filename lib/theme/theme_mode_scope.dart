import 'package:flutter/material.dart';

class ThemeModeController extends ChangeNotifier {
  ThemeMode mode = ThemeMode.light;

  void toggle() {
    mode = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class AppThemeScope extends InheritedNotifier<ThemeModeController> {
  const new({
    required ThemeModeController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static ThemeModeController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppThemeScope>()
        ?.notifier;
  }
}

class ThemeModeButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppThemeScope.maybeOf(context);
    if (controller == null) {
      return const SizedBox.shrink();
    }
    final gelap = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: gelap ? 'Mode terang' : 'Mode gelap',
      onPressed: controller.toggle,
      icon: Icon(gelap ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
    );
  }
}
