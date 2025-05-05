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

  factory DogInfo.fromJson(Map<String, dynamic> json) {
    return DogInfo(
      id: json['id'],
      name: json['name'],
      breed: json['breed'],
      weight: (json['weight'] is double)
          ? json['weight']
          : double.tryParse(json['weight'].toString()) ?? 0.0,
      intakeDate: json['intakeDate'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'breed': breed,
      'weight': weight,
      'intakeDate': intakeDate,
      'gender': gender,
    };
  }
}
