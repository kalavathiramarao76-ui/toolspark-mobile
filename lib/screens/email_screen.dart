import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/ai_service.dart';
import '../widgets/tool_app_bar.dart';
import '../widgets/result_card.dart';
import '../widgets/loading_indicator.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  static const _accent = Color(0xFF3F51B5);
  int _selectedType = 0;
  int _selectedTone = 0;
  final _contextCtrl = TextEditingController();
  final _recipientCtrl = TextEditingController();
  String? _result;
  bool _loading = false;

  Future<void> _generate() async {
    if (_contextCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide some context')),
      );
      return;
    }
    setState(() { _loading = true; _result = null; });
    try {
      final result = await AIService.generateEmail(
        type: AppConstants.emailTypeKeys[_selectedType],
        tone: AppConstants.tones[_selectedTone].toLowerCase(),
        context: _contextCtrl.text.trim(),
        recipientName: _recipientCtrl.text.trim().isNotEmpty ? _recipientCtrl.text.trim() : null,
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
      appBar: ToolAppBar(title: 'Email Writer', accentColor: _accent, icon: Icons.email_rounded),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Email Type', isDark),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(AppConstants.emailTypes.length, (i) {
                final selected = _selectedType == i;
                return ChoiceChip(
                  label: Text(AppConstants.emailTypes[i]),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedType = i),
                  selectedColor: _accent,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Tone', isDark),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(AppConstants.tones.length, (i) {
                final selected = _selectedTone == i;
                return ChoiceChip(
                  label: Text(AppConstants.tones[i]),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedTone = i),
                  selectedColor: _accent,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Recipient (optional)', isDark),
            const SizedBox(height: 8),
            TextField(
              controller: _recipientCtrl,
              decoration: const InputDecoration(hintText: 'e.g. John Smith'),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Context / Purpose', isDark),
            const SizedBox(height: 8),
            TextField(
              controller: _contextCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe what the email is about...',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _generate,
                icon: const Icon(Icons.auto_awesome, size: 20),
                label: const Text('Generate Email'),
              ),
            ),
            if (_loading) const LoadingIndicator(color: _accent),
            if (_result != null)
              ResultCard(
                result: _result!,
                toolName: 'Email Writer',
                title: '${AppConstants.emailTypes[_selectedType]} Email',
                accentColor: _accent,
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, bool isDark) => Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      );

  @override
  void dispose() {
    _contextCtrl.dispose();
    _recipientCtrl.dispose();
    super.dispose();
  }
}
