import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/app_snackbar.dart';
import 'package:metro/features/brt/views/brt_view.dart';
import 'package:metro/features/history/views/history_view.dart';
import 'package:metro/features/navigation/widgets/app_bottom_nav_bar.dart';
import 'package:metro/features/planner/views/home_view.dart';
import 'package:metro/features/settings/views/settings_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  static const Duration _exitWindow = Duration(seconds: 2);

  int _currentIndex = 0;
  DateTime? _lastBackPress;

  static const List<Widget> _screens = [
    HomeView(),
    BrtView(),
    HistoryView(),
    SettingsView(),
  ];

  void _handleBack(bool didPop, Object? result) {
    if (didPop) return;

    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return;
    }

    final now = DateTime.now();
    final last = _lastBackPress;
    if (last != null && now.difference(last) < _exitWindow) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPress = now;
    AppSnackbar.show(
      title: 'metro_title'.tr,
      message: 'press_back_again'.tr,
      duration: _exitWindow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handleBack,
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}