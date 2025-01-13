import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Bibliothèque',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion Bibliothèque'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Liste des Livres'),
              onTap: () {
                // Naviguer vers la page Liste des Livres
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Liste des Écrivains'),
              onTap: () {
                // Naviguer vers la page Liste des Écrivains
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WriterListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Paramètres'),
              onTap: () {
                // Ajouter une page pour les paramètres si nécessaire
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Bienvenue dans l\'application de gestion de bibliothèque'),
      ),
    );
  }
}

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Livres'),
      ),
      body: Center(
        child: Text('Ici, la liste des livres sera affichée.'),
      ),
    );
  }
}

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
    );
  }
}
