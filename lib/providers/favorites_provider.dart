import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  Set<String> _favoriteIds = {};
  List<Map<String, String>> _savedOutputs = [];

  Set<String> get favoriteIds => _favoriteIds;
  List<Map<String, String>> get savedOutputs => _savedOutputs;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorites') ?? [];
    _favoriteIds = favs.toSet();

    final outputs = prefs.getStringList('savedOutputs') ?? [];
    _savedOutputs = outputs.map((e) {
      final parts = e.split('|||');
      return {
        'tool': parts.isNotEmpty ? parts[0] : '',
        'title': parts.length > 1 ? parts[1] : '',
        'content': parts.length > 2 ? parts[2] : '',
        'timestamp': parts.length > 3 ? parts[3] : '',
      };
    }).toList();

    notifyListeners();
  }

  Future<void> toggleFavorite(String toolId) async {
    if (_favoriteIds.contains(toolId)) {
      _favoriteIds.remove(toolId);
    } else {
      _favoriteIds.add(toolId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteIds.toList());
    notifyListeners();
  }

  bool isFavorite(String toolId) => _favoriteIds.contains(toolId);

  Future<void> saveOutput(String tool, String title, String content) async {
    final entry = {
      'tool': tool,
      'title': title,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _savedOutputs.insert(0, entry);
    if (_savedOutputs.length > 50) _savedOutputs = _savedOutputs.sublist(0, 50);

    final prefs = await SharedPreferences.getInstance();
    final encoded = _savedOutputs
        .map((e) => '${e['tool']}|||${e['title']}|||${e['content']}|||${e['timestamp']}')
        .toList();
    await prefs.setStringList('savedOutputs', encoded);
    notifyListeners();
  }

  Future<void> removeOutput(int index) async {
    _savedOutputs.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    final encoded = _savedOutputs
        .map((e) => '${e['tool']}|||${e['title']}|||${e['content']}|||${e['timestamp']}')
        .toList();
    await prefs.setStringList('savedOutputs', encoded);
    notifyListeners();
  }

  Future<void> clearAll() async {
    _savedOutputs.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedOutputs', []);
    notifyListeners();
  }
}
