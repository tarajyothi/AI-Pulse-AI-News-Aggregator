import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../theme/app_theme.dart';

/// Secondary screen (NOT one of the 4 main pages).
/// Opened via Navigator.push() from a NewsCard tap; closed with Navigator.pop().
class NewsDetailsScreen extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onBookmarkTap;

  const NewsDetailsScreen({
    super.key,
    required this.article,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
            expandedHeight: 260,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _RoundIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StatefulBuilder(
                  builder: (context, setLocalState) {
                    return _RoundIconButton(
                      icon: article.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: article.isBookmarked ? AppColors.primary : AppColors.textPrimary,
                      onTap: () {
                        onBookmarkTap();
                        setLocalState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: article.imageUrl.isEmpty
                  ? Container(color: AppColors.surfaceLight)
                  : Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: AppColors.surfaceLight),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      article.category,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.surfaceLight,
                        child: Icon(Icons.newspaper_rounded, size: 14, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${article.source} • ${article.author}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        article.timeAgo,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 24),
                  Text(
                    article.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening: ${article.url}')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Read Full Article', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_outward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.7),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color ?? AppColors.textPrimary, size: 20),
      ),
    );
  }
}
