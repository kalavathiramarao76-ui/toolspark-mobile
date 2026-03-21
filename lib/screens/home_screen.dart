import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/tool_model.dart';
import '../providers/app_provider.dart';
import '../providers/favorites_provider.dart';
import 'email_screen.dart';
import 'meeting_screen.dart';
import 'code_review_screen.dart';
import 'blog_screen.dart';
import 'product_screen.dart';
import 'threads_screen.dart';
import 'favorites_settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToTool(BuildContext context, String route) {
    Widget screen;
    switch (route) {
      case 'email':
        screen = const EmailScreen();
        break;
      case 'meeting':
        screen = const MeetingScreen();
        break;
      case 'code':
        screen = const CodeReviewScreen();
        break;
      case 'blog':
        screen = const BlogScreen();
        break;
      case 'product':
        screen = const ProductScreen();
        break;
      case 'threads':
        screen = const ThreadsScreen();
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDark;
    final favorites = context.watch<FavoritesProvider>();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
                        ),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ToolSpark AI',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            '6 AI Tools at Your Fingertips',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FavoritesSettingsScreen()),
                      ),
                      icon: Icon(
                        Icons.settings_rounded,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
            ),

            // Greeting card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0), Color(0xFF7986CB)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3F51B5).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'What would you like to create today?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.rocket_launch_rounded, size: 48, color: Colors.white24),
                    ],
                  ),
                ),
              ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1),
            ),

            // Section title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  'AI Tools',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
            ),

            // 2x3 Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.92,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final tool = ToolModel.tools[index];
                    final isFav = favorites.isFavorite(tool.id);
                    return _ToolCard(
                      tool: tool,
                      isFavorite: isFav,
                      isDark: isDark,
                      onTap: () => _navigateToTool(context, tool.route),
                      onFavorite: () => favorites.toggleFavorite(tool.id),
                      delay: 400 + (index * 100),
                    );
                  },
                  childCount: ToolModel.tools.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }
}

class _ToolCard extends StatelessWidget {
  final ToolModel tool;
  final bool isFavorite;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final int delay;

  const _ToolCard({
    required this.tool,
    required this.isFavorite,
    required this.isDark,
    required this.onTap,
    required this.onFavorite,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          border: Border.all(
            color: tool.accentColor.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: tool.accentColor.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: tool.accentColor.withOpacity(0.12),
                  ),
                  child: Icon(tool.icon, color: tool.accentColor, size: 26),
                ),
                GestureDetector(
                  onTap: onFavorite,
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFavorite ? Colors.redAccent : (isDark ? Colors.white30 : Colors.black26),
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              tool.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                tool.description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black45,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Open',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: tool.accentColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 16, color: tool.accentColor),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn(duration: 400.ms).scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          curve: Curves.easeOut,
        );
  }
}
