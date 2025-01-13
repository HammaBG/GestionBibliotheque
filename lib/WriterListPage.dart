import 'package:flutter/material.dart';
import 'AddWriterPage.dart';
import 'UpdateWriterPage.dart';
import 'db_helper.dart';

class WriterListPage extends StatefulWidget {
  @override
  _WriterListPageState createState() => _WriterListPageState();
}

class _WriterListPageState extends State<WriterListPage> {
  List<Map<String, dynamic>> _writers = [];
  bool _isLoading = true;

  // Fetch writers from the database
  Future<void> _refreshWriters() async {
    final data = await DBHelper().fetchAll('ecrivains');
    setState(() {
      _writers = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshWriters(); // Load writers when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Écrivains'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _writers.isEmpty
          ? Center(
        child: Text(
          'Aucun écrivain trouvé.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: _writers.length,
        itemBuilder: (context, index) {
          final writer = _writers[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('${writer['nom']} ${writer['prenom']}'),
              subtitle: Text('Téléphone: ${writer['tel']}'),
              onTap: () {
                // Navigate to UpdateWriterPage when an item is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateWriterPage(writer: writer),
                  ),
                ).then((_) {
                  // Refresh the list after returning from the update page
                  _refreshWriters();
                });
              },
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  // Delete the writer and refresh the list
                  await DBHelper().delete('ecrivains', 'id = ?', [writer['id']]);
                  _refreshWriters();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Écrivain supprimé avec succès!')),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the AddWriterPage and refresh the list after adding a new writer
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWriterPage()),
          );
          _refreshWriters();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
