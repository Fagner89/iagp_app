import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iagp_app/pages/main_tabs.dart';
import 'firebase_options.dart';
import 'auth/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/splash_screen.dart';
import 'pages/error_screen.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<FirebaseApp> _initializeFirebase() async {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IAGP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            } else if (snapshot.hasError) {
              return const ErrorScreen();
            } else {
              final isLoggedIn = AuthService().currentUser != null;
              return isLoggedIn ? const MainTabs() : const LoginPage();
            }
          },
        ),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MainTabs(),
      },
    );
  }
}
