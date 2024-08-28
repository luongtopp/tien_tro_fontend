import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app_color.dart';
import '../config/text_styles.dart';
import '../widgets/buttons/button_modal_bottom_sheet.dart';

Future<void> cropImage({
  required File imageFile,
  required Function(File) onImageCropped,
}) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Chỉnh sửa',
        toolbarColor: AppColors.primaryColor,
        statusBarColor: AppColors.primaryColor,
        activeControlsWidgetColor: AppColors.primaryColor,
        toolbarWidgetColor: const Color(0xFFFFFFFF),
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
        title: 'Cropper',
        aspectRatioLockEnabled: false,
      ),
    ],
  );

  if (croppedFile != null) {
    onImageCropped(File(croppedFile.path));
  }
}

Future<void> pickImage({
  required BuildContext context,
  required Function(File) onImagePicked,
}) async {
  final selectedOption = await showModalBottomSheet<int>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 200,
          color: AppColors.backgroundColor,
          child: Column(
            children: [
              ButtonModalBottomSheet(
                text: 'Máy ảnh',
                width: double.infinity,
                height: 70,
                icon: Icons.camera_alt_rounded,
                color: AppColors.primaryColor,
                textStyle: TextStyles.filledButton,
                borderRadius: 20,
                onTap: () {
                  Navigator.pop(context, 1);
                },
              ),
              const SizedBox(height: 15),
              ButtonModalBottomSheet(
                text: 'Thư viện',
                width: double.infinity,
                height: 70,
                icon: Icons.photo_library_rounded,
                color: AppColors.primaryColor,
                textStyle: TextStyles.filledButton,
                borderRadius: 20,
                onTap: () {
                  Navigator.pop(context, 2);
                },
              )
            ],
          ),
        ),
      );
    },
  );

  if (selectedOption == null) return;

  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;

  if (selectedOption == 1) {
    pickedFile = await picker.pickImage(source: ImageSource.camera);
  } else if (selectedOption == 2) {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
  }

  if (pickedFile != null) {
    cropImage(
      imageFile: File(pickedFile.path),
      onImageCropped: onImagePicked,
    );
  }
}
