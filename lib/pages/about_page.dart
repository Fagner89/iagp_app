import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sobre a IAGP')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'A Igreja Apostólica Graça e Perdão (IAGP) é uma comunidade cristã focada no amor, comunhão e na restauração de vidas por meio da Palavra de Deus.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
