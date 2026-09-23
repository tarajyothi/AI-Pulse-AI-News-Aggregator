import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../theme/app_theme.dart';

/// Reusable news article card used on Home, Trending, and Saved screens.
/// Includes a fade-in entrance animation and a scale "pop" on bookmark tap.
class NewsCard extends StatefulWidget {
  final NewsArticle article;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;
  final bool featured;

  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
    required this.onBookmarkTap,
    this.featured = false,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  double _bookmarkScale = 1.0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _pulseBookmark() {
    setState(() => _bookmarkScale = 1.35);
    Future.delayed(const Duration(milliseconds: 140), () {
      if (mounted) setState(() => _bookmarkScale = 1.0);
    });
    widget.onBookmarkTap();
  }

  Widget _buildImage(double height) {
    final url = widget.article.imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: url.isEmpty
          ? Container(
              height: height,
              width: double.infinity,
              color: AppColors.surfaceLight,
              child: const Icon(Icons.image_not_supported_rounded, color: AppColors.textSecondary),
            )
          : Image.network(
              url,
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: height,
                width: double.infinity,
                color: AppColors.surfaceLight,
                child: const Icon(Icons.image_not_supported_rounded, color: AppColors.textSecondary),
              ),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: height,
                  color: AppColors.surfaceLight,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(12),
          child: widget.featured ? _buildFeaturedLayout(article) : _buildStandardLayout(article),
        ),
      ),
    );
  }

  Widget _buildFeaturedLayout(NewsArticle article) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            _buildImage(160),
            Positioned(
              top: 10,
              left: 10,
              child: _categoryBadge(article.category),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: _bookmarkButton(article),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        _sourceRow(article),
      ],
    );
  }

  Widget _buildStandardLayout(NewsArticle article) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 96, child: _buildImage(90)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _categoryBadge(article.category),
              const SizedBox(height: 6),
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              _sourceRow(article),
            ],
          ),
        ),
        _bookmarkButton(article),
      ],
    );
  }

  Widget _categoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: const TextStyle(color: AppColors.primary, fontSize: 10.5, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _sourceRow(NewsArticle article) {
    return Row(
      children: [
        Flexible(
          child: Text(
            article.source,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 6),
        const Text('•', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(width: 6),
        Text(
          article.timeAgo,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _bookmarkButton(NewsArticle article) {
    return GestureDetector(
      onTap: _pulseBookmark,
      child: AnimatedScale(
        scale: _bookmarkScale,
        duration: const Duration(milliseconds: 140),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: Icon(
            article.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: article.isBookmarked ? AppColors.primary : AppColors.textSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
