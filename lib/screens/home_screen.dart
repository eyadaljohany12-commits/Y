import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../theme/shatr_colors.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.7, -0.6),
            radius: 1.5,
            colors: [Color(0xFF1A0A0D), ShatrColors.background],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                const Text(
                  'شطر',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w800,
                    color: ShatrColors.textPrimary,
                    letterSpacing: -2,
                  ),
                ),
                const Text(
                  'CHESS 960',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ShatrColors.accentRed,
                    letterSpacing: 6,
                  ),
                ),
                const Spacer(flex: 2),
                _GlassButton(
                  label: 'لعبة جديدة',
                  icon: Icons.play_arrow_rounded,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const GameScreen())),
                ),
                const SizedBox(height: 16),
                _GlassButton(
                  label: 'الإحصائيات',
                  icon: Icons.bar_chart_rounded,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const StatsScreen())),
                ),
                const SizedBox(height: 16),
                _GlassButton(
                  label: 'الإعدادات',
                  icon: Icons.settings_rounded,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen())),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GlassButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<_GlassButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _s = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp: (_) {
        _c.reverse();
        widget.onTap();
      },
      onTapCancel: () => _c.reverse(),
      child: ScaleTransition(
        scale: _s,
        child: GlassCard(
          opacity: 0.06,
          blur: 15,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            child: Row(
              children: [
                Icon(widget.icon, color: ShatrColors.accentRed, size: 24),
                const SizedBox(width: 16),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ShatrColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ShatrColors.textSecondary.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
