import 'package:flutter/material.dart';
import 'pages/steam_list_page.dart';

void main() {
  runApp(const SteamApp());
}

class SteamApp extends StatelessWidget {
  const SteamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steam App',
      theme: ThemeData.dark(),
      // SteamListPage otomatis menjadi route.isFirst di stack Navigator
      home: const SteamListPage(), 
    );
  }
}
