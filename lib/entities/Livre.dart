class Livre {
  int? id;
  String titre;
  String isbn;
  DateTime dateSortie;
  String? photo;
  int ecrivainId;

  Livre({
    this.id,
    required this.titre,
    required this.isbn,
    required this.dateSortie,
    this.photo,
    required this.ecrivainId,
  });

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
