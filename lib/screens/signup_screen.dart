import 'package:flutter/material.dart';
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

  final auth = AuthService();
  final userService = UserService();

  void signup() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final user = await auth.signUp(email, password);

    if (user != null) {
      // 👑 Assign role
      String role = email == "admin@gmail.com" ? "manager" : "user";

      await userService.createUser(user.uid, email, role);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup successful")),
      );

      Navigator.pop(context); // go back to login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: signup,
              child: Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}