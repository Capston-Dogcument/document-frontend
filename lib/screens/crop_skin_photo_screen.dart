import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:document/widgets/basic_button.dart';

class CropSkinPhotoScreen extends StatefulWidget {
  final String imagePath;

  const CropSkinPhotoScreen({super.key, required this.imagePath});

  @override
  State<CropSkinPhotoScreen> createState() => _CropSkinPhotoScreenState();
}

class _CropSkinPhotoScreenState extends State<CropSkinPhotoScreen> {
  CroppedFile? _croppedFile;

  Future<void> _cropImage() async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '피부 질환 부위 선택',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: '피부 질환 부위 선택',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cropImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('피부 질환 사진 수정'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _croppedFile != null
                  ? Image.file(File(_croppedFile!.path))
                  : const Center(child: CircularProgressIndicator()),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BasicButton(
                label: '강아지 피부 사진 수정 완료',
                onPressed: () {
                  if (_croppedFile != null) {
                    Navigator.pop(context, _croppedFile!.path);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
