import 'package:flutter/material.dart';
import 'package:document/widgets/basic_button.dart';
import 'package:document/widgets/bottom_tapbar.dart';
import 'package:document/widgets/progressbar.dart';
import 'dart:io';
import 'package:document/screens/take_photos_screen.dart';

class CheckObesityScreen extends StatefulWidget {
  const CheckObesityScreen({super.key});

  @override
  State<CheckObesityScreen> createState() => _CheckObesityScreenState();
}

class _CheckObesityScreenState extends State<CheckObesityScreen> {
  File? _imageFile; // 이미지 파일 저장 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("비만도 측정"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // ProgressBar
              const ProgressBar(
                steps: [true, false, false, false, false], // 첫 단계 진행 중
              ),
              const SizedBox(height: 20),

              // Content in a Scrollable Container
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 설명 텍스트
                      const Text(
                        '강아지의 비만도를 측정하는 페이지입니다.\n'
                        '강아지의 사진은 총 5장이 필요합니다.\n'
                        '경우에 따라 털이 너무 많은 경우 측정이 제한될 수 있습니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 이미지 프리뷰
                      Container(
                        width: double.infinity,
                        height: 203,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '사진을 촬영해주세요',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),

                      const SizedBox(height: 24),

                      // 버튼들
                      BasicButton(
                        label: '사진 촬영하러 가기',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TakePhotosScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      BasicButton(
                        label: '결과보기',
                        onPressed: () {
                          // 결과 페이지로 이동
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
