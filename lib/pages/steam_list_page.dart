import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/steam_game.dart';
import '../constants/app_colors.dart';
import 'game_detail_page.dart';

class SteamListPage extends StatefulWidget {
  const SteamListPage({super.key});

  @override
  State<SteamListPage> createState() => _SteamListPageState();
}

class _SteamListPageState extends State<SteamListPage> {
  List<SteamGame> _allGames = [];
  List<SteamGame> _filteredGames = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isGridView = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSteamGames();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  String _normalizeString(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[\s\-]+'), '');
  }

  void _onSearchChanged() {
    final query = _normalizeString(_searchController.text);
    setState(() {
      _filteredGames = _allGames.where((game) {
        final normalizedGameName = _normalizeString(game.name);
        return normalizedGameName.contains(query);
      }).toList();
    });
  }

  Future<void> _fetchSteamGames() async {
    // If the user provides a different URL, replace this one.
    const String gistUrl = 'https://gist.githubusercontent.com/dimasherdian/921f52251f89d9735b8a6889b54c86c1/raw/0bc3bbd1507183dffcf0d198327be544bd49d995/steam_games.json';

    try {
      final response = await http.get(Uri.parse(gistUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> gamesList = data['games'] ?? [];

        final games = gamesList.map((app) => SteamGame.fromJson(app)).toList();
        
        setState(() {
          _allGames = games;
          _filteredGames = games;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load games: HTTP ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.steamDark,
      appBar: AppBar(
        backgroundColor: AppColors.steamLightDark,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                _isGridView ? Icons.list : Icons.grid_view,
                color: AppColors.steamBlue,
              ),
              onPressed: _toggleView,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.steamBlue))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.redAccent)))
              : _filteredGames.isEmpty
                  ? const Center(child: Text('No games found.', style: TextStyle(color: Colors.white70)))
                  : _isGridView
                      ? _buildGridView()
                      : _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _filteredGames.length,
      itemBuilder: (context, index) {
        final game = _filteredGames[index];
        return Card(
          color: AppColors.steamLightDark,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Image.network(
              game.imageUrl,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.grey),
            ),
            title: Text(
              game.name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.steamBlue),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDetailPage(game: game),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredGames.length,
      itemBuilder: (context, index) {
        final game = _filteredGames[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameDetailPage(game: game),
              ),
            );
          },
          child: Card(
            color: AppColors.steamLightDark,
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    game.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    game.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
