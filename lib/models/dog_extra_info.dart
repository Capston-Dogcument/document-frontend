class DogExtraInfo {
  final String? vaccinationStatus; // 예방접종 여부
  final bool isNeutered; // 중성화 여부
  final String? diseases; // 질병 정보
  final bool isTakingSupplements; // 영양제 복용 여부
  final String? supplements; // 복용 중인 영양제
  final int? supplementFrequency; // 영양제 복용 주기 (일)
  final int? supplementTimesPerDay; // 영양제 복용 횟수 (회)
  final DateTime? supplementStartDate; // 영양제 복용 시작일
  final DateTime? supplementEndDate; // 영양제 복용 종료일
  final bool isTakingMedicine; // 약 복용 여부
  final String? medicines; // 복용 중인 약
  final int? medicineFrequency; // 약 복용 주기 (일)
  final int? medicineTimesPerDay; // 약 복용 횟수 (회)
  final DateTime? medicineStartDate; // 약 복용 시작일
  final DateTime? medicineEndDate; // 약 복용 종료일

  DogExtraInfo({
    this.vaccinationStatus,
    this.isNeutered = false,
    this.diseases,
    this.isTakingSupplements = false,
    this.supplements,
    this.supplementFrequency,
    this.supplementTimesPerDay,
    this.supplementStartDate,
    this.supplementEndDate,
    this.isTakingMedicine = false,
    this.medicines,
    this.medicineFrequency,
    this.medicineTimesPerDay,
    this.medicineStartDate,
    this.medicineEndDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'vaccinationStatus': vaccinationStatus,
      'isNeutered': isNeutered,
      'diseases': diseases,
      'isTakingSupplements': isTakingSupplements,
      'supplements': supplements,
      'supplementFrequency': supplementFrequency,
      'supplementTimesPerDay': supplementTimesPerDay,
      'supplementStartDate': supplementStartDate?.toIso8601String(),
      'supplementEndDate': supplementEndDate?.toIso8601String(),
      'isTakingMedicine': isTakingMedicine,
      'medicines': medicines,
      'medicineFrequency': medicineFrequency,
      'medicineTimesPerDay': medicineTimesPerDay,
      'medicineStartDate': medicineStartDate?.toIso8601String(),
      'medicineEndDate': medicineEndDate?.toIso8601String(),
    };
  }

  factory DogExtraInfo.fromJson(Map<String, dynamic> json) {
    return DogExtraInfo(
      vaccinationStatus: json['vaccinationStatus'] as String?,
      isNeutered: json['isNeutered'] as bool? ?? false,
      diseases: json['diseases'] as String?,
      isTakingSupplements: json['isTakingSupplements'] as bool? ?? false,
      supplements: json['supplements'] as String?,
      supplementFrequency: json['supplementFrequency'] as int?,
      supplementTimesPerDay: json['supplementTimesPerDay'] as int?,
      supplementStartDate: json['supplementStartDate'] != null
          ? DateTime.parse(json['supplementStartDate'] as String)
          : null,
      supplementEndDate: json['supplementEndDate'] != null
          ? DateTime.parse(json['supplementEndDate'] as String)
          : null,
      isTakingMedicine: json['isTakingMedicine'] as bool? ?? false,
      medicines: json['medicines'] as String?,
      medicineFrequency: json['medicineFrequency'] as int?,
      medicineTimesPerDay: json['medicineTimesPerDay'] as int?,
      medicineStartDate: json['medicineStartDate'] != null
          ? DateTime.parse(json['medicineStartDate'] as String)
          : null,
      medicineEndDate: json['medicineEndDate'] != null
          ? DateTime.parse(json['medicineEndDate'] as String)
          : null,
    );
  }
}
