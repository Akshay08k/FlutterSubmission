class Meal {
  final int id;
  final String name;
  final String type;
  final String description;
  bool isFavorite;

  Meal({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.isFavorite = false,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      type: json['type'],
      description: json['description'],
      isFavorite: json['is_favorite'] == 1,
    );
  }
}
