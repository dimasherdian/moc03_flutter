import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/steam_game.dart';
import '../constants/app_colors.dart';
import '../services/preferences_service.dart';
import '../screens/login_screen.dart';
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
  String _currentSort = 'A-Z';
  final TextEditingController _searchController = TextEditingController();

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateFormat("d MMM, yyyy").parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  void _applyFiltersAndSort() {
    final query = _normalizeString(_searchController.text);
    _filteredGames = _allGames.where((game) {
      final normalizedGameName = _normalizeString(game.name);
      return normalizedGameName.contains(query);
    }).toList();

    _filteredGames.sort((a, b) {
      if (_currentSort == 'A-Z') {
        return a.name.compareTo(b.name);
      } else if (_currentSort == 'Z-A') {
        return b.name.compareTo(a.name);
      } else if (_currentSort == 'Release Date') {
        final dateA = _parseDate(a.released);
        final dateB = _parseDate(b.released);
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA); // Terbaru (newest) di atas
      } else if (_currentSort == 'Positive Review') {
        final int aPos =
            int.tryParse(
              a.reviewsPositive?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0',
            ) ??
            0;
        final int bPos =
            int.tryParse(
              b.reviewsPositive?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0',
            ) ??
            0;
        return bPos.compareTo(aPos);
      } else if (_currentSort == 'Negative Review') {
        final int aNeg =
            int.tryParse(
              a.reviewsNegative?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0',
            ) ??
            0;
        final int bNeg =
            int.tryParse(
              b.reviewsNegative?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0',
            ) ??
            0;
        return bNeg.compareTo(aNeg);
      }
      return 0;
    });
  }

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
    setState(() {
      _applyFiltersAndSort();
    });
  }

  Future<void> _fetchSteamGames() async {
    // If the user provides a different URL, replace this one.
    const String gistUrl =
        'https://gist.githubusercontent.com/dimasherdian/921f52251f89d9735b8a6889b54c86c1/raw/0bc3bbd1507183dffcf0d198327be544bd49d995/steam_games.json';

    try {
      final response = await http.get(Uri.parse(gistUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> gamesList = data['games'] ?? [];

        final games = gamesList.map((app) => SteamGame.fromJson(app)).toList();

        setState(() {
          _allGames = games;
          _applyFiltersAndSort();
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                _isGridView ? Icons.list : Icons.grid_view,
                color: AppColors.primary,
              ),
              onPressed: _toggleView,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primary),
            tooltip: 'Logout',
            onPressed: () async {
              final prefs = PreferencesService();
              await prefs.setLoggedIn(false);
              
              if (!context.mounted) return;
              
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.background,
            child: Row(
              children: [
                const Text(
                  'Sort by:',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentSort,
                        isExpanded: true,
                        dropdownColor: AppColors.secondary,
                        style: const TextStyle(color: AppColors.textPrimary),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primary,
                        ),
                        items:
                            [
                              'A-Z',
                              'Z-A',
                              'Release Date',
                              'Positive Review',
                              'Negative Review',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _currentSort = newValue;
                              _applyFiltersAndSort();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  )
                : _filteredGames.isEmpty
                ? const Center(
                    child: Text(
                      'No games found.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : _isGridView
                ? _buildGridView()
                : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _filteredGames.length,
      itemBuilder: (context, index) {
        final game = _filteredGames[index];
        return Card(
          color: AppColors.secondary,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Image.network(
              game.imageUrl,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.grey),
            ),
            title: Text(
              game.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
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
            color: AppColors.secondary,
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    game.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    game.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
