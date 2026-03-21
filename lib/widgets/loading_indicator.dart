import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;
  final String message;

  const LoadingIndicator({
    super.key,
    required this.color,
    this.message = 'Generating with AI...',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.5),
                ),
              )
                  .animate(
                    onPlay: (c) => c.repeat(),
                    delay: Duration(milliseconds: i * 200),
                  )
                  .scale(
                    begin: const Offset(0.6, 0.6),
                    end: const Offset(1.2, 1.2),
                    duration: 600.ms,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.2, 1.2),
                    end: const Offset(0.6, 0.6),
                    duration: 600.ms,
                  );
            }),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
