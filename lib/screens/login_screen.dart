import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/preferences_service.dart';
import '../pages/steam_list_page.dart';
import 'splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      // Simpan status login dan username sesuai materi sesi 12
      final service = PreferencesService();
      await service.setLoggedIn(true);
      await service.saveUserName(_usernameController.text.trim());

      if (!mounted) return;

      // Arahkan ke Steam List Page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SteamListPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Validasi gagal! Silakan periksa kembali input Anda.'),
          backgroundColor: AppColors.negative,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildFieldLabel(String label, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          children: isRequired
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: AppColors.negative,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.lock_person,
                      size: 100,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Center(
                    child: Text(
                      'Silakan Login',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildFieldLabel('Username', true),
                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Username',
                      hintStyle: const TextStyle(color: AppColors.textSecondary),
                      helperText: 'Min. 4 karakter, huruf & angka (tanpa spasi)',
                      helperStyle: const TextStyle(color: AppColors.textSecondary),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.iconBackground),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.negative),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.negative, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username wajib diisi!';
                      }
                      if (value.trim().length < 4) {
                        return 'Username minimal 4 karakter!';
                      }
                      // Hanya memperbolehkan huruf dan angka (tanpa spasi)
                      if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                        return 'Username hanya boleh berisi huruf dan angka tanpa spasi!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFieldLabel('Password', true),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Password',
                      hintStyle: const TextStyle(color: AppColors.textSecondary),
                      helperText: 'Min. 6 karakter',
                      helperStyle: const TextStyle(color: AppColors.textSecondary),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: AppColors.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.iconBackground),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.negative),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.negative, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi!';
                      }
                      if (value.length < 6) {
                        return 'Password minimal 6 karakter!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
