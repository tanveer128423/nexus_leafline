class Plant {
  final int? id;
  final String name;
  final String scientificName;
  final String description;
  final String imageUrl;
  final List<String> careInstructions;
  final int categoryId;
  final String watering;
  final String sunlight;
  final String soil;
  final bool isApproved;

  Plant({
    this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.imageUrl,
    required this.careInstructions,
    required this.categoryId,
    required this.watering,
    required this.sunlight,
    required this.soil,
    this.isApproved = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'description': description,
      'imageUrl': imageUrl,
      'careInstructions': careInstructions.join(';'),
      'categoryId': categoryId,
      'watering': watering,
      'sunlight': sunlight,
      'soil': soil,
      'isApproved': isApproved ? 1 : 0,
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      name: map['name'],
      scientificName: map['scientificName'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      careInstructions: (map['careInstructions'] as String).split(';'),
      categoryId: map['categoryId'],
      watering: map['watering'],
      sunlight: map['sunlight'],
      soil: map['soil'],
      isApproved: (map['isApproved'] ?? 1) == 1,
    );
  }
}
