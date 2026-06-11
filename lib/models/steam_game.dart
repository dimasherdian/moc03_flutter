class SteamGame {
  final int appid;
  final String name;
  final String description;
  final String? developer;
  final String? publisher;
  final String? released;
  final String? reviewsPositive;
  final String? reviewsNegative;
  final String imageUrl;

  SteamGame({
    required this.appid,
    required this.name,
    required this.description,
    this.developer,
    this.publisher,
    this.released,
    this.reviewsPositive,
    this.reviewsNegative,
    required this.imageUrl,
  });

  factory SteamGame.fromJson(Map<String, dynamic> json) {
    final appId = json['appid'] is int ? json['appid'] : int.tryParse(json['appid'].toString()) ?? 0;
    return SteamGame(
      appid: appId,
      name: json['name']?.toString() ?? 'Unknown',
      description: json['description']?.toString() ?? 'No description available',
      developer: json['developer']?.toString(),
      publisher: json['publisher']?.toString(),
      released: json['released']?.toString(),
      reviewsPositive: json['reviews_positive']?.toString(),
      reviewsNegative: json['reviews_negative']?.toString(),
      imageUrl: 'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/$appId/header.jpg',
    );
  }
}
