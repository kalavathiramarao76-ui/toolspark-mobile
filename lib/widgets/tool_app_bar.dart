import 'package:flutter/material.dart';

class ToolAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color accentColor;
  final IconData icon;

  const ToolAppBar({
    super.key,
    required this.title,
    required this.accentColor,
    required this.icon,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: accentColor.withOpacity(0.15),
            ),
            child: Icon(icon, size: 18, color: accentColor),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      ),
    );
  }
}
