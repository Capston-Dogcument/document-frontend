import 'package:flutter/material.dart';
import 'package:document/widgets/basic_button.dart';
import 'package:document/widgets/bottom_tapbar.dart';
import 'package:document/widgets/progressbar.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:document/screens/take_skin_photo_screen.dart';

class CheckSkinScreen extends StatefulWidget {
  const CheckSkinScreen({super.key});

  @override
  State<CheckSkinScreen> createState() => _CheckSkinScreenState();
}

class _CheckSkinScreenState extends State<CheckSkinScreen> {
  XFile? _photo;
  bool showResult = false;
  Map<String, dynamic>? skinResult;

  Future<void> _navigateToCamera() async {
    final result = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(builder: (context) => const TakeSkinPhotoScreen()),
    );

    if (result != null) {
      setState(() {
        _photo = result;
        showResult = false;
        skinResult = null;
      });
    }
  }

  Future<void> _analyzeSkin() async {
    // TODO: 백엔드 통신 구현
    setState(() {
      showResult = true;
      skinResult = {
        "condition": "피부염",
        "severity": "경증",
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("피부 질환 측정"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const ProgressBar(
                steps: [true, true, false, false, false],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '강아지의 피부 질환을 측정하는 페이지입니다.\n'
                        '강아지의 피부 사진을 업로드해주세요.\n'
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
                          ),
                        ),
                        child: _photo != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_photo!.path),
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

                      // 결과 표시
                      if (showResult && skinResult != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '피부 질환 진단 결과',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '진단',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      skinResult!["condition"],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // 버튼들
                      if (_photo == null)
                        BasicButton(
                          label: '강아지 피부 사진 등록',
                          onPressed: _navigateToCamera,
                        )
                      else ...[
                        BasicButton(
                          label: '결과보기',
                          onPressed: _analyzeSkin,
                        ),
                        if (showResult)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: BasicButton(
                              label: '다음단계',
                              onPressed: () {
                                // TODO: 다음 단계로 이동
                              },
                            ),
                          ),
                      ],
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
