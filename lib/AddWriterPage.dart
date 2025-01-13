import 'package:flutter/material.dart';
import 'db_helper.dart';

class AddWriterPage extends StatefulWidget {
  @override
  _AddWriterPageState createState() => _AddWriterPageState();
}

class _AddWriterPageState extends State<AddWriterPage> {
  final _formKey = GlobalKey<FormState>();
  String? _nom;
  String? _prenom;
  String? _tel;

  Future<void> _addWriter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Add the writer to the database
      await DBHelper().insert('ecrivains', {
        'nom': _nom,
        'prenom': _prenom,
        'tel': _tel,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Écrivain ajouté avec succès!')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Écrivain'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nom = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _prenom = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tel = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addWriter,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
