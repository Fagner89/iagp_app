import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
///import 'package:firebase_auth/firebase_auth.dart';

import '../auth/auth_service.dart';
import 'login_page.dart';
import 'admin_users_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo ao IAGP APP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Usuário não encontrado'))
          : FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Usuário não registrado no banco.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final isAdmin = userData['isAdmin'] == true;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Você está logado! 🎉'),
                const SizedBox(height: 10),
                Text('Usuário: ${user.displayName ?? "N/A"}'),
                Text('Email: ${user.email ?? "N/A"}'),
                const SizedBox(height: 30),
                if (isAdmin)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.admin_panel_settings),
                    label: const Text('Área Administrativa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminUsersPage(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
