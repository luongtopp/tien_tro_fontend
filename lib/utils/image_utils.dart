import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app_color.dart';
import '../config/text_styles.dart';
import '../widgets/buttons/button_modal_bottom_sheet.dart';
import 'modal_bottom_sheet_utils.dart';

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
  final selectedOption = await showCustomModalBottomSheet(
    context: context,
    buttons: _buildImagePickerButtons(context),
  );

  if (selectedOption == null) return;

  final ImageSource source =
      selectedOption == 1 ? ImageSource.camera : ImageSource.gallery;
  final XFile? pickedFile = await ImagePicker().pickImage(source: source);

  if (pickedFile != null) {
    await cropImage(
      imageFile: File(pickedFile.path),
      onImageCropped: onImagePicked,
    );
  }
}

List<Widget> _buildImagePickerButtons(BuildContext context) {
  return [
    _buildButton(
      context: context,
      text: 'Máy ảnh',
      icon: Icons.camera_alt_rounded,
      option: 1,
    ),
    const SizedBox(height: 15),
    _buildButton(
      context: context,
      text: 'Thư viện',
      icon: Icons.photo_library_rounded,
      option: 2,
    ),
  ];
}

Widget _buildButton({
  required BuildContext context,
  required String text,
  required IconData icon,
  required int option,
}) {
  return ButtonModalBottomSheet(
    text: text,
    width: double.infinity,
    height: 260.h * 0.3,
    icon: icon,
    color: AppColors.primaryColor,
    textStyle: AppTextStyles.filledButton,
    borderRadius: 20.r,
    onTap: () => Navigator.pop(context, option),
  );
}
