import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/features/settings/widgets/appearance_card.dart';
import 'package:metro/features/settings/widgets/language_card.dart';
import 'package:metro/features/settings/widgets/legal_card.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings_title'.tr)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: const [
          AppearanceCard(),
          SizedBox(height: 24),
          LanguageCard(),
          SizedBox(height: 24),
          LegalCard(),
        ],
      ),
    );
  }
}
