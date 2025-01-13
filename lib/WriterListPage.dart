import 'package:flutter/material.dart';

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