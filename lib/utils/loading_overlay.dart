import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => const Positioned(
        child: Material(
          color: Color.fromARGB(115, 68, 68, 68),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
