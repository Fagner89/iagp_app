import 'package:flutter/material.dart';
import 'package:iagp_app/auth/auth_service.dart';
//import 'home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton.icon(
          icon: Image.asset(
            'assets/g-logo.png', // ou use um Icon(Icons.login)
            height: 24.0,
            width: 24.0,
          ),
          label: const Text('Entrar com Google'),
          onPressed: () async {
            final user = await AuthService().signInWithGoogle();

            if (user != null && context.mounted) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
    );
  }
}
