import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboardingSeen') ?? false;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => seen ? const HomeScreen() : const OnboardingScreen(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0F23), Color(0xFF1A1A3E), Color(0xFF0F0F23)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0), Color(0xFF7986CB)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3F51B5).withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome, size: 60, color: Colors.white),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .then()
                  .shimmer(duration: 1200.ms, color: Colors.white24),
              const SizedBox(height: 32),
              Text(
                'ToolSpark',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                  shadows: [
                    Shadow(
                      color: const Color(0xFF3F51B5).withOpacity(0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 4),
              Text(
                'AI',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF7986CB),
                  letterSpacing: 12,
                ),
              )
                  .animate(delay: 500.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 24),
              Text(
                '6 AI Tools. One Powerful App.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 1,
                ),
              ).animate(delay: 800.ms).fadeIn(duration: 600.ms),
              const SizedBox(height: 48),
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(
                    const Color(0xFF3F51B5).withOpacity(0.6),
                  ),
                ),
              ).animate(delay: 1000.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
