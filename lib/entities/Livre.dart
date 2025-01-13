class Livre {
  int? id; // Identifiant unique (nullable pour insertion dans SQLite)
  String titre; // Titre du livre
  String isbn; // ISBN du livre
  DateTime dateSortie; // Date de sortie
  String? photo; // Chemin de la photo (nullable)
  int ecrivainId; // ID de l'écrivain lié

  // Constructeur
  Livre({
    this.id,
    required this.titre,
    required this.isbn,
    required this.dateSortie,
    this.photo,
    required this.ecrivainId,
  });

  // Convertir un Livre en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'isbn': isbn,
      'dateSortie': dateSortie.toIso8601String(),
      'photo': photo,
      'ecrivainId': ecrivainId,
    };
  }

  // Convertir un Map en Livre (pour SQLite)
  factory Livre.fromMap(Map<String, dynamic> map) {
    return Livre(
      id: map['id'],
      titre: map['titre'],
      isbn: map['isbn'],
      dateSortie: DateTime.parse(map['dateSortie']),
      photo: map['photo'],
      ecrivainId: map['ecrivainId'],
    );
  }
}
