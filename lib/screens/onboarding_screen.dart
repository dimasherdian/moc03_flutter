import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/preferences_service.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Steam Personal List',
      'description': 'Jelajahi koleksi game Steam favorit Anda dalam satu aplikasi yang dirancang dengan performa tinggi dan antarmuka yang memanjakan mata.',
      'iconAsset': 'assets/icon/icon.png',
      'isAsset': true,
    },
    {
      'title': 'Penyimpanan Lokal',
      'description': 'Menggunakan SharedPreferences sebagai local storage untuk menyimpan sesi login secara persisten. Ini memastikan pengalaman pengguna yang mulus tanpa harus login berulang kali.',
      'iconAsset': Icons.storage,
      'isAsset': false,
    },
    {
      'title': 'UI/UX Modern',
      'description': 'Antarmuka pengguna didesain secara khusus untuk memenuhi standar industri. Dilengkapi validasi form, manajemen state, dan komponen visual yang responsif.',
      'iconAsset': Icons.design_services,
      'isAsset': false,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      await PreferencesService().setFirstLaunch(false);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = _onboardingData[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (data['isAsset'] == true)
                          Container(
                            width: 140,
                            height: 140,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: Colors.black, width: 4),
                            ),
                            child: Image.asset(data['iconAsset'], fit: BoxFit.contain),
                          )
                        else
                          Icon(
                            data['iconAsset'] as IconData,
                            size: 140,
                            color: AppColors.primary,
                          ),
                        const SizedBox(height: 48),
                        Text(
                          data['title'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data['description'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : AppColors.iconBackground,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == _onboardingData.length - 1
                        ? 'Mulai Aplikasi'
                        : 'Selanjutnya',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
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
