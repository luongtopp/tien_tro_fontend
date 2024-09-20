import 'package:flutter/material.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_styles.dart';
import '../../../../generated/l10n.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onAddPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        title,
        style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),
      actions: [
        _buildAddButton(s),
      ],
      toolbarHeight: 60,
      elevation: 0,
      flexibleSpace: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildAddButton(S s) {
    if (onAddPressed == null) return Card();
    return Card(
      elevation: 0,
      color: Colors.green,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(right: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: InkWell(
        onTap: onAddPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            s.add,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
