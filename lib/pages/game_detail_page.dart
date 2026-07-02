import 'package:flutter/material.dart';
import '../models/steam_game.dart';
import '../constants/app_colors.dart';
import 'avatar_detail_page.dart';

class GameDetailPage extends StatefulWidget {
  final SteamGame game;
  const GameDetailPage({super.key, required this.game});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: Text(
          widget.game.name,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapCancel: () => setState(() => _isPressed = false),
                onTapUp: (_) {
                  setState(() => _isPressed = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AvatarDetailPage(
                        imageUrl: widget.game.imageUrl,
                        gameName: widget.game.name,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: _isPressed
                        ? Border.all(color: AppColors.secondary, width: 4)
                        : Border.all(color: Colors.transparent, width: 4),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        widget.game.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.error,
                              size: 100,
                              color: Colors.grey,
                            ),
                      ),
                      if (_isHovering || _isPressed)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.zoom_in,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.game.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          'Developer:',
                          widget.game.developer ?? 'N/A',
                          AppColors.primary,
                          AppColors.textSecondary,
                        ),
                        _buildInfoRow(
                          'Publisher:',
                          widget.game.publisher ?? 'N/A',
                          AppColors.primary,
                          AppColors.textSecondary,
                        ),
                        _buildInfoRow(
                          'Release Date:',
                          widget.game.released ?? 'N/A',
                          AppColors.primary,
                          AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.game.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.thumb_up, color: Colors.green),
                            const SizedBox(height: 4),
                            Text(
                              widget.game.reviewsPositive ?? 'N/A',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Positive Reviews',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.thumb_down, color: Colors.red),
                            const SizedBox(height: 4),
                            Text(
                              widget.game.reviewsNegative ?? 'N/A',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Negative Reviews',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    Color labelColor,
    Color valueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: labelColor, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: valueColor)),
          ),
        ],
      ),
    );
  }
}
