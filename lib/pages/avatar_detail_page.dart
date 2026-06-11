import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AvatarDetailPage extends StatelessWidget {
  final String imageUrl;
  final String gameName;

  const AvatarDetailPage({
    super.key,
    required this.imageUrl,
    required this.gameName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.steamDark,
      appBar: AppBar(
        backgroundColor: AppColors.steamLightDark,
        title: Text(gameName, style: const TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.steamBlue),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    imageUrl,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.steamBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // CRITICAL REQUIREMENT: Return directly to Page 1
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    'Kembali ke Daftar',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}