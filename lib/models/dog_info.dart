class DogInfo {
  final int? id;
  final String name;
  final String breed;
  final double weight;
  final String intakeDate;
  final String gender;

  DogInfo({
    this.id,
    required this.name,
    required this.breed,
    required this.weight,
    required this.intakeDate,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'weight': weight,
      'intakeDate': intakeDate,
      'gender': gender,
    };
  }

  factory DogInfo.fromJson(Map<String, dynamic> json) {
    return DogInfo(
      id: json['id'],
      name: json['name'],
      breed: json['breed'],
      weight: json['weight'].toDouble(),
      intakeDate: json['intakeDate'],
      gender: json['gender'],
    );
  }
}
