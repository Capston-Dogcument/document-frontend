import 'package:flutter/material.dart';
import 'package:document/models/dog_extra_info.dart';
import 'package:document/widgets/basic_button.dart';
import 'package:document/widgets/bottom_tapbar.dart';
import 'package:document/widgets/progressbar.dart';
import 'package:document/widgets/input_field.dart';

class RegisterDogExtraInfoScreen extends StatefulWidget {
  final int dogId;

  const RegisterDogExtraInfoScreen({
    super.key,
    required this.dogId,
  });

  @override
  State<RegisterDogExtraInfoScreen> createState() =>
      _RegisterDogExtraInfoScreenState();
}

class _RegisterDogExtraInfoScreenState
    extends State<RegisterDogExtraInfoScreen> {
  final TextEditingController vaccinationController = TextEditingController();
  bool isNeutered = false;
  final TextEditingController diseasesController = TextEditingController();

  // 영양제 관련
  bool isTakingSupplements = false;
  final TextEditingController supplementsController = TextEditingController();
  final TextEditingController supplementFrequencyController =
      TextEditingController();
  final TextEditingController supplementTimesPerDayController =
      TextEditingController();
  DateTime? supplementStartDate;
  DateTime? supplementEndDate;

  // 약 관련
  bool isTakingMedicine = false;
  final TextEditingController medicinesController = TextEditingController();
  final TextEditingController medicineFrequencyController =
      TextEditingController();
  final TextEditingController medicineTimesPerDayController =
      TextEditingController();
  DateTime? medicineStartDate;
  DateTime? medicineEndDate;

  @override
  void dispose() {
    vaccinationController.dispose();
    diseasesController.dispose();
    supplementsController.dispose();
    supplementFrequencyController.dispose();
    supplementTimesPerDayController.dispose();
    medicinesController.dispose();
    medicineFrequencyController.dispose();
    medicineTimesPerDayController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, bool isStart, bool isSupplement) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isSupplement) {
          if (isStart) {
            supplementStartDate = picked;
          } else {
            supplementEndDate = picked;
          }
        } else {
          if (isStart) {
            medicineStartDate = picked;
          } else {
            medicineEndDate = picked;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('유기견 기타 정보 등록'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const ProgressBar(
                steps: [true, true, true, true, false],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 예방접종 여부
                      InputField(
                        label: '예방접종 여부',
                        hintText: '예방접종 여부를 입력하세요. (선택)',
                        controller: vaccinationController,
                      ),
                      const SizedBox(height: 20),

                      // 중성화 여부
                      const Text(
                        '중성화 여부',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isNeutered = true),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isNeutered
                                      ? Colors.black
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    '중성화',
                                    style: TextStyle(
                                      color: isNeutered
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isNeutered = false),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: !isNeutered
                                      ? Colors.black
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    '미중성화',
                                    style: TextStyle(
                                      color: !isNeutered
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 질병 입력
                      InputField(
                        label: '질병 입력',
                        hintText: '질병 여부를 입력하세요. (선택)',
                        controller: diseasesController,
                      ),
                      const SizedBox(height: 20),

                      // 영양제 복용
                      Row(
                        children: [
                          Checkbox(
                            value: isTakingSupplements,
                            onChanged: (value) {
                              setState(() {
                                isTakingSupplements = value ?? false;
                              });
                            },
                          ),
                          const Text('영양제 복용'),
                        ],
                      ),
                      if (isTakingSupplements) ...[
                        InputField(
                          label: '영양제 입력',
                          hintText: '복용하는 영양제를 입력하세요.',
                          controller: supplementsController,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: InputField(
                                label: '복용 주기',
                                hintText: '일',
                                controller: supplementFrequencyController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('일에'),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InputField(
                                label: '복용 횟수',
                                hintText: '회',
                                controller: supplementTimesPerDayController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('회'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context, true, true),
                                child: InputField(
                                  label: '시작일',
                                  hintText: '시작일 선택',
                                  controller: TextEditingController(
                                    text: supplementStartDate
                                            ?.toString()
                                            .split(' ')[0] ??
                                        '',
                                  ),
                                  enabled: false,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('부터'),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context, false, true),
                                child: InputField(
                                  label: '종료일',
                                  hintText: '종료일 선택',
                                  controller: TextEditingController(
                                    text: supplementEndDate
                                            ?.toString()
                                            .split(' ')[0] ??
                                        '',
                                  ),
                                  enabled: false,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('까지'),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),

                      // 약 복용
                      Row(
                        children: [
                          Checkbox(
                            value: isTakingMedicine,
                            onChanged: (value) {
                              setState(() {
                                isTakingMedicine = value ?? false;
                              });
                            },
                          ),
                          const Text('약 복용'),
                        ],
                      ),
                      if (isTakingMedicine) ...[
                        InputField(
                          label: '약 입력',
                          hintText: '복용하는 약을 입력하세요.',
                          controller: medicinesController,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: InputField(
                                label: '복용 주기',
                                hintText: '일',
                                controller: medicineFrequencyController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('일에'),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InputField(
                                label: '복용 횟수',
                                hintText: '회',
                                controller: medicineTimesPerDayController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('회'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context, true, false),
                                child: InputField(
                                  label: '시작일',
                                  hintText: '시작일 선택',
                                  controller: TextEditingController(
                                    text: medicineStartDate
                                            ?.toString()
                                            .split(' ')[0] ??
                                        '',
                                  ),
                                  enabled: false,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('부터'),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context, false, false),
                                child: InputField(
                                  label: '종료일',
                                  hintText: '종료일 선택',
                                  controller: TextEditingController(
                                    text: medicineEndDate
                                            ?.toString()
                                            .split(' ')[0] ??
                                        '',
                                  ),
                                  enabled: false,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('까지'),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),

                      // 등록 버튼
                      BasicButton(
                        label: '강아지 기타 정보 등록하기',
                        onPressed: () {
                          // TODO: API 연동
                          final extraInfo = DogExtraInfo(
                            vaccinationStatus: vaccinationController.text,
                            isNeutered: isNeutered,
                            diseases: diseasesController.text,
                            isTakingSupplements: isTakingSupplements,
                            supplements: supplementsController.text,
                            supplementFrequency: int.tryParse(
                                supplementFrequencyController.text),
                            supplementTimesPerDay: int.tryParse(
                                supplementTimesPerDayController.text),
                            supplementStartDate: supplementStartDate,
                            supplementEndDate: supplementEndDate,
                            isTakingMedicine: isTakingMedicine,
                            medicines: medicinesController.text,
                            medicineFrequency:
                                int.tryParse(medicineFrequencyController.text),
                            medicineTimesPerDay: int.tryParse(
                                medicineTimesPerDayController.text),
                            medicineStartDate: medicineStartDate,
                            medicineEndDate: medicineEndDate,
                          );
                          print(extraInfo.toJson());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomTabBar(
        tabItems: [
          TabItem(icon: '🏠', label: '대시보드', onTap: () {}),
          TabItem(icon: '🐶', label: '등록', onTap: () {}),
          TabItem(icon: '📊', label: '건강', onTap: () {}),
          TabItem(icon: '🏡', label: '입양', onTap: () {}),
          TabItem(icon: '🛠️', label: '설정', onTap: () {}),
        ],
      ),
    );
  }
}
