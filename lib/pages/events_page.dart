import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final eventsRef = FirebaseFirestore.instance
        .collection('events')
        .where('isVisible', isEqualTo: true)
        .orderBy('date');

    return Scaffold(
      appBar: AppBar(title: const Text('Eventos da IAGP')),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data!.docs;

          if (events.isEmpty) {
            return const Center(child: Text('Nenhum evento disponível.'));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final data = events[index].data() as Map<String, dynamic>;

              final title = data['title'] ?? 'Sem título';
              final description = data['description'] ?? '';
              final date = (data['date'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(description),
                  trailing: Text(
                    '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
