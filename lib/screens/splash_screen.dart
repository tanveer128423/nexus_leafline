import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;

  late AnimationController _backgroundController;
  late Animation<double> _backgroundScaleAnimation;

  late AnimationController _textController;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  late AnimationController _particlesController;
  late Animation<double> _particlesAnimation;

  late AnimationController _morphController;
  late Animation<double> _morphAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    // Background animations
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeOut),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Particles animation
    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _particlesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particlesController, curve: Curves.easeInOut),
    );

    // Morphing animation
    _morphController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _morphAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _morphController, curve: Curves.easeInOut),
    );

    // Start animations
    _backgroundController.forward();
    Future.delayed(Duration(milliseconds: 300), () {
      _logoController.forward();
    });

    Future.delayed(Duration(milliseconds: 800), () {
      _textController.forward();
    });

    Future.delayed(Duration(milliseconds: 500), () {
      _particlesController.repeat(reverse: true);
    });

    Future.delayed(Duration(milliseconds: 1200), () {
      _morphController.forward();
    });

    // Navigate to main screen with drawer
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    _textController.dispose();
    _particlesController.dispose();
    _morphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _backgroundScaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _backgroundScaleAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.5,
                      colors: [
                        Color(0xFF1A1A1A),
                        Color(0xFF0D0D0D),
                        Color(0xFF050505),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Floating particles
          ...List.generate(15, (index) {
            final random = Random(index);
            return AnimatedBuilder(
              animation: _particlesAnimation,
              builder: (context, child) {
                final progress = _particlesAnimation.value;
                final x = size.width * random.nextDouble();
                final y = size.height * random.nextDouble();
                final scale = 0.5 + progress * 0.5;

                return Positioned(
                  left: x + sin(progress * 2 * pi + index) * 20,
                  top: y + cos(progress * 2 * pi + index) * 20,
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 6 + random.nextDouble() * 6,
                      height: 6 + random.nextDouble() * 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(
                          0xFF4A7C59,
                        ).withOpacity(0.3 + progress * 0.4),
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Morphing shapes
          AnimatedBuilder(
            animation: _morphAnimation,
            builder: (context, child) {
              final progress = _morphAnimation.value;
              return Positioned.fill(
                child: CustomPaint(painter: MorphingShapesPainter(progress)),
              );
            },
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with morphing effect
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _logoScaleAnimation,
                    _logoFadeAnimation,
                    _morphAnimation,
                  ]),
                  builder: (context, child) {
                    final morphProgress = _morphAnimation.value;
                    return Opacity(
                      opacity: _logoFadeAnimation.value,
                      child: Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Container(
                          width: 120 + morphProgress * 40,
                          height: 120 + morphProgress * 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2D5A3D).withOpacity(0.8),
                                Color(0xFF4A7C59).withOpacity(0.9),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF4A7C59).withOpacity(0.3),
                                blurRadius: 20 + morphProgress * 10,
                                spreadRadius: morphProgress * 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.eco,
                            color: Colors.white,
                            size: 60 + morphProgress * 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 40),

                // App title with slide animation
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'NEXUS',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 4,
                            shadows: [
                              Shadow(
                                color: Color(0xFF4A7C59).withOpacity(0.5),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'LEAF LINE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF4A7C59),
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 60),

                // Loading indicator
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Container(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF4A7C59),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MorphingShapesPainter extends CustomPainter {
  final double progress;

  MorphingShapesPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF4A7C59).withOpacity(0.1 * progress)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw morphing shapes
    for (int i = 0; i < 3; i++) {
      final angle = (i * 2 * pi / 3) + progress * pi;
      final radius = 100 + progress * 50;
      final x = center.dx + cos(angle) * radius;
      final y = center.dy + sin(angle) * radius;

      canvas.drawCircle(Offset(x, y), 30 + progress * 20, paint);
    }
  }

  @override
  bool shouldRepaint(MorphingShapesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
