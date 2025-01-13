import 'package:flutter/material.dart';
import 'db_helper.dart';

class UpdateLivrePage extends StatefulWidget {
  final Map<String, dynamic> livre;

  UpdateLivrePage({required this.livre});

  @override
  _UpdateLivrePageState createState() => _UpdateLivrePageState();
}

class _UpdateLivrePageState extends State<UpdateLivrePage> {
  final _formKey = GlobalKey<FormState>();
  String? _titre;
  String? _isbn;
  String? _dateSortie;
  String? _photo;
  int? _ecrivainId;

  @override
  void initState() {
    super.initState();
    _titre = widget.livre['titre'];
    _isbn = widget.livre['isbn'];
    _dateSortie = widget.livre['dateSortie'];
    _photo = widget.livre['photo'];
    _ecrivainId = widget.livre['ecrivainId'];
  }

  Future<void> _updateLivre() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Update the book in the database
      await DBHelper().updateBook({
        'titre': _titre,
        'isbn': _isbn,
        'dateSortie': _dateSortie,
        'photo': _photo,
        'ecrivainId': _ecrivainId,
      }, widget.livre['id']);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Livre mis à jour avec succès!')),
      );

      // Navigate back to the livre list page
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mettre à jour le Livre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _titre,
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
                initialValue: _isbn,
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
                initialValue: _dateSortie,
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
                initialValue: _photo,
                decoration: InputDecoration(labelText: 'Photo URL'),
                onSaved: (value) {
                  _photo = value;
                },
              ),
              TextFormField(
                initialValue: _ecrivainId.toString(),
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
                onPressed: _updateLivre,
                child: Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
