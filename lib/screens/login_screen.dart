import 'package:flutter/material.dart';
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

  void login() async {
  final user = await auth.login(
    emailController.text.trim(),
    passwordController.text.trim(),
  );

  if (user != null) {
    String role;
    String name;

    final email = user.email?.trim().toLowerCase();

if (email == "amaarnaruto@gmail.com") {
  role = "manager";
  name = "Manager";
} else {
  role = "user";
  name = "User";
}
print("Logged in user: ${user?.email}");
print("Role detected: $role");
    // 🔥 Store in Firestore if not exists
    await userService.createUser(user.uid, user.email!, role);

    // 🔀 Navigate based on role
    if (role == "manager") {
      Navigator.pushReplacementNamed(context, "/manager");
      print("Going to manager dashboard");
    } else {
      print("Going to home");
      Navigator.pushReplacementNamed(context, "/home");
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login failed")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: login,
              child: Text("Login"),
            ),

            SizedBox(height: 20),
            
            TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SignupScreen()),
    );
  },
  child: Text("Don't have an account? Sign up"),
),
          ],
        ),
      ),
    );
  }
}