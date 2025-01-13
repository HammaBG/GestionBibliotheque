import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'BookListPage.dart';
import 'WriterListPage.dart';

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredEcrivains = [];

  // Filter écrivains based on search query
  Future<void> _filterEcrivains(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredEcrivains = [];
      });
      return;
    }

    // Fetch écrivains and filter based on the search query
    final data = await DBHelper().fetchAll('ecrivains');
    final filtered = data.where((ecrivain) {
      final nom = ecrivain['nom'].toLowerCase();
      final prenom = ecrivain['prenom'].toLowerCase();
      final tel = ecrivain['tel'].toLowerCase();
      return nom.contains(query.toLowerCase()) ||
          prenom.contains(query.toLowerCase()) ||
          tel.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredEcrivains = filtered;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterEcrivains(_searchController.text);
    });
  }

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Search field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Rechercher un écrivain',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Show search results
              _filteredEcrivains.isEmpty
                  ? Text('Aucun écrivain trouvé')
                  : Expanded(
                child: ListView.builder(
                  itemCount: _filteredEcrivains.length,
                  itemBuilder: (context, index) {
                    final ecrivain = _filteredEcrivains[index];
                    return ListTile(
                      title: Text('${ecrivain['nom']} ${ecrivain['prenom']}'),
                      subtitle: Text('Tel: ${ecrivain['tel']}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
