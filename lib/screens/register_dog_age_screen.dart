import 'package:flutter/material.dart';

class RegisterDogAgeScreen extends StatefulWidget {
  const RegisterDogAgeScreen({super.key});

  @override
  State<RegisterDogAgeScreen> createState() => _RegisterDogAgeScreenState();
}

class _RegisterDogAgeScreenState extends State<RegisterDogAgeScreen> {
  bool knowsAge = true;
  final TextEditingController ageController = TextEditingController();

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
              ),
            const SizedBox(height: 24),

            // 치아 정보
            const Text('치아 정보', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        color: hasAdultTeeth ? Colors.black : Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '유치 없음',
                          style: TextStyle(
                            color: hasAdultTeeth ? Colors.white : Colors.black,
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
            const Text('치석 여부', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        color: hasToothDamage ? Colors.black : Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '깨지거나 빠진 치아 있음',
                          style: TextStyle(
                            color: hasToothDamage ? Colors.white : Colors.black,
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
            const SizedBox(height: 32),

            // 등록 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 등록 로직 작성
                },
                child: const Text('강아지 나이 예상하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
