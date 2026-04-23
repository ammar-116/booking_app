import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../services/auth_services.dart';
import '../services/user_services.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();
  final userService = UserService();
  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    try {
      final user = await auth
          .login(email, password)
          .timeout(const Duration(seconds: 10), onTimeout: () => null);

      if (user != null) {
        final role = email == "amaarnaruto@gmail.com" ? "manager" : "user";
        userService.createUser(user.uid, email, role).catchError((_) {});
        setState(() => isLoading = false);

        if (role == "manager") {
          Navigator.pushReplacementNamed(context, "/manager");
        } else {
          Navigator.pop(
            context,
          ); // ✅ Always just pop back to wherever we came from
        }
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login failed. Check your credentials."),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed. Check your credentials.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: AppColors.inkBlack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo + title
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/logobg.png', height: 88),
                    const SizedBox(height: 6),
                    Text(
                      'راہ سرائے',
                      style: AppTextStyles.urduTitle.copyWith(
                        color: AppColors.forestGreen,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              Text('Welcome back', style: AppTextStyles.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Sign in to continue your journey',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Email field
              Text('Email', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppTextStyles.bodyLarge,
                decoration: const InputDecoration(
                  hintText: 'you@example.com',
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: AppColors.warmGrey,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              Text('Password', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.warmGrey,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.warmGrey,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => obscurePassword = !obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.warmWhite,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 20),

              // Signup link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignupScreen()),
                      ),
                      child: Text(
                        'Sign up',
                        style: AppTextStyles.labelBold.copyWith(
                          color: AppColors.forestGreen,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.forestGreen,
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
    );
  }
}
