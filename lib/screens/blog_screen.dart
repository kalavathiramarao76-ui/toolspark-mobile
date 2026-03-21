import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/ai_service.dart';
import '../widgets/tool_app_bar.dart';
import '../widgets/result_card.dart';
import '../widgets/loading_indicator.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  static const _accent = Color(0xFF9C27B0);
  int _selectedStyle = 0;
  final _topicCtrl = TextEditingController();
  final _keywordsCtrl = TextEditingController();
  String? _result;
  bool _loading = false;

  Future<void> _generate() async {
    if (_topicCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a blog topic')),
      );
      return;
    }
    setState(() { _loading = true; _result = null; });
    try {
      final result = await AIService.generateBlog(
        topic: _topicCtrl.text.trim(),
        style: AppConstants.blogStyles[_selectedStyle],
        keywords: _keywordsCtrl.text.trim(),
      );
      setState(() => _result = result);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: ToolAppBar(title: 'Blog Generator', accentColor: _accent, icon: Icons.article_rounded),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Blog Topic', isDark),
            const SizedBox(height: 8),
            TextField(
              controller: _topicCtrl,
              decoration: const InputDecoration(
                hintText: 'e.g. The Future of Remote Work',
              ),
            ),
            const SizedBox(height: 20),
            _label('Writing Style', isDark),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(AppConstants.blogStyles.length, (i) {
                final selected = _selectedStyle == i;
                return ChoiceChip(
                  label: Text(AppConstants.blogStyles[i]),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedStyle = i),
                  selectedColor: _accent,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            _label('SEO Keywords (comma-separated)', isDark),
            const SizedBox(height: 8),
            TextField(
              controller: _keywordsCtrl,
              decoration: const InputDecoration(
                hintText: 'e.g. remote work, productivity, work from home',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _generate,
                icon: const Icon(Icons.edit_note_rounded, size: 22),
                label: const Text('Generate Blog Post'),
                style: ElevatedButton.styleFrom(backgroundColor: _accent),
              ),
            ),
            if (_loading) const LoadingIndicator(color: _accent, message: 'Writing blog post...'),
            if (_result != null)
              ResultCard(
                result: _result!,
                toolName: 'Blog Generator',
                title: _topicCtrl.text.trim(),
                accentColor: _accent,
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, bool isDark) => Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      );

  @override
  void dispose() {
    _topicCtrl.dispose();
    _keywordsCtrl.dispose();
    super.dispose();
  }
}
