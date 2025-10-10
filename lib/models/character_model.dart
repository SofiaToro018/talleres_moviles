class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final String location;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.location,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Desconocido',
      status: json['status'] ?? 'N/A',
      species: json['species'] ?? 'N/A',
      gender: json['gender'] ?? 'N/A',
      image: json['image'] ?? '',
      location: json['location']?['name'] ?? 'Desconocido',
    );
  }
}
