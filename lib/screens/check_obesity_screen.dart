import 'package:flutter/material.dart';
import 'package:document/widgets/basic_button.dart';
import 'package:document/widgets/bottom_tapbar.dart';
import 'package:document/widgets/progressbar.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:document/screens/take_photos_screen.dart';
import 'package:document/screens/check_skin_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:document/services/upload_photo_service.dart';

class CheckObesityScreen extends StatefulWidget {
  final int dogId;

  const CheckObesityScreen({
    super.key,
    required this.dogId,
  });

  @override
  State<CheckObesityScreen> createState() => _CheckObesityScreenState();
}

class _CheckObesityScreenState extends State<CheckObesityScreen> {
  final ImagePicker _picker = ImagePicker();
  final UploadPhotoService _uploadService = UploadPhotoService();
  bool _isLoading = false;
  List<XFile>? _photos;
  int currentPhotoIndex = 0;
  bool showResult = false;
  bool _isAnalyzing = false;
  List<String>? _uploadedUrls;
  Map<String, dynamic>? obesityResult;

  Future<void> _navigateToCamera() async {
    final result = await Navigator.push<List<XFile>>(
      context,
      MaterialPageRoute(builder: (context) => const TakePhotosScreen()),
    );

    if (result != null && result.length == 5) {
      setState(() {
        _photos = result;
        showResult = false;
        obesityResult = null;
      });
    }
  }

  Future<void> _pickImagesFromGallery() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.length == 5) {
      setState(() {
        _photos = images;
        showResult = false;
        obesityResult = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('정확히 5장의 사진을 선택해주세요.')),
      );
    }
  }

  Future<void> _uploadImages() async {
    if (_photos == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final List<File> imageFiles =
          _photos!.map((xFile) => File(xFile.path)).toList();

      final urls = await _uploadService.uploadObesityImages(
        images: imageFiles,
        dogId: widget.dogId,
      );

      setState(() {
        _uploadedUrls = urls;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지 업로드가 완료되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 업로드 실패: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _analyzeObesity() async {
    if (_uploadedUrls == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 이미지를 업로드해주세요.')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // TODO: 실제 비만도 검사 API 호출
      await Future.delayed(const Duration(seconds: 2)); // 임시 딜레이

      setState(() {
        showResult = true;
        obesityResult = {
          "weight": "25", // TODO: 실제 API 응답으로 대체
          "status": "정상", // TODO: 실제 API 응답으로 대체
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비만도 검사 실패: $e')),
      );
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
        title: const Text("비만도 측정"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const ProgressBar(
                steps: [true, false, false, false, false],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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

                      // 이미지 프리뷰 (페이지뷰로 구현)
                      if (_photos != null && _photos!.isNotEmpty)
                        SizedBox(
                          height: 203,
                          child: PageView.builder(
                            itemCount: _photos!.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentPhotoIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_photos![index].path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 203,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          child: const Center(
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

                      if (_photos != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _photos!.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentPhotoIndex == index
                                    ? Colors.black
                                    : Colors.grey[300],
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // 결과 표시
                      if (showResult && obesityResult != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '두유의 비만도',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '체중',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '${obesityResult!["weight"]} kg',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '비만도',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            obesityResult!["status"],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // 버튼들
                      if (_photos == null)
                        Row(
                          children: [
                            Expanded(
                              child: BasicButton(
                                label: '카메라로 촬영',
                                onPressed: () => _navigateToCamera(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: BasicButton(
                                label: '갤러리에서 선택',
                                onPressed: () => _pickImagesFromGallery(),
                              ),
                            ),
                          ],
                        )
                      else ...[
                        if (!showResult) ...[
                          if (_uploadedUrls == null)
                            BasicButton(
                              label: _isLoading ? '업로드 중...' : '이미지 업로드',
                              onPressed:
                                  _isLoading ? () {} : () => _uploadImages(),
                            )
                          else ...[
                            BasicButton(
                              label: _isAnalyzing ? '검사 중...' : '비만도 검사하기',
                              onPressed: _isAnalyzing
                                  ? () {}
                                  : () => _analyzeObesity(),
                            ),
                          ],
                        ],
                        if (showResult)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: BasicButton(
                              label: '다음단계',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckSkinScreen(),
                                  ),
                                );
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
