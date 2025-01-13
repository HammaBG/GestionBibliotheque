import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image picker
import 'db_helper.dart';

class AddLivrePage extends StatefulWidget {
  @override
  _AddLivrePageState createState() => _AddLivrePageState();
}

class _AddLivrePageState extends State<AddLivrePage> {
  final _formKey = GlobalKey<FormState>();
  String _titre = '';
  String _isbn = '';
  String _dateSortie = '';
  String _photo = ''; // Path to the selected photo
  int? _selectedEcrivainId; // Store selected écrivain ID
  List<Map<String, dynamic>> _ecrivains = []; // Store list of écrivains
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Fetch the écrivains from the database
  Future<void> _loadEcrivains() async {
    final data = await DBHelper().fetchAll('ecrivains'); // Fetch all écrivains
    setState(() {
      _ecrivains = data;
    });
  }

  // Add Livre to the database
  Future<void> _addLivre() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await DBHelper().insert('livres', {
        'titre': _titre,
        'isbn': _isbn,
        'dateSortie': _dateSortie,
        'photo': _photo,
        'ecrivainId': _selectedEcrivainId,
      });
      Navigator.pop(context); // Close the page after adding the book
    }
  }

  // Pick an image from the gallery or take a new photo
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photo = pickedFile.path; // Save the file path of the selected image
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEcrivains(); // Load écrivains when the page is initialized
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
              // Title input field
              TextFormField(
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
                    _selectedEcrivainId = newValue;
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
              // Add Book Button
              ElevatedButton(
                onPressed: _addLivre,
                child: Text('Ajouter le Livre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
