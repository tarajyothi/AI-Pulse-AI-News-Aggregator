import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/news_model.dart';
import 'services/news_api_service.dart';
import 'widgets/bottom_nav.dart';
import 'screens/home_screen.dart';
import 'screens/trending_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const AiPulseApp());
}

class AiPulseApp extends StatelessWidget {
  const AiPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Pulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const RootShell(),
    );
  }
}

/// Owns the 4 main pages + the single shared source of truth for the
/// article list / bookmark state, so Home, Trending, and Saved all stay
/// in sync using plain StatefulWidget/setState (no external state package).
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;
  final NewsApiService _apiService = NewsApiService();

  List<NewsArticle> _articles = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final articles = await _apiService.fetchAiNews();
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _toggleBookmark(String articleId) {
    setState(() {
      final index = _articles.indexWhere((a) => a.id == articleId);
      if (index != -1) {
        _articles[index].isBookmarked = !_articles[index].isBookmarked;
      }
    });
  }

  List<NewsArticle> get _savedArticles =>
      _articles.where((a) => a.isBookmarked).toList();

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        articles: _articles,
        isLoading: _isLoading,
        errorMessage: _errorMessage,
        onRefresh: _loadNews,
        onBookmarkTap: _toggleBookmark,
      ),
      TrendingScreen(
        articles: _articles,
        isLoading: _isLoading,
        errorMessage: _errorMessage,
        onRefresh: _loadNews,
        onBookmarkTap: _toggleBookmark,
      ),
      SavedScreen(
        savedArticles: _savedArticles,
        onBookmarkTap: _toggleBookmark,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
