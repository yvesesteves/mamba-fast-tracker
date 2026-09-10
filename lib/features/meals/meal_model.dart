class Meal {
  final String id;
  final String name;
  final int calories;
  final DateTime time;

  Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.time,
  });

  // transforma o objeto em um `Mapa` para salvar no banco de dados local (Hive)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'time': time.toIso8601String(),
    };
  }

  // Faz o processo inverso
  factory Meal.fromMap(Map<dynamic, dynamic> map) {
    return Meal(
      id: map['id'],
      name: map['name'],
      calories: map['calories'],
      time: DateTime.parse(map['time']),
    );
  }
}