import 'package:document/screens/check_obesity_screen.dart';
import 'package:flutter/material.dart';
import 'package:document/widgets/basic_button.dart';
import 'package:document/widgets/bottom_tapbar.dart';
import 'package:document/widgets/input_field.dart';
import 'package:document/widgets/progressbar.dart';
import 'package:document/widgets/select_button.dart';
import '../models/dog_info.dart';
import '../services/dog_info_service.dart';

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  _BasicInformationScreenState createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
  bool isMaleSelected = false;
  bool isFemaleSelected = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController intakeDateController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    weightController.dispose();
    intakeDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("강아지 기본 정보 등록"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // ProgressBar
              const ProgressBar(
                steps: [false, false, false, false, false],
              ),
              const SizedBox(height: 20),

              // Form Fields in a Scrollable Container
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Input Fields
                      InputField(
                        label: '이름',
                        hintText: '이름을 입력하세요.',
                        controller: nameController,
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        label: '견종',
                        hintText: '견종을 입력하세요. (믹스견인 경우 믹스라고 입력)',
                        controller: breedController,
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        label: '체중',
                        hintText: '체중을 입력하세요.',
                        controller: weightController,
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        label: '입소 날짜',
                        hintText: '입소한 날짜를 입력하세요. (YYYY.MM.DD)',
                        controller: intakeDateController,
                      ),
                      const SizedBox(height: 20),

                      // 성별 선택
                      const Text(
                        '성별',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.43,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Gender Buttons using SelectableButton
                      Row(
                        children: [
                          SelectableButton(
                            label: '수컷',
                            isSelected: isMaleSelected,
                            onPressed: () {
                              setState(() {
                                isMaleSelected = !isMaleSelected;
                                isFemaleSelected = false;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          SelectableButton(
                            label: '암컷',
                            isSelected: isFemaleSelected,
                            onPressed: () {
                              setState(() {
                                isFemaleSelected = !isFemaleSelected;
                                isMaleSelected = false;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Submit Button using BasicButton
                      BasicButton(
                        label: '강아지 기본 정보 등록',
                        onPressed: () async {
                          final dogInfo = DogInfo(
                            name: nameController.text,
                            breed: breedController.text,
                            weight:
                                double.tryParse(weightController.text) ?? 0.0,
                            intakeDate: intakeDateController.text,
                            gender: isMaleSelected ? '수컷' : '암컷',
                          );

                          final service = DogInfoService();
                          final result = await service.registerDogInfo(dogInfo);

                          if (result != null && result.id != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CheckObesityScreen(dogId: result.id!),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('등록에 실패했습니다.')),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // 디버깅용 다음단계 버튼 수정
                      BasicButton(
                        label: '다음단계(디버깅용)',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CheckObesityScreen(dogId: 1), // 임시 ID
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
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
