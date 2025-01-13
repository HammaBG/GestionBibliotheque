import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image picker
import 'db_helper.dart';

class UpdateLivrePage extends StatefulWidget {
  final Map<String, dynamic> livre; // Book details passed from the list page

  UpdateLivrePage({required this.livre});

  @override
  _UpdateLivrePageState createState() => _UpdateLivrePageState();
}

class _UpdateLivrePageState extends State<UpdateLivrePage> {
  final _formKey = GlobalKey<FormState>();
  late String _titre;
  late String _isbn;
  late String _dateSortie;
  late String _photo;
  late int _selectedEcrivainId;
  List<Map<String, dynamic>> _ecrivains = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize the fields with existing book data
    _titre = widget.livre['titre'];
    _isbn = widget.livre['isbn'];
    _dateSortie = widget.livre['dateSortie'];
    _photo = widget.livre['photo'] ?? '';
    _selectedEcrivainId = widget.livre['ecrivainId'];
    _loadEcrivains();
  }

  // Fetch the écrivains from the database
  Future<void> _loadEcrivains() async {
    final data = await DBHelper().fetchAll('ecrivains');
    setState(() {
      _ecrivains = data;
    });
  }

  // Update Livre in the database
  Future<void> _updateLivre() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await DBHelper().updateBook({
        'titre': _titre,
        'isbn': _isbn,
        'dateSortie': _dateSortie,
        'photo': _photo,
        'ecrivainId': _selectedEcrivainId,
      }, widget.livre['id']);
      Navigator.pop(context); // Close the page after updating the book
    }
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photo = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le Livre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title input field
              TextFormField(
                initialValue: _titre,
                decoration: InputDecoration(labelText: 'Titre'),
                onSaved: (value) {
                  _titre = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              // ISBN input field
              TextFormField(
                initialValue: _isbn,
                decoration: InputDecoration(labelText: 'ISBN'),
                onSaved: (value) {
                  _isbn = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un ISBN';
                  }
                  return null;
                },
              ),
              // Date of Release input field
              TextFormField(
                initialValue: _dateSortie,
                decoration: InputDecoration(labelText: 'Date de Sortie'),
                onSaved: (value) {
                  _dateSortie = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une date de sortie';
                  }
                  return null;
                },
              ),
              // Dropdown to select the Écrivain
              DropdownButtonFormField<int>(
                value: _selectedEcrivainId,
                hint: Text('Sélectionner un Écrivain'),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedEcrivainId = newValue!;
                  });
                },
                onSaved: (value) {
                  _selectedEcrivainId = value!;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un écrivain';
                  }
                  return null;
                },
                items: _ecrivains.map((ecrivain) {
                  return DropdownMenuItem<int>(
                    value: ecrivain['id'],
                    child: Text('${ecrivain['nom']} ${ecrivain['prenom']}'),
                  );
                }).toList(),
              ),
              // Button to pick an image
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Choisir une image'),
              ),
              // Display selected image preview
              if (_photo.isNotEmpty)
                Image.file(
                  File(_photo),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              // Update Book Button
              ElevatedButton(
                onPressed: _updateLivre,
                child: Text('Mettre à jour le Livre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
