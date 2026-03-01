import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/token_store.dart';
import '../../../../core/services/auth_service.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../../core/config/api_config.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;

  final _auth = AuthService(
    ApiClient(ApiConfig.baseUrl), 
    TokenStore(),
  );

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 500 ? 430.0 : constraints.maxWidth;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/welcome_bg.png', fit: BoxFit.cover),
                  Container(color: Colors.black.withValues(alpha: 0.28)),

                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          const SizedBox(height: 18),

                          const Text(
                            'BabiVoyage Lite',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),

                          const SizedBox(height: 44),

                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w300,
                            ),
                          ),

                          const SizedBox(height: 22),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(26),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.28),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _InputField(
                                      hint: 'Enter your name',
                                      controller: _nameCtrl,
                                      prefix: const Icon(Icons.person_outline, color: Colors.black54),
                                      obscure: false,
                                    ),
                                    const SizedBox(height: 12),
                                    _InputField(
                                      hint: 'Enter your email',
                                      controller: _emailCtrl,
                                      prefix: const Icon(Icons.mail_outline, color: Colors.black54),
                                      obscure: false,
                                    ),
                                    const SizedBox(height: 12),
                                    _InputField(
                                      hint: 'Enter your password',
                                      controller: _passCtrl,
                                      prefix: const Icon(Icons.lock_outline, color: Colors.black54),
                                      obscure: _obscure1,
                                      suffix: IconButton(
                                        onPressed: () => setState(() => _obscure1 = !_obscure1),
                                        icon: Icon(
                                          _obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _InputField(
                                      hint: 'Confirm your password',
                                      controller: _confirmCtrl,
                                      prefix: const Icon(Icons.lock_outline, color: Colors.black54),
                                      obscure: _obscure2,
                                      suffix: IconButton(
                                        onPressed: () => setState(() => _obscure2 = !_obscure2),
                                        icon: Icon(
                                          _obscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 18),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 54,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.primary,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: _loading ? null : () async {
                                          final name = _nameCtrl.text.trim();
                                          final email = _emailCtrl.text.trim();
                                          final pass = _passCtrl.text;
                                          final conf = _confirmCtrl.text;

                                          if (name.isEmpty || email.isEmpty || pass.isEmpty || conf.isEmpty) {
                                            _showError('Please fill all fields.');
                                            return;
                                          }
                                          if (pass != conf) {
                                            _showError('Passwords do not match.');
                                            return;
                                          }

                                          setState(() => _loading = true);
                                          try {
                                            await _auth.register(
                                              name: name,
                                              email: email,
                                              password: pass,
                                              confirmPassword: conf,
                                            );

                                            if (!mounted) return;
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                                            );
                                          } catch (e) {
                                            _showError(e.toString().replaceFirst('Exception: ', ''));
                                          } finally {
                                            if (mounted) setState(() => _loading = false);
                                          }
                                        },
                                        child: Text(
                                          _loading ? 'Creating...' : 'Create Account',
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Already have an account? ',
                                          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: const Text(
                                            'Log In',
                                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            'By signing up, you agree to our Terms of\nService and Privacy Policy.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13.5,
                              height: 1.35,
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscure;

  const _InputField({
    required this.hint,
    required this.controller,
    required this.prefix,
    required this.obscure,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.45)),
          prefixIcon: prefix,
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}