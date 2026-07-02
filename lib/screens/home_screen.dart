import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/preferences_service.dart';
import 'login_screen.dart';
import 'splash_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 100, color: AppColors.primary),
            const SizedBox(height: 24),
            const Text(
              'Selamat Datang di Home Screen',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Anda telah berhasil login.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () async {
                // Ubah status is_logged_in menjadi false
                await PreferencesService().setLoggedIn(false);

                if (!context.mounted) return;

                // Tendang user kembali ke Login Screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: AppColors.textPrimary),
              label: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await PreferencesService().resetAllPreferences();
          if (!context.mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SplashScreen()),
            (Route<dynamic> route) => false,
          );
        },
        backgroundColor: Colors.amber,
        tooltip: 'Cheat Menu / Reset',
        child: const Icon(Icons.refresh, color: AppColors.background),
      ),
    );
  }
}
