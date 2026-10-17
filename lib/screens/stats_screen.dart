import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../theme/shatr_colors.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

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
        title: const Text('الإحصائيات',
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Row(children: [
                Expanded(child: _stat('انتصارات', '—', ShatrColors.accentRed)),
                const SizedBox(width: 12),
                Expanded(child: _stat('خسائر', '—', ShatrColors.textSecondary)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _stat('تعادلات', '—', ShatrColors.textSecondary)),
                const SizedBox(width: 12),
                Expanded(child: _stat('نسبة الفوز', '—', ShatrColors.accentRed)),
              ]),
              const SizedBox(height: 20),
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    const Icon(Icons.info_outline,
                        color: ShatrColors.textSecondary, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'ستظهر إحصائياتك بعد لعب أول مباراة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ShatrColors.textSecondary
                              .withValues(alpha: 0.8)),
                    ),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value, Color c) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, color: c)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: ShatrColors.textSecondary)),
        ]),
      ),
    );
  }
}
