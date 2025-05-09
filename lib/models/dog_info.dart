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
      id: json['id'] as int?,
      name: json['name'] as String,
      breed: json['breed'] as String,
      weight: (json['weight'] as num).toDouble(),
      intakeDate: json['intakeDate'] as String,
      gender: json['gender'] as String,
    );
  }
}
