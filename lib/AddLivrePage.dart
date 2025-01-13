import 'package:flutter/material.dart';
import 'db_helper.dart';

class AddLivrePage extends StatefulWidget {
  @override
  _AddLivrePageState createState() => _AddLivrePageState();
}

class _AddLivrePageState extends State<AddLivrePage> {
  final _formKey = GlobalKey<FormState>();
  String? _titre;
  String? _isbn;
  String? _dateSortie;
  String? _photo;
  int? _ecrivainId;

  Future<void> _addLivre() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Add the new book to the database
      await DBHelper().insertBook({
        'titre': _titre,
        'isbn': _isbn,
        'dateSortie': _dateSortie,
        'photo': _photo,
        'ecrivainId': _ecrivainId,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Livre ajouté avec succès!')),
      );

      // Navigate back to the livre list page
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Livre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _titre = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ISBN'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un ISBN.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _isbn = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date de sortie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une date de sortie.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _dateSortie = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Photo URL'),
                onSaved: (value) {
                  _photo = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ID de l\'Écrivain'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'ID de l\'écrivain.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ecrivainId = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addLivre,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
