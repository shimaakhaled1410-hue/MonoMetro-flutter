import 'package:flutter/material.dart';
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
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeView(),
    BrtView(),
    HistoryView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
