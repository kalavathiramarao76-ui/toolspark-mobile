import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _next() {
    if (_currentPage < 2) {
      _controller.nextPage(duration: 400.ms, curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingSeen', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0F23), Color(0xFF1A1A3E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
                  ),
                ),
              ),
              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildPage(index),
                ),
              ),
              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return AnimatedContainer(
                    duration: 300.ms,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentPage == i
                          ? const Color(0xFF3F51B5)
                          : Colors.white.withOpacity(0.2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              // Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F51B5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Get Started' : 'Next',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    final data = AppConstants.onboardingPages[index];
    final icons = AppConstants.onboardingIcons[index];
    final colors = AppConstants.onboardingColors[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Two tool icons side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _toolIcon(icons[0], colors[0]),
              const SizedBox(width: 24),
              _toolIcon(icons[1], colors[1]),
            ],
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
          const SizedBox(height: 48),
          Text(
            data['title']!,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text(
            data['subtitle']!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colors[0],
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 20),
          Text(
            data['description']!,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }

  Widget _toolIcon(IconData icon, Color color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: color.withOpacity(0.15),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Icon(icon, size: 40, color: color),
    );
  }
}
