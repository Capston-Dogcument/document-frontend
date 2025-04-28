import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double totalWidth; // 전체 길이
  final List<double> positions; // 각 구간의 위치
  final Color barColor; // 구간 색상
  final double circleSize; // 원 크기
  final Color circleColor; // 원 색상

  const ProgressBar({
    super.key,
    required this.totalWidth,
    required this.positions,
    this.barColor = const Color(0xFFD1D5DB),
    this.circleSize = 9.5,
    this.circleColor = const Color(0xFF4F46E5),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalWidth,
      height: 30,
      child: Stack(
        children: [
          // 바 구간을 동적으로 생성
          ...positions.map((position) {
            return Positioned(
              left: position,
              top: 14.21,
              child: Container(
                width: 37.22,
                height: 1.32,
                decoration: BoxDecoration(color: barColor),
              ),
            );
          }).toList(),
          // 원 모양 생성
          Positioned(
            left: 0,
            top: 2,
            child: Container(
              width: circleSize * 2,
              height: circleSize * 2,
              decoration: ShapeDecoration(
                shape: OvalBorder(
                  side: BorderSide(
                    width: 6,
                    color: circleColor,
                  ),
                ),
              ),
            ),
          ),
          // 원 내부 작은 점
          Positioned(
            left: 9.31,
            top: 11.25,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: ShapeDecoration(
                color: circleColor,
                shape: const OvalBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
