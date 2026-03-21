import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/ai_service.dart';
import '../widgets/tool_app_bar.dart';
import '../widgets/result_card.dart';
import '../widgets/loading_indicator.dart';

class CodeReviewScreen extends StatefulWidget {
  const CodeReviewScreen({super.key});

  @override
  State<CodeReviewScreen> createState() => _CodeReviewScreenState();
}

class _CodeReviewScreenState extends State<CodeReviewScreen> {
  static const _accent = Color(0xFFFF5722);
  int _selectedLang = 0;
  final _codeCtrl = TextEditingController();
  String? _result;
  bool _loading = false;

  Future<void> _generate() async {
    if (_codeCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste your code')),
      );
      return;
    }
    setState(() { _loading = true; _result = null; });
    try {
      final result = await AIService.reviewCode(
        code: _codeCtrl.text.trim(),
        language: AppConstants.codeLanguages[_selectedLang],
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
      appBar: ToolAppBar(title: 'Code Reviewer', accentColor: _accent, icon: Icons.code_rounded),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Programming Language',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark ? const Color(0xFF16213E) : const Color(0xFFF0F0F0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedLang,
                  isExpanded: true,
                  dropdownColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
                  items: List.generate(AppConstants.codeLanguages.length, (i) {
                    return DropdownMenuItem(
                      value: i,
                      child: Text(AppConstants.codeLanguages[i]),
                    );
                  }),
                  onChanged: (v) => setState(() => _selectedLang = v!),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Code',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _codeCtrl,
              maxLines: 12,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: isDark ? Colors.greenAccent.shade200 : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Paste your code here...',
                fillColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_codeCtrl.text.split('\n').length} lines',
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _generate,
                icon: const Icon(Icons.rate_review_rounded, size: 20),
                label: const Text('Review Code'),
                style: ElevatedButton.styleFrom(backgroundColor: _accent),
              ),
            ),
            if (_loading) const LoadingIndicator(color: _accent, message: 'Reviewing code...'),
            if (_result != null)
              ResultCard(
                result: _result!,
                toolName: 'Code Reviewer',
                title: '${AppConstants.codeLanguages[_selectedLang]} Review',
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
    _codeCtrl.dispose();
    super.dispose();
  }
}
