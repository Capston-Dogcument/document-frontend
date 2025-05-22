import 'package:document/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:document/widgets/basic_button.dart';
import 'package:document/widgets/bottom_tapbar.dart';
import 'package:document/widgets/progressbar.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:document/screens/take_skin_photo_screen.dart';
import 'package:document/screens/register_dog_age_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:document/services/upload_photo_service.dart';

class CheckSkinScreen extends StatefulWidget {
  final int dogId;

  const CheckSkinScreen({
    super.key,
    required this.dogId,
  });

  @override
  State<CheckSkinScreen> createState() => _CheckSkinScreenState();
}

class _CheckSkinScreenState extends State<CheckSkinScreen> {
  XFile? _photo;
  bool showResult = false;
  Map<String, dynamic>? skinResult;
  final ImagePicker _picker = ImagePicker();
  final UploadPhotoService _uploadPhotoService = UploadPhotoService();
  bool _isLoading = false;
  bool _isAnalyzing = false;
  String? _uploadedUrl;

  Future<void> _navigateToCamera() async {
    final bool? proceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('주의사항'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'images/dog_skin_ex.png',
                width: 180,
                height: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              const Text(
                '다음 사진과 같이 피부 질환으로 의심되는 부위를\n'
                '확대하여 찍어주세요.\n'
                '만약 피부 질환으로 의심되는 부위가 존재하지\n'
                '않는다면, 이 단계는 건너뛰어도 좋습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // 건너뛰기
              },
              child: const Text('건너뛰기'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // 확인
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );

    if (proceed == null) return;

    if (proceed) {
      // 확인: 사진 촬영 화면으로 이동
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
    } else {
      // 건너뛰기: 나이 등록 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterDogAgeScreen(
            dogId: widget.dogId,
          ),
        ),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photo = image;
        showResult = false;
        skinResult = null;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_photo == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final urls = await _uploadPhotoService.uploadSkinImage(
        image: File(_photo!.path),
        dogId: widget.dogId,
      );

      if (!mounted) return;

      if (urls.isNotEmpty) {
        setState(() {
          _uploadedUrl = urls.first;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지 업로드에 실패했습니다.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 업로드 실패: $e')),
      );
    }
  }

  Future<void> _analyzeSkin() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final result = await _uploadPhotoService.analyzeSkin(widget.dogId);
      setState(() {
        showResult = true;
        skinResult = result;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('피부 질환 분석 실패: $e')),
        );
      }
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
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
                                      '검출된 피부 질환',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (skinResult!['skinDiseases'].isEmpty)
                                      const Text(
                                        '검출된 피부 질환이 없습니다.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    else
                                      ...List<String>.from(
                                              skinResult!['skinDiseases'])
                                          .map((disease) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4),
                                                child: Text(
                                                  '• $disease',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
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
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: BasicButton(
                                    label: '카메라로 촬영',
                                    onPressed: _navigateToCamera,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: BasicButton(
                                    label: '갤러리에서 선택',
                                    onPressed: _pickImageFromGallery,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      else ...[
                        if (!showResult) ...[
                          if (_uploadedUrl == null)
                            Column(
                              children: [
                                BasicButton(
                                  label: _isLoading ? '업로드 중...' : '이미지 업로드',
                                  onPressed:
                                      _isLoading ? () {} : () => _uploadImage(),
                                ),
                              ],
                            )
                          else ...[
                            Column(
                              children: [
                                BasicButton(
                                  label: _isAnalyzing ? '분석 중...' : '결과보기',
                                  onPressed: _isAnalyzing
                                      ? () {}
                                      : () => _analyzeSkin(),
                                ),
                              ],
                            ),
                          ],
                        ],
                        if (showResult) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: BasicButton(
                              label: '다음단계',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterDogAgeScreen(
                                      dogId: widget.dogId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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
          TabItem(
              icon: '🏠',
              label: '대시보드',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              }),
          TabItem(icon: '🐶', label: '등록', onTap: () {}),
          TabItem(icon: '📊', label: '건강', onTap: () {}),
          TabItem(icon: '🏡', label: '입양', onTap: () {}),
          TabItem(icon: '🛠️', label: '설정', onTap: () {}),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _photo = null;
    super.dispose();
  }
}
