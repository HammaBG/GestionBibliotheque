import 'package:flutter/material.dart';


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