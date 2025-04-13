import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Erro ao iniciar o app 😢',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
