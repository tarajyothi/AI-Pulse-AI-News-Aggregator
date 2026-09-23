import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

/// Thrown when the API call fails in a way the UI should show as an error state.
class NewsApiException implements Exception {
  final String message;
  NewsApiException(this.message);

  @override
  String toString() => message;
}

/// Handles all REST communication for AI Pulse.
///
/// Course outcome C506.4: demonstrates http.get(), Future, async/await,
/// JSON parsing, response.statusCode, try/catch, and a graceful mock
/// fallback so the app NEVER crashes even without a valid API key.
class NewsApiService {
  // ---------------------------------------------------------------------
  // API CONFIGURATION
  // Replace with a real key from https://newsapi.org if you have one.
  // The app works perfectly fine with mock data if this is left empty.
  // ---------------------------------------------------------------------
  static const String _baseUrl = 'https://newsapi.org/v2/everything';
  static const String _apiKey = ''; // <-- put your NewsAPI key here (optional)

  /// Fetches AI-related news. Falls back to curated mock data if the
  /// network call fails, the key is missing, or the response is invalid.
  Future<List<NewsArticle>> fetchAiNews({String query = 'artificial intelligence'}) async {
    if (_apiKey.isEmpty) {
      debugPrint('[NewsApiService] No API key configured — using mock AI news data.');
      return _mockNews();
    }

    final uri = Uri.parse(
      '$_baseUrl?q=$query&language=en&sortBy=publishedAt&pageSize=20&apiKey=$_apiKey',
    );

    try {
      debugPrint('[NewsApiService] GET $uri');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List articles = body['articles'] ?? [];

        if (articles.isEmpty) {
          debugPrint('[NewsApiService] Empty article list from API — using mock data.');
          return _mockNews();
        }

        return articles
            .map((json) => NewsArticle.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint('[NewsApiService] Non-200 status: ${response.statusCode}');
        throw NewsApiException('Server returned status ${response.statusCode}');
      }
    } on FormatException catch (e) {
      debugPrint('[NewsApiService] JSON parse error: $e');
      throw NewsApiException('Received invalid data from the server.');
    } catch (e) {
      debugPrint('[NewsApiService] Network/error, falling back to mock data: $e');
      // Graceful fallback: never let the app crash because the API failed.
      return _mockNews();
    }
  }

  /// Curated mock AI news used when the API is unavailable — keeps the
  /// project runnable + demoable without any external dependency.
  List<NewsArticle> _mockNews() {
    final now = DateTime.now();
    return [
      NewsArticle(
        id: '1',
        title: 'OpenAI Unveils Next-Generation Reasoning Model',
        description:
            'The new model shows significant improvements in multi-step reasoning, coding, and scientific problem solving, according to internal benchmarks.',
        imageUrl: 'https://images.unsplash.com/photo-1677442136019-21780ecad995',
        source: 'TechCrunch',
        author: 'Sarah Chen',
        publishedAt: now.subtract(const Duration(minutes: 30)),
        url: 'https://techcrunch.com',
        category: 'Generative AI',
      ),
      NewsArticle(
        id: '2',
        title: 'Google DeepMind Publishes Breakthrough in Protein Folding',
        description:
            'Researchers report a new architecture that predicts complex protein structures with unprecedented accuracy, accelerating drug discovery pipelines.',
        imageUrl: 'https://images.unsplash.com/photo-1532187863486-abf9dbad1b69',
        source: 'Nature',
        author: 'Dr. Alan Reyes',
        publishedAt: now.subtract(const Duration(hours: 2)),
        url: 'https://nature.com',
        category: 'AI Research',
      ),
      NewsArticle(
        id: '3',
        title: 'Boston Dynamics Reveals New Humanoid Robot Platform',
        description:
            'The updated Atlas platform features electric actuators, improved balance recovery, and a broader operational range for warehouse tasks.',
        imageUrl: 'https://images.unsplash.com/photo-1561144257-e32e8506c2d5',
        source: 'The Verge',
        author: 'Jamie Woods',
        publishedAt: now.subtract(const Duration(hours: 5)),
        url: 'https://theverge.com',
        category: 'Robotics',
      ),
      NewsArticle(
        id: '4',
        title: 'New Open-Source Tool Simplifies LLM Fine-Tuning',
        description:
            'The lightweight library allows developers to fine-tune large language models on consumer GPUs, lowering the barrier to custom AI tools.',
        imageUrl: 'https://images.unsplash.com/photo-1555949963-aa79dcee981c',
        source: 'GitHub Blog',
        author: 'Priya Nair',
        publishedAt: now.subtract(const Duration(hours: 8)),
        url: 'https://github.blog',
        category: 'AI Tools',
      ),
      NewsArticle(
        id: '5',
        title: 'AI Startup Raises \$50M to Build Autonomous Research Agents',
        description:
            'The seed-to-series-A jump reflects growing investor confidence in agentic AI systems capable of running independent research workflows.',
        imageUrl: 'https://images.unsplash.com/photo-1553877522-43269d4ea984',
        source: 'Forbes',
        author: 'Michael Osei',
        publishedAt: now.subtract(const Duration(hours: 12)),
        url: 'https://forbes.com',
        category: 'AI Startups',
      ),
      NewsArticle(
        id: '6',
        title: 'Microsoft Integrates Copilot Deeper Into Windows',
        description:
            'The update brings on-device AI features to more Windows apps, aiming to make everyday productivity tasks faster and more contextual.',
        imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475',
        source: 'The Verge',
        author: 'Elena Brooks',
        publishedAt: now.subtract(const Duration(hours: 18)),
        url: 'https://theverge.com',
        category: 'Big Tech',
      ),
      NewsArticle(
        id: '7',
        title: 'Meta Releases Efficient On-Device Vision Model',
        description:
            'The compact model runs image recognition tasks locally on mobile hardware, reducing latency and preserving user privacy.',
        imageUrl: 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485',
        source: 'Wired',
        author: 'Tom Baxter',
        publishedAt: now.subtract(const Duration(days: 1)),
        url: 'https://wired.com',
        category: 'Big Tech',
      ),
      NewsArticle(
        id: '8',
        title: 'Study Finds AI Coding Assistants Cut Debug Time by 40%',
        description:
            'A large survey of software teams found consistent productivity gains when AI pair-programming tools were used for routine debugging.',
        imageUrl: 'https://images.unsplash.com/photo-1518432031352-d6fc5c10da5a',
        source: 'IEEE Spectrum',
        author: 'Dr. Lena Cho',
        publishedAt: now.subtract(const Duration(days: 1, hours: 6)),
        url: 'https://spectrum.ieee.org',
        category: 'AI Research',
      ),
    ];
  }
}
