import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class ResultCard extends StatelessWidget {
  final String result;
  final String toolName;
  final String title;
  final Color accentColor;

  const ResultCard({
    super.key,
    required this.result,
    required this.toolName,
    required this.title,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Generated Output',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            border: Border.all(color: accentColor.withOpacity(0.2)),
          ),
          child: SelectableText(
            result,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.white.withOpacity(0.85) : Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: result));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Copied to clipboard'),
                      backgroundColor: accentColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('Copy'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: accentColor,
                  side: BorderSide(color: accentColor.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Share.share(result),
                icon: const Icon(Icons.share_rounded, size: 18),
                label: const Text('Share'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: accentColor,
                  side: BorderSide(color: accentColor.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                context.read<FavoritesProvider>().saveOutput(toolName, title, result);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Saved to favorites'),
                    backgroundColor: accentColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              icon: Icon(Icons.bookmark_add_rounded, color: accentColor),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }
}
