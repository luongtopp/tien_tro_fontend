import 'dart:io';
import 'package:flutter/material.dart';

class CustomImagePicker extends StatelessWidget {
  final VoidCallback onImagePicked;
  final File? image;
  final double size;
  final BoxShape shape;
  final Border? border;
  final String defaultAvatar;

  const CustomImagePicker({
    required this.onImagePicked,
    this.image,
    this.size = 100.0,
    this.shape = BoxShape.circle,
    this.border,
    this.defaultAvatar = 'assets/images/default_avatar.png',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Border effectiveBorder =
        border ?? Border.all(color: const Color(0xFF9E9E9E), width: 1.5);

    return GestureDetector(
      onTap: onImagePicked,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: shape,
          border: effectiveBorder,
          image: image != null
              ? DecorationImage(
                  image: FileImage(image!),
                  fit: BoxFit.cover,
                )
              : DecorationImage(
                  image: AssetImage(defaultAvatar),
                  fit: BoxFit.cover,
                ),
        ),
        child: image == null
            ? Center(
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.grey[600],
                  size: size * 0.4,
                ),
              )
            : Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF9E9E9E), width: 1),
                      ),
                      child: Icon(
                        Icons.edit_rounded,
                        color: Colors.grey[600],
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
