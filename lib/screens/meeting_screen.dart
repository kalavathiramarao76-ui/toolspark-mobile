import 'package:flutter/material.dart';
import '../utils/ai_service.dart';
import '../widgets/tool_app_bar.dart';
import '../widgets/result_card.dart';
import '../widgets/loading_indicator.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  static const _accent = Color(0xFF009688);
  final _transcriptCtrl = TextEditingController();
  String? _result;
  bool _loading = false;

  Future<void> _generate() async {
    if (_transcriptCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste a meeting transcript')),
      );
      return;
    }
    setState(() { _loading = true; _result = null; });
    try {
      final result = await AIService.summarizeMeeting(
        transcript: _transcriptCtrl.text.trim(),
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
      appBar: ToolAppBar(title: 'Meeting Summarizer', accentColor: _accent, icon: Icons.groups_rounded),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _accent.withOpacity(0.08),
                border: Border.all(color: _accent.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: _accent, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Paste your meeting transcript below. AI will extract key decisions, action items, and follow-ups.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Meeting Transcript',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _transcriptCtrl,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Paste the full meeting transcript here...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_transcriptCtrl.text.split(' ').where((w) => w.isNotEmpty).length} words',
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _generate,
                icon: const Icon(Icons.summarize_rounded, size: 20),
                label: const Text('Summarize Meeting'),
                style: ElevatedButton.styleFrom(backgroundColor: _accent),
              ),
            ),
            if (_loading) const LoadingIndicator(color: _accent, message: 'Analyzing transcript...'),
            if (_result != null)
              ResultCard(
                result: _result!,
                toolName: 'Meeting Summarizer',
                title: 'Meeting Summary',
                accentColor: _accent,
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _transcriptCtrl.dispose();
    super.dispose();
  }
}
