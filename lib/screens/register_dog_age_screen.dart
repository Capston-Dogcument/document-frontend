import 'package:flutter/material.dart';
import 'package:document/screens/register_dog_extra_info_screen.dart';
import 'package:document/widgets/progressbar.dart';
import 'package:document/widgets/basic_button.dart';
import 'package:document/services/dog_info_service.dart';

class RegisterDogAgeScreen extends StatefulWidget {
  final int dogId;

  const RegisterDogAgeScreen({
    super.key,
    required this.dogId,
  });

  @override
  State<RegisterDogAgeScreen> createState() => _RegisterDogAgeScreenState();
}

class _RegisterDogAgeScreenState extends State<RegisterDogAgeScreen> {
  bool knowsAge = true;
  final TextEditingController ageController = TextEditingController();
  final DogInfoService _dogInfoService = DogInfoService();
  bool _isLoading = false;

  // 치아 정보
  bool hasBabyTeeth = false;
  bool hasAdultTeeth = true;

  // 치아 마모 상태
  double toothWear = 3;

  // 치석 여부
  bool hasTartar = false;

  // 치아 손상 유무
  bool hasToothDamage = false;

  // 눈 색깔
  final TextEditingController eyeColorController = TextEditingController();

  // 코 주변 회색 털
  double grayHair = 3;

  @override
  void dispose() {
    ageController.dispose();
    eyeColorController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (knowsAge) {
      if (ageController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('강아지 나이를 입력해주세요.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final age = int.parse(ageController.text);
        await _dogInfoService.saveDogAge(widget.dogId, age);

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterDogExtraInfoScreen(
                dogId: widget.dogId,
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('나이 저장 실패: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      if (eyeColorController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('눈 색깔을 입력해주세요.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final result = await _dogInfoService.predictDogAge(
          widget.dogId,
          hasDeciduousTeeth: hasBabyTeeth,
          toothWearLevel: toothWear.round(),
          hasTartar: hasTartar,
          hasToothDamage: hasToothDamage,
          eyeColor: eyeColorController.text,
          grayHairLevelAroundNose: grayHair.round(),
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // 예상 나이 다이얼로그 표시
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('강아지 예상 나이'),
                content: Text('예상 나이는 ${result['predictedAge']}살입니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterDogExtraInfoScreen(
                            dogId: widget.dogId,
                          ),
                        ),
                      );
                    },
                    child: const Text('다음 단계'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('나이 예측 실패: $e')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('유기견 나이 등록'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ProgressBar(
              steps: [true, true, true, false, false],
            ),
            const SizedBox(height: 24),
            // 나이 알고/모름 체크박스
            Row(
              children: [
                Checkbox(
                  value: knowsAge,
                  onChanged: (v) => setState(() => knowsAge = true),
                ),
                const Text('강아지 나이를 알고있음'),
                const SizedBox(width: 16),
                Checkbox(
                  value: !knowsAge,
                  onChanged: (v) => setState(() => knowsAge = false),
                ),
                const Text('강아지 나이를 모름'),
              ],
            ),
            const SizedBox(height: 8),
            // 나이 입력
            if (knowsAge)
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '강아지 나이(년)',
                  border: OutlineInputBorder(),
                ),
              )
            else ...[
              // 치아 정보
              const Text('치아 정보',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        hasBabyTeeth = true;
                        hasAdultTeeth = false;
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: hasBabyTeeth ? Colors.black : Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '유치 있음',
                            style: TextStyle(
                              color: hasBabyTeeth ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        hasBabyTeeth = false;
                        hasAdultTeeth = true;
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              hasAdultTeeth ? Colors.black : Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '유치 없음',
                            style: TextStyle(
                              color:
                                  hasAdultTeeth ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 치아 마모 상태 슬라이드
              const Text('치아 마모 상태 (0-정상, 5-마모가 매우 심함)'),
              Slider(
                value: toothWear,
                min: 0,
                max: 5,
                divisions: 5,
                label: toothWear.round().toString(),
                onChanged: (v) => setState(() => toothWear = v),
              ),
              const SizedBox(height: 24),

              // 치석 여부
              const Text('치석 여부',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => hasTartar = true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: hasTartar ? Colors.black : Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '치석 있음',
                            style: TextStyle(
                              color: hasTartar ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => hasTartar = false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: !hasTartar ? Colors.black : Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '치석 없음',
                            style: TextStyle(
                              color: !hasTartar ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 치아 손상 유무
              const Text('치아 손상 유무',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => hasToothDamage = true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              hasToothDamage ? Colors.black : Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '깨지거나 빠진 치아 있음',
                            style: TextStyle(
                              color:
                                  hasToothDamage ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => hasToothDamage = false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              !hasToothDamage ? Colors.black : Colors.grey[200],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            '없음',
                            style: TextStyle(
                              color:
                                  !hasToothDamage ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 눈 색깔
              const Text('눈 색깔', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: eyeColorController,
                decoration: const InputDecoration(
                  hintText: '눈 색깔을 입력해주세요.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // 코 주변 회색 털 슬라이드
              const Text('코 주변 회색 털 (0-회색 털 없음, 5-회색 털 매우 많음)'),
              Slider(
                value: grayHair,
                min: 0,
                max: 5,
                divisions: 5,
                label: grayHair.round().toString(),
                onChanged: (v) => setState(() => grayHair = v),
              ),
            ],
            const SizedBox(height: 32),

            // 등록 버튼
            BasicButton(
              label: _isLoading
                  ? '처리 중...'
                  : (knowsAge ? '강아지 나이 입력하기' : '강아지 나이 예상하기'),
              onPressed: _isLoading ? () {} : _handleSubmit,
            ),
            const SizedBox(height: 12),
            // 디버깅용 다음단계 버튼
            BasicButton(
              label: '다음단계(디버깅용)',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterDogExtraInfoScreen(
                      dogId: widget.dogId,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
