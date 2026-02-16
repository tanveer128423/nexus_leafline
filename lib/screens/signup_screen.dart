import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  final bool showOnboarding;

  const SignupScreen({super.key, required this.showOnboarding});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static const _prefsNameKey = 'local_name';
  static const _prefsEmailKey = 'local_email';
  static const _prefsPasswordKey = 'local_password';
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _attemptSignup() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsNameKey, _nameController.text.trim());
    await prefs.setString(_prefsEmailKey, _emailController.text.trim());
    await prefs.setString(_prefsPasswordKey, _passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created locally. Log in to continue.'),
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(showOnboarding: widget.showOnboarding),
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(showOnboarding: widget.showOnboarding),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 720;
    final isCompact = size.width < 380;
    final horizontalPadding = isCompact ? 18.0 : 24.0;
    final topPadding = isCompact ? 24.0 : 36.0;
    final cardPadding = isCompact ? 18.0 : 22.0;
    final logoSize = isCompact ? 42.0 : 48.0;
    final titleSize = isCompact ? 20.0 : 22.0;
    final badgeFontSize = isCompact ? 11.0 : 12.0;

    final logoMark = Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF2D5A3D), Color(0xFF4A7C59)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A7C59).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(Icons.eco, color: Colors.white, size: isCompact ? 22 : 26),
    );

    final wordmark = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NEXUS LEAFLINE',
          style: TextStyle(
            color: Colors.white,
            fontSize: titleSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        Text(
          'Start your plant care journey',
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.4,
                  colors: [
                    Color(0xFF17251E),
                    Color(0xFF0F1512),
                    Color(0xFF070707),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.12,
            right: size.width * 0.18,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4A7C59).withOpacity(0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.18,
            left: size.width * 0.12,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2D5A3D).withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isWide) const SizedBox(height: 32),
                      isCompact
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                logoMark,
                                const SizedBox(height: 12),
                                wordmark,
                              ],
                            )
                          : Row(
                              children: [
                                logoMark,
                                const SizedBox(width: 14),
                                wordmark,
                              ],
                            ),
                      SizedBox(height: isCompact ? 18 : 24),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A2A22),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: const Color(0xFF2D5A3D).withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              'No Firebase',
                              style: TextStyle(
                                color: const Color(0xFFBFE1C9),
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          Text(
                            'Create your account',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: isCompact ? 14 : 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isCompact ? 22 : 28),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                          child: Container(
                            padding: EdgeInsets.all(cardPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF161F1B).withOpacity(0.85),
                                  const Color(0xFF0E1412).withOpacity(0.9),
                                ],
                              ),
                              border: Border.all(
                                color: const Color(
                                  0xFF2D5A3D,
                                ).withOpacity(0.45),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 30,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Create account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'We keep it local for now. No cloud sync.',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  TextFormField(
                                    controller: _nameController,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Full name',
                                      labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                      hintText: 'Avery Green',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.35),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.person_outline,
                                        color: Colors.white54,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFF111814),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                          color: const Color(
                                            0xFF2D5A3D,
                                          ).withOpacity(0.4),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF7BCB91),
                                          width: 1.3,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      final name = value?.trim() ?? '';
                                      if (name.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                      hintText: 'you@example.com',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.35),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.mail_outline,
                                        color: Colors.white54,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFF111814),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                          color: const Color(
                                            0xFF2D5A3D,
                                          ).withOpacity(0.4),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF7BCB91),
                                          width: 1.3,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      final email = value?.trim() ?? '';
                                      if (email.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!email.contains('@')) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                      hintText: 'At least 6 characters',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.35),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                        color: Colors.white54,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFF111814),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                          color: const Color(
                                            0xFF2D5A3D,
                                          ).withOpacity(0.4),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF7BCB91),
                                          width: 1.3,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white54,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      final password = value ?? '';
                                      if (password.isEmpty) {
                                        return 'Please enter a password';
                                      }
                                      if (password.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: _obscureConfirmPassword,
                                    textInputAction: TextInputAction.done,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: 'Confirm password',
                                      labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                      hintText: 'Re-enter password',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.35),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                        color: Colors.white54,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFF111814),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide(
                                          color: const Color(
                                            0xFF2D5A3D,
                                          ).withOpacity(0.4),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF7BCB91),
                                          width: 1.3,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureConfirmPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white54,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureConfirmPassword =
                                                !_obscureConfirmPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      final confirm = value ?? '';
                                      if (confirm.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (confirm != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (_) => _attemptSignup(),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: _attemptSignup,
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF4A7C59),
                                              Color(0xFF7BCB91),
                                            ],
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'CREATE ACCOUNT',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1.1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Text(
                                        'Already have an account?',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: _goToLogin,
                                        child: const Text(
                                          'Log in',
                                          style: TextStyle(
                                            color: Color(0xFFBFE1C9),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
