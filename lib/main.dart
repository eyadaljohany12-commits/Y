import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/shatr_colors.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ShatrApp());
}

class ShatrApp extends StatelessWidget {
  const ShatrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHATR - Chess 960',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ShatrColors.background,
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: ShatrColors.accentRed,
          surface: ShatrColors.surfaceDeep,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
