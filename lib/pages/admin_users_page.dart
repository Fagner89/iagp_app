import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  Future<void> toggleAdminStatus(String userId, bool isAdmin) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isAdmin': !isAdmin,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestão de Usuários')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final isAdmin = user['isAdmin'] == true;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['photoUrl'] ?? ''),
                ),
                title: Text(user['name'] ?? 'Sem nome'),
                subtitle: Text(user['email']),
                trailing: ElevatedButton(
                  onPressed: () =>
                      toggleAdminStatus(user.id, isAdmin),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAdmin ? Colors.red : Colors.green,
                  ),
                  child: Text(isAdmin ? 'Remover Admin' : 'Tornar Admin'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
