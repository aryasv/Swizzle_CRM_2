import 'package:flutter/material.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  final WebFunctions _api = WebFunctions();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showError("Please enter your email");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await _api.forgotPassword(email: email);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response.result) {
      _showSuccess(
        "Password reset link sent to your email",
      );
    } else {
      _showError(
        response.error.isNotEmpty
            ? response.error
            : "Something went wrong",
      );
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Logo
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Swizzle',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2A7DE1),
                        ),
                      ),
                      TextSpan(
                        text: 'CRM',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 24),

                // Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Center(
                        child: Text(
                          "Enter your email address and we'll send you\na password reset link",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text('Email Address'),
                      const SizedBox(height: 8),

                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration(
                          hintText: 'Enter your email',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Send button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendResetLink,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A7DE1),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                              : const Text(
                            'Send Reset Link',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back to Login',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      labelText: hintText,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFF2A7DE1),
          width: 1.5,
        ),
      ),
    );
  }
}
