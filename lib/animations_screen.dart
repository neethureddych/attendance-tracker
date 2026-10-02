import 'package:flutter/material.dart';

class AnimationsScreen extends StatefulWidget {
  const AnimationsScreen({super.key});

  @override
  State<AnimationsScreen> createState() => _AnimationsScreenState();
}

class _AnimationsScreenState extends State<AnimationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _replayAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animations')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Card(
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.all(30),
                      child: const Column(
                        children: [
                          Icon(Icons.school, size: 80, color: Colors.indigo),
                          SizedBox(height: 20),
                          Text(
                            'Attendance Tracker',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Fade and Slide Animation Demo',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _replayAnimation,
                icon: const Icon(Icons.replay),
                label: const Text('Replay Animation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
