/// Simple data model for an AI news article.
/// Demonstrates: Dart class, constructor, fromJson()/toJson(), named params.
class NewsArticle {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String author;
  final DateTime publishedAt;
  final String url;
  final String category;
  bool isBookmarked;

  NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.author,
    required this.publishedAt,
    required this.url,
    required this.category,
    this.isBookmarked = false,
  });

  /// Builds a NewsArticle from a JSON map returned by a REST API.
  /// Wrapped in defensive parsing so malformed/missing fields never crash the app.
  factory NewsArticle.fromJson(Map<String, dynamic> json, {String category = 'AI News'}) {
    return NewsArticle(
      id: (json['url'] ?? json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString()).toString(),
      title: (json['title'] ?? 'Untitled AI News').toString(),
      description: (json['description'] ?? json['content'] ?? 'No description available.').toString(),
      imageUrl: (json['urlToImage'] ?? json['imageUrl'] ?? '').toString(),
      source: (json['source'] is Map ? json['source']['name'] : json['source']) ?? 'Unknown Source',
      author: (json['author'] ?? 'Unknown Author').toString(),
      publishedAt: DateTime.tryParse(json['publishedAt']?.toString() ?? '') ?? DateTime.now(),
      url: (json['url'] ?? '').toString(),
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'source': source,
      'author': author,
      'publishedAt': publishedAt.toIso8601String(),
      'url': url,
      'category': category,
    };
  }

  /// Human friendly "x time ago" string used across cards + details screen.
  String get timeAgo {
    final diff = DateTime.now().difference(publishedAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${publishedAt.day}/${publishedAt.month}/${publishedAt.year}';
  }
}
