import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'screens/splash_screen.dart';
import 'pages/game_detail_page.dart';
import 'pages/avatar_detail_page.dart';
import 'models/steam_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steam App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.background,
          onPrimary: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/game-detail') {
          final game = settings.arguments as SteamGame;
          return MaterialPageRoute(builder: (_) => GameDetailPage(game: game));
        } else if (settings.name == '/avatar-detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => AvatarDetailPage(
              imageUrl: args['imageUrl'],
              gameName: args['gameName'],
            ),
          );
        }
        return null; // Let the system handle unknown routes
      },
    );
  }
}
