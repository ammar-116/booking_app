import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../services/auth_services.dart';
import '../services/user_services.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final auth = AuthService();
  final userService = UserService();
  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters")),
      );
      return;
    }

    setState(() => isLoading = true);

    final user = await auth.signUp(email, password);

    if (user != null) {
      await userService.createUser(user.uid, email, "user");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully")),
      );
      Navigator.pop(context);
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signup failed. Email may already be in use."),
        ),
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
                    Image.asset('assets/logo.png', height: 72),
                    const SizedBox(height: 12),
                    Text(
                      'راہ سرائے',
                      style: AppTextStyles.urduTitle.copyWith(
                        color: AppColors.forestGreen,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              Text('Create account', style: AppTextStyles.displayMedium),
              const SizedBox(height: 6),
              Text(
                'Join us and find your dwelling along the path',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Name
              Text('Full Name', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                style: AppTextStyles.bodyLarge,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Your name',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppColors.warmGrey,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email
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

              // Password
              Text('Password', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Min. 6 characters',
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
              const SizedBox(height: 16),

              // Confirm password
              Text('Confirm Password', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirm,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Re-enter password',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.warmGrey,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.warmGrey,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => obscureConfirm = !obscureConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Signup button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : signup,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.warmWhite,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Create Account'),
                ),
              ),
              const SizedBox(height: 20),

              // Login link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTextStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Sign in',
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
              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }
}
