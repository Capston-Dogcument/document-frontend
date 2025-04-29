import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final List<bool> steps; // 각 단계의 진행 상태 (완료/진행 중/아직 안 함)
  final double totalWidth;

  const ProgressBar({
    super.key,
    required this.steps,
    this.totalWidth = 300.0, // 기본적으로 300px로 설정, 필요에 따라 조정 가능
  });

  @override
  Widget build(BuildContext context) {
    double stepWidth = totalWidth / steps.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (index) {
        bool isCompleted = steps[index];
        bool isCurrent = index == steps.indexWhere((step) => !step);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 원형 버튼
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? Colors.blue // 완료된 단계
                    : isCurrent
                        ? Colors.purple // 진행 중인 단계
                        : Colors.grey, // 아직 진행되지 않은 단계
                border: Border.all(
                  color: isCompleted ? Colors.blue : Colors.grey,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            // 단계 텍스트
            Text(
              '단계 ${index + 1}',
              style: TextStyle(
                fontSize: 12,
                color: isCompleted
                    ? Colors.blue
                    : isCurrent
                        ? Colors.purple
                        : Colors.grey,
              ),
            ),
          ],
        );
      }),
    );
  }
}
