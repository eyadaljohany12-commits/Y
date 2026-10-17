import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../theme/shatr_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _sound = true;
  bool _haptic = true;
  double _speed = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: ShatrColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('الإعدادات',
            style: TextStyle(color: ShatrColors.textPrimary)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ShatrColors.background, Color(0xFF1A0A0D)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GlassCard(
                child: Column(children: [
                  SwitchListTile(
                    title: const Text('الأصوات',
                        style: TextStyle(color: ShatrColors.textPrimary)),
                    value: _sound,
                    activeColor: ShatrColors.accentRed,
                    onChanged: (v) => setState(() => _sound = v),
                  ),
                  const Divider(color: Colors.white12),
                  SwitchListTile(
                    title: const Text('الاهتزاز',
                        style: TextStyle(color: ShatrColors.textPrimary)),
                    value: _haptic,
                    activeColor: ShatrColors.accentRed,
                    onChanged: (v) => setState(() => _haptic = v),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('سرعة الأنيميشن',
                          style: TextStyle(color: ShatrColors.textPrimary)),
                      Slider(
                        value: _speed,
                        activeColor: ShatrColors.accentRed,
                        onChanged: (v) => setState(() => _speed = v),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
