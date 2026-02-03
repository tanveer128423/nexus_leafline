class Category {
  final int id;
  final String name;
  final String icon;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'icon': icon, 'description': description};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      description: map['description'],
    );
  }
}
