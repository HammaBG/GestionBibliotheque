import 'package:flutter/material.dart';
import 'AddLivrePage.dart';
import 'UpdateLivrePage.dart';
import 'db_helper.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Map<String, dynamic>> _livres = [];
  bool _isLoading = true;

  // Fetch books from the database
  Future<void> _refreshLivres() async {
    final data = await DBHelper().fetchAllBooks();
    setState(() {
      _livres = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshLivres(); // Load books when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Livres'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _livres.isEmpty
          ? Center(
        child: Text(
          'Aucun livre trouvé.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: _livres.length,
        itemBuilder: (context, index) {
          final livre = _livres[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(livre['titre']),
              subtitle: Text('ISBN: ${livre['isbn']}'),
              onTap: () {
                // Navigate to UpdateLivrePage when an item is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateLivrePage(livre: livre),
                  ),
                ).then((_) {
                  // Refresh the list after returning from the update page
                  _refreshLivres();
                });
              },
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  // Delete the book and refresh the list
                  await DBHelper().deleteBook(livre['id']);
                  _refreshLivres();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Livre supprimé avec succès!')),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the AddLivrePage and refresh the list after adding a new book
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLivrePage()),
          );
          _refreshLivres();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
