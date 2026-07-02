import 'package:flutter/material.dart';
// import '../constants/app_colors.dart'; // removed because unused
import '../services/preferences_service.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';
import '../pages/steam_list_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    // Jalankan loading asynchronous selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    final prefsService = PreferencesService();
    final isFirstLaunch = await prefsService.isFirstLaunch;

    if (!mounted) return;

    if (isFirstLaunch) {
      // Pengecekan Pertama: Jika baru pertama kali dijalankan, ke Onboarding
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      // Pengecekan Kedua: Jika tidak, periksa apakah sudah login
      final isLoggedIn = await prefsService.isLoggedIn;

      if (!mounted) return;

      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SteamListPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.black, width: 4),
              ),
              child: Image.asset('assets/icon/icon.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 32),
            const Text(
              'Personal Steam List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
