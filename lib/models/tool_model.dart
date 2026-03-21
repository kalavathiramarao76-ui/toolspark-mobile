import 'package:flutter/material.dart';

class ToolModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color accentColor;
  final String route;

  const ToolModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.route,
  });

  static const List<ToolModel> tools = [
    ToolModel(
      id: 'email',
      name: 'Email Writer',
      description: 'Craft professional emails — replies, cold outreach, follow-ups & apologies',
      icon: Icons.email_rounded,
      accentColor: Color(0xFF3F51B5),
      route: 'email',
    ),
    ToolModel(
      id: 'meeting',
      name: 'Meeting Summarizer',
      description: 'Extract action items, decisions & key points from meeting transcripts',
      icon: Icons.groups_rounded,
      accentColor: Color(0xFF009688),
      route: 'meeting',
    ),
    ToolModel(
      id: 'code',
      name: 'Code Reviewer',
      description: 'Get AI-powered code reviews with suggestions and best practices',
      icon: Icons.code_rounded,
      accentColor: Color(0xFFFF5722),
      route: 'code',
    ),
    ToolModel(
      id: 'blog',
      name: 'Blog Generator',
      description: 'Generate SEO-optimized blog posts with custom style and keywords',
      icon: Icons.article_rounded,
      accentColor: Color(0xFF9C27B0),
      route: 'blog',
    ),
    ToolModel(
      id: 'product',
      name: 'Product Copywriter',
      description: 'Create compelling product descriptions for Amazon, Shopify & more',
      icon: Icons.shopping_bag_rounded,
      accentColor: Color(0xFFFF9800),
      route: 'product',
    ),
    ToolModel(
      id: 'threads',
      name: 'Tweet Threads',
      description: 'Generate engaging Twitter/X threads on any topic with custom style',
      icon: Icons.tag_rounded,
      accentColor: Color(0xFF2196F3),
      route: 'threads',
    ),
  ];
}
