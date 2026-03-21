import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/tool_model.dart';

class FavoritesSettingsScreen extends StatefulWidget {
  const FavoritesSettingsScreen({super.key});

  @override
  State<FavoritesSettingsScreen> createState() => _FavoritesSettingsScreenState();
}

class _FavoritesSettingsScreenState extends State<FavoritesSettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites & Settings', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: const Color(0xFF3F51B5),
          labelColor: const Color(0xFF3F51B5),
          unselectedLabelColor: isDark ? Colors.white54 : Colors.black45,
          tabs: const [
            Tab(icon: Icon(Icons.bookmark_rounded), text: 'Saved'),
            Tab(icon: Icon(Icons.settings_rounded), text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildFavoritesTab(isDark),
          _buildSettingsTab(isDark),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab(bool isDark) {
    final favProvider = context.watch<FavoritesProvider>();
    final outputs = favProvider.savedOutputs;

    if (outputs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border_rounded, size: 64, color: isDark ? Colors.white24 : Colors.black12),
            const SizedBox(height: 16),
            Text(
              'No saved outputs yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Generate content and tap the bookmark icon to save it here.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white38 : Colors.black26,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${outputs.length} saved items',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showClearDialog(),
                icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                label: const Text('Clear All'),
                style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: outputs.length,
            itemBuilder: (context, index) {
              final item = outputs[index];
              return Dismissible(
                key: Key('${item['timestamp']}_$index'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) => favProvider.removeOutput(index),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _getToolColor(item['tool'] ?? '').withOpacity(0.12),
                      ),
                      child: Icon(
                        _getToolIcon(item['tool'] ?? ''),
                        color: _getToolColor(item['tool'] ?? ''),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      item['tool'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    onTap: () => _showOutputDialog(item),
                  ),
                ),
              ).animate(delay: Duration(milliseconds: index * 50)).fadeIn().slideX(begin: 0.1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab(bool isDark) {
    final appProvider = context.watch<AppProvider>();
    final favProvider = context.watch<FavoritesProvider>();
    final favTools = ToolModel.tools.where((t) => favProvider.isFavorite(t.id)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: const Icon(Icons.auto_awesome, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  'ToolSpark AI',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7)),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 24),

          // Theme toggle
          _settingsSection('Appearance', isDark),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(appProvider.isDark ? 'Dark theme enabled' : 'Light theme enabled'),
              value: appProvider.isDark,
              onChanged: (_) => appProvider.toggleTheme(),
              activeColor: const Color(0xFF3F51B5),
              secondary: Icon(
                appProvider.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: const Color(0xFF3F51B5),
              ),
            ),
          ).animate(delay: 100.ms).fadeIn().slideX(begin: 0.05),

          const SizedBox(height: 24),

          // Favorite tools
          _settingsSection('Favorite Tools (${favTools.length})', isDark),
          const SizedBox(height: 8),
          if (favTools.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No favorite tools yet. Tap the heart icon on the home screen.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            ...favTools.asMap().entries.map((entry) {
              final tool = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 6),
                child: ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: tool.accentColor.withOpacity(0.12),
                    ),
                    child: Icon(tool.icon, size: 18, color: tool.accentColor),
                  ),
                  title: Text(tool.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 20),
                    onPressed: () => favProvider.toggleFavorite(tool.id),
                  ),
                ),
              ).animate(delay: Duration(milliseconds: 150 + entry.key * 50)).fadeIn().slideX(begin: 0.05);
            }),

          const SizedBox(height: 24),

          // About
          _settingsSection('About', isDark),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded, color: Color(0xFF3F51B5)),
                  title: const Text('About ToolSpark AI', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('6 AI-powered productivity tools'),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF3F51B5)),
                  title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: Color(0xFF3F51B5)),
                  title: const Text('Terms of Service', style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () {},
                ),
              ],
            ),
          ).animate(delay: 200.ms).fadeIn().slideX(begin: 0.05),

          const SizedBox(height: 32),
          Center(
            child: Text(
              'Made with Flutter & AI',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _settingsSection(String title, bool isDark) => Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white54 : Colors.black45,
          letterSpacing: 0.5,
        ),
      );

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Saved'),
        content: const Text('Are you sure you want to delete all saved outputs?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<FavoritesProvider>().clearAll();
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showOutputDialog(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] ?? '',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['tool'] ?? '',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: SelectableText(
                    item['content'] ?? '',
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getToolColor(String toolName) {
    final map = {
      'Email Writer': const Color(0xFF3F51B5),
      'Meeting Summarizer': const Color(0xFF009688),
      'Code Reviewer': const Color(0xFFFF5722),
      'Blog Generator': const Color(0xFF9C27B0),
      'Product Copywriter': const Color(0xFFFF9800),
      'Tweet Threads': const Color(0xFF2196F3),
    };
    return map[toolName] ?? const Color(0xFF3F51B5);
  }

  IconData _getToolIcon(String toolName) {
    final map = {
      'Email Writer': Icons.email_rounded,
      'Meeting Summarizer': Icons.groups_rounded,
      'Code Reviewer': Icons.code_rounded,
      'Blog Generator': Icons.article_rounded,
      'Product Copywriter': Icons.shopping_bag_rounded,
      'Tweet Threads': Icons.tag_rounded,
    };
    return map[toolName] ?? Icons.auto_awesome;
  }
}
