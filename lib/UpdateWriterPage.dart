import 'package:flutter/material.dart';
import 'db_helper.dart';

class UpdateWriterPage extends StatefulWidget {
  final Map<String, dynamic> writer; // Writer details passed from the list

  UpdateWriterPage({required this.writer});

  @override
  _UpdateWriterPageState createState() => _UpdateWriterPageState();
}

class _UpdateWriterPageState extends State<UpdateWriterPage> {
  final _formKey = GlobalKey<FormState>();
  String? _nom;
  String? _prenom;
  String? _tel;

  @override
  void initState() {
    super.initState();
    // Populate the form with the current writer's details
    _nom = widget.writer['nom'];
    _prenom = widget.writer['prenom'];
    _tel = widget.writer['tel'];
  }

  Future<void> _updateWriter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Update the writer in the database
      await DBHelper().update(
        'ecrivains',
        {
          'nom': _nom,
          'prenom': _prenom,
          'tel': _tel,
        },
        'id = ?',
        [widget.writer['id']],
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Écrivain mis à jour avec succès!')),
      );

      // Navigate back to the writer list page
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mettre à jour l\'Écrivain'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nom,
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
                initialValue: _prenom,
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
                initialValue: _tel,
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
                onPressed: _updateWriter,
                child: Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
