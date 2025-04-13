import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'login_page.dart';
import 'events_editor_page.dart';
import 'admin_users_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Usuário não encontrado'));
    }

    final userRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);

    return FutureBuilder<DocumentSnapshot>(
      future: userRef.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final isAdmin = data['isAdmin'] == true;

        return Scaffold(
          appBar: AppBar(title: const Text('Minha Conta')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${user.displayName}'),
                Text('Email: ${user.email}'),
                const SizedBox(height: 20),
                if (isAdmin) ...[
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EventEditorPage()),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Criar novo evento'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminUsersPage()),
                    ),
                    icon: const Icon(Icons.admin_panel_settings),
                    label: const Text('Gerenciar usuários'),
                  ),
                ],
                const Spacer(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await AuthService().signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                              (route) => false,
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sair'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
