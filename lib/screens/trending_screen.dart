import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../theme/app_theme.dart';
import '../widgets/news_card.dart';
import '../widgets/category_chip.dart';
import 'news_details_screen.dart';

class TrendingScreen extends StatefulWidget {
  final List<NewsArticle> articles;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function() onRefresh;
  final void Function(String articleId) onBookmarkTap;

  const TrendingScreen({
    super.key,
    required this.articles,
    required this.isLoading,
    required this.errorMessage,
    required this.onRefresh,
    required this.onBookmarkTap,
  });

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  String _selectedCategory = 'All';

  static const List<String> _categories = [
    'All',
    'Generative AI',
    'AI Research',
    'Robotics',
    'AI Tools',
    'AI Startups',
    'Big Tech',
  ];

  List<NewsArticle> get _filtered {
    // "Trending" = most recently published first, optionally filtered by category.
    final list = widget.articles.where((a) {
      return _selectedCategory == 'All' || a.category == _selectedCategory;
    }).toList();
    list.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return list;
  }

  void _openDetails(NewsArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailsScreen(
          article: article,
          onBookmarkTap: () => widget.onBookmarkTap(article.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: widget.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Row(
                  children: const [
                    Icon(Icons.trending_up_rounded, color: AppColors.primary, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Trending',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return CategoryChip(
                      label: category,
                      selected: _selectedCategory == category,
                      onTap: () => setState(() => _selectedCategory = category),
                    );
                  },
                ),
              ),
            ),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (widget.errorMessage != null && widget.articles.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_rounded, color: AppColors.error, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Unable to load trending news',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: widget.onRefresh,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final filtered = _filtered;

    if (filtered.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'No trending stories in this category yet.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final article = filtered[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: NewsCard(
              article: article,
              onTap: () => _openDetails(article),
              onBookmarkTap: () => widget.onBookmarkTap(article.id),
            ),
          );
        },
        childCount: filtered.length,
      ),
    );
  }
}
