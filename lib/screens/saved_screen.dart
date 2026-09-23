import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../theme/app_theme.dart';
import '../widgets/news_card.dart';
import 'news_details_screen.dart';

class SavedScreen extends StatelessWidget {
  final List<NewsArticle> savedArticles;
  final void Function(String articleId) onBookmarkTap;

  const SavedScreen({
    super.key,
    required this.savedArticles,
    required this.onBookmarkTap,
  });

  void _openDetails(BuildContext context, NewsArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailsScreen(
          article: article,
          onBookmarkTap: () => onBookmarkTap(article.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Row(
              children: [
                const Icon(Icons.bookmark_rounded, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Saved',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                if (savedArticles.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${savedArticles.length}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: savedArticles.isEmpty ? _buildEmptyState() : _buildList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      itemCount: savedArticles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final article = savedArticles[index];
        return NewsCard(
          article: article,
          onTap: () => _openDetails(context, article),
          onBookmarkTap: () => onBookmarkTap(article.id),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bookmark_border_rounded, color: AppColors.textSecondary, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              'No saved articles yet',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the bookmark icon on any article\nto save it for later.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
