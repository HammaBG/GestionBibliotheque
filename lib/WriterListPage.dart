import 'package:flutter/material.dart';
import 'AddWriterPage.dart';

class WriterListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Écrivains'),
      ),
      body: Center(
        child: Text('Ici, la liste des écrivains sera affichée.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddWriterPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWriterPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
