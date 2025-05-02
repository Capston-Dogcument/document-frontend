import 'package:document/screens/crop_skin_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';

class TakeSkinPhotoScreen extends StatefulWidget {
  const TakeSkinPhotoScreen({super.key});

  @override
  State<TakeSkinPhotoScreen> createState() => _TakeSkinPhotoScreenState();
}

class _TakeSkinPhotoScreenState extends State<TakeSkinPhotoScreen> {
  CameraController? _controller;
  XFile? photo;

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
        this.photo = photo;
      });
    } catch (e) {
      print('사진 촬영 오류: $e');
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단 앱바
            AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('강아지 피부 사진 찍기'),
            ),

            // 안내 텍스트 수정
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '피부 질환이 있는 부위를 찍어주세요',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '예시 사진을 참고해주세요.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // 카메라 프리뷰 (빨간색 선 제거)
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  photo != null
                      ? Image.file(File(photo!.path))
                      : CameraPreview(_controller!),
                ],
              ),
            ),

            // 하단 컨트롤
            Container(
              height: 155,
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 127),
                  // 촬영/재촬영 버튼
                  GestureDetector(
                    onTap: _takePhoto,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        photo != null ? Icons.replay : Icons.camera_alt,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // 완료 버튼
                  SizedBox(
                    width: 118,
                    child: TextButton(
                      onPressed: photo != null
                          ? () async {
                              // 크롭 화면으로 이동
                              final croppedPath = await Navigator.push<String>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CropSkinPhotoScreen(
                                    imagePath: photo!.path,
                                  ),
                                ),
                              );

                              if (croppedPath != null) {
                                Navigator.pop(context, XFile(croppedPath));
                              }
                            }
                          : null,
                      style: TextButton.styleFrom(
                        backgroundColor:
                            photo != null ? Colors.black : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '완료',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
