import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/ai_service.dart';
import '../widgets/tool_app_bar.dart';
import '../widgets/result_card.dart';
import '../widgets/loading_indicator.dart';

class ThreadsScreen extends StatefulWidget {
  const ThreadsScreen({super.key});

  @override
  State<ThreadsScreen> createState() => _ThreadsScreenState();
}

class _ThreadsScreenState extends State<ThreadsScreen> {
  static const _accent = Color(0xFF2196F3);
  int _selectedStyle = 0;
  double _tweetCount = 7;
  final _topicCtrl = TextEditingController();
  String? _result;
  bool _loading = false;

  Future<void> _generate() async {
    if (_topicCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a thread topic')),
      );
      return;
    }
    setState(() { _loading = true; _result = null; });
    try {
      final result = await AIService.generateTweetThread(
        topic: _topicCtrl.text.trim(),
        style: AppConstants.threadStyles[_selectedStyle],
        tweetCount: _tweetCount.round(),
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
      appBar: ToolAppBar(title: 'Tweet Threads', accentColor: _accent, icon: Icons.tag_rounded),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Thread Topic', isDark),
            const SizedBox(height: 8),
            TextField(
              controller: _topicCtrl,
              decoration: const InputDecoration(
                hintText: 'e.g. Building a Personal Brand in 2024',
              ),
            ),
            const SizedBox(height: 20),
            _label('Thread Style', isDark),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(AppConstants.threadStyles.length, (i) {
                final selected = _selectedStyle == i;
                return ChoiceChip(
                  label: Text(AppConstants.threadStyles[i]),
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
            _label('Number of Tweets: ${_tweetCount.round()}', isDark),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: _accent,
                thumbColor: _accent,
                inactiveTrackColor: _accent.withOpacity(0.2),
                overlayColor: _accent.withOpacity(0.1),
              ),
              child: Slider(
                value: _tweetCount,
                min: 5,
                max: 10,
                divisions: 5,
                label: '${_tweetCount.round()} tweets',
                onChanged: (v) => setState(() => _tweetCount = v),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('5', style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38)),
                Text('10', style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _generate,
                icon: const Icon(Icons.campaign_rounded, size: 20),
                label: const Text('Generate Thread'),
                style: ElevatedButton.styleFrom(backgroundColor: _accent),
              ),
            ),
            if (_loading) const LoadingIndicator(color: _accent, message: 'Crafting tweet thread...'),
            if (_result != null)
              ResultCard(
                result: _result!,
                toolName: 'Tweet Threads',
                title: '${_topicCtrl.text.trim()} (${_tweetCount.round()} tweets)',
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
    super.dispose();
  }
}
