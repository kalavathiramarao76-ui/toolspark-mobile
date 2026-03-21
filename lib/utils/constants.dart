import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'ToolSpark AI';
  static const String appTagline = '6 AI Tools. One Powerful App.';
  static const String appVersion = '1.0.0';

  static const List<String> emailTypes = ['Reply', 'Cold Outreach', 'Follow-Up', 'Apology'];
  static const List<String> emailTypeKeys = ['reply', 'cold', 'follow_up', 'apology'];

  static const List<String> tones = [
    'Professional',
    'Friendly',
    'Formal',
    'Casual',
    'Persuasive',
    'Empathetic',
  ];

  static const List<String> codeLanguages = [
    'JavaScript',
    'Python',
    'Dart',
    'TypeScript',
    'Java',
    'Kotlin',
    'Swift',
    'Go',
    'Rust',
    'C++',
    'Ruby',
    'PHP',
  ];

  static const List<String> blogStyles = [
    'Informative',
    'Conversational',
    'Technical',
    'Storytelling',
    'Listicle',
    'How-To Guide',
  ];

  static const List<String> platforms = ['Amazon', 'Shopify', 'Etsy', 'eBay', 'Custom'];

  static const List<String> threadStyles = [
    'Educational',
    'Storytelling',
    'Hot Take',
    'How-To',
    'Case Study',
    'Motivational',
  ];

  // Onboarding data
  static const List<Map<String, String>> onboardingPages = [
    {
      'title': 'Write & Communicate',
      'subtitle': 'Email Writer & Meeting Summarizer',
      'description':
          'Craft perfect emails for any situation and extract key insights from meeting transcripts instantly.',
    },
    {
      'title': 'Build & Create',
      'subtitle': 'Code Reviewer & Blog Generator',
      'description':
          'Get AI-powered code reviews and generate SEO-optimized blog posts with custom style and keywords.',
    },
    {
      'title': 'Market & Engage',
      'subtitle': 'Product Copywriter & Tweet Threads',
      'description':
          'Create compelling product descriptions and generate viral Twitter/X threads that drive engagement.',
    },
  ];

  static const List<List<IconData>> onboardingIcons = [
    [Icons.email_rounded, Icons.groups_rounded],
    [Icons.code_rounded, Icons.article_rounded],
    [Icons.shopping_bag_rounded, Icons.tag_rounded],
  ];

  static const List<List<Color>> onboardingColors = [
    [Color(0xFF3F51B5), Color(0xFF009688)],
    [Color(0xFFFF5722), Color(0xFF9C27B0)],
    [Color(0xFFFF9800), Color(0xFF2196F3)],
  ];
}
