import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _notes = [];
  int? _editingIndex; 
  void _saveNote() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      if (_editingIndex != null) {
        _notes[_editingIndex!] = text;
        _editingIndex = null;
      } else {
        _notes.add(text);
      }
      _controller.clear();
    });
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _controller.text = _notes[index];
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = null;
        _controller.clear();
      } else if (_editingIndex != null && _editingIndex! > index) {
        _editingIndex = _editingIndex! - 1;
      }
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingIndex = null;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: _editingIndex == null
                          ? 'Введите новую заметку...'
                          : 'Редактируете заметку...',
                      labelText: _editingIndex == null ? 'Новая заметка' : 'Редактирование',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _saveNote,
                      child: Text(_editingIndex == null ? 'Сохранить' : 'Обновить'),
                    ),
                    if (_editingIndex != null) ...[
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: _cancelEditing,
                        child: const Text('Отмена'),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            Expanded(
              child: _notes.isEmpty
                  ? const Center(
                      child: Text(
                        'Пока заметок нет…',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        final note = _notes[index];
                        final isBeingEdited = _editingIndex == index;

                        return Card(
                          color: isBeingEdited ? Colors.teal.shade50 : null,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(note),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _startEditing(index),
                                  tooltip: 'Редактировать',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteNote(index),
                                  tooltip: 'Удалить',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}