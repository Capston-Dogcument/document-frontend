import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class TakePhotosScreen extends StatefulWidget {
  const TakePhotosScreen({super.key});

  @override
  State<TakePhotosScreen> createState() => _TakePhotosScreenState();
}

class _TakePhotosScreenState extends State<TakePhotosScreen> {
  CameraController? _controller;
  int currentStep = 0;
  List<String> stepTitles = [
    '정면을 찍어주세요',
    '왼쪽 측면을 찍어주세요',
    '후면을 찍어주세요',
    '오른쪽 측면을 찍어주세요',
    '상면을 찍어주세요'
  ];
  List<XFile?> photos = List.filled(5, null);

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('카메라 초기화 오류: $e');
    }
  }

  Future<void> _takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _controller!.takePicture();
      setState(() {
        photos[currentStep] = photo;
      });

      if (currentStep < 4) {
        setState(() {
          currentStep++;
        });
      }
    } catch (e) {
      print('사진 촬영 오류: $e');
    }
  }

  void _finishPhotos() {
    if (photos.every((photo) => photo != null)) {
      final List<XFile> completedPhotos = photos.whereType<XFile>().toList();
      Navigator.of(context).pop(completedPhotos);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            // 상단 상태바 영역
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '강아지 사진 찍기',
                          style: TextStyle(
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

            // 안내 텍스트
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 16,
                left: 12,
                right: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step${currentStep + 1}. ${stepTitles[currentStep]}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  const Text(
                    '빨간색 선 안에 강아지가 들어오도록 사진을 찍어주세요.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      height: 1.33,
                    ),
                  ),
                ],
              ),
            ),

            // 카메라 프리뷰 영역
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 카메라 프리뷰
                  CameraPreview(_controller!),
                  // 빨간색 가이드 원
                  Container(
                    width: 272,
                    height: 350,
                    decoration: ShapeDecoration(
                      shape: OvalBorder(
                        side: BorderSide(
                          width: 10,
                          color: Colors.red.withOpacity(0.5),
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 하단 컨트롤 영역
            Container(
              width: double.infinity,
              height: 155,
              padding: const EdgeInsets.only(
                top: 16,
                left: 12,
                right: 12,
              ),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 127),
                  // 촬영 버튼
                  GestureDetector(
                    onTap: _takePhoto,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Next 버튼
                  Container(
                    width: 118,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextButton(
                      onPressed: photos[currentStep] != null
                          ? () {
                              if (currentStep < 4) {
                                setState(() {
                                  currentStep++;
                                });
                              } else {
                                _finishPhotos();
                              }
                            }
                          : null,
                      style: TextButton.styleFrom(
                        backgroundColor: photos[currentStep] != null
                            ? Colors.black
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
