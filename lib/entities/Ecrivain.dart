class Ecrivain {
  int? id; // Identifiant unique (nullable pour insertion dans SQLite)
  String nom; // Nom de l'écrivain
  String prenom; // Prénom de l'écrivain
  String tel; // Numéro de téléphone

  // Constructeur
  Ecrivain({
    this.id,
    required this.nom,
    required this.prenom,
    required this.tel,
  });

  // Convertir un Ecrivain en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'tel': tel,
    };
  }

  // Convertir un Map en Ecrivain (pour SQLite)
  factory Ecrivain.fromMap(Map<String, dynamic> map) {
    return Ecrivain(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      tel: map['tel'],
    );
  }
}
