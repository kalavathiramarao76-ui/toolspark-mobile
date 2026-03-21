import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/ai_service.dart';
import '../widgets/tool_app_bar.dart';
import '../widgets/result_card.dart';
import '../widgets/loading_indicator.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  static const _accent = Color(0xFFFF9800);
  int _selectedPlatform = 0;
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _audienceCtrl = TextEditingController();
  String? _result;
  bool _loading = false;

  Future<void> _generate() async {
    if (_nameCtrl.text.trim().isEmpty || _descCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in product name and description')),
      );
      return;
    }
    setState(() { _loading = true; _result = null; });
    try {
      final result = await AIService.generateProductCopy(
        productName: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        platform: AppConstants.platforms[_selectedPlatform],
        targetAudience: _audienceCtrl.text.trim().isNotEmpty ? _audienceCtrl.text.trim() : null,
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
      appBar: ToolAppBar(title: 'Product Copywriter', accentColor: _accent, icon: Icons.shopping_bag_rounded),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Product Name', isDark),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(hintText: 'e.g. ProMax Wireless Earbuds'),
            ),
            const SizedBox(height: 20),
            _label('Product Description', isDark),
            const SizedBox(height: 8),
            TextField(
              controller: _descCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe the product, features, materials, benefits...',
              ),
            ),
            const SizedBox(height: 20),
            _label('Target Platform', isDark),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(AppConstants.platforms.length, (i) {
                final selected = _selectedPlatform == i;
                return ChoiceChip(
                  label: Text(AppConstants.platforms[i]),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedPlatform = i),
                  selectedColor: _accent,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            _label('Target Audience (optional)', isDark),
            const SizedBox(height: 8),
            TextField(
              controller: _audienceCtrl,
              decoration: const InputDecoration(
                hintText: 'e.g. fitness enthusiasts, professionals',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _generate,
                icon: const Icon(Icons.auto_fix_high_rounded, size: 20),
                label: const Text('Generate Copy'),
                style: ElevatedButton.styleFrom(backgroundColor: _accent),
              ),
            ),
            if (_loading) const LoadingIndicator(color: _accent, message: 'Crafting product copy...'),
            if (_result != null)
              ResultCard(
                result: _result!,
                toolName: 'Product Copywriter',
                title: '${_nameCtrl.text.trim()} — ${AppConstants.platforms[_selectedPlatform]}',
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
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _audienceCtrl.dispose();
    super.dispose();
  }
}
