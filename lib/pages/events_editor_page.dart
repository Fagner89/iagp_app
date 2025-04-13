import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventEditorPage extends StatefulWidget {
  const EventEditorPage({super.key});

  @override
  State<EventEditorPage> createState() => _EventEditorPageState();
}

class _EventEditorPageState extends State<EventEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _saveEvent() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) return;

    await FirebaseFirestore.instance.collection('events').add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'date': Timestamp.fromDate(_selectedDate!),
      'isVisible': true,
    });

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Evento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedDate != null
                      ? 'Data: ${_selectedDate!.day}/${_selectedDate!.month} ${_selectedDate!.hour}:${_selectedDate!.minute.toString().padLeft(2, '0')}'
                      : 'Selecionar Data e Hora',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveEvent,
                child: const Text('Salvar Evento'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
