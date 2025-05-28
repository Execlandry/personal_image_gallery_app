import 'package:flutter/material.dart';
import 'package:personal_image_gallery_app/constants/app_colors.dart';
import 'package:personal_image_gallery_app/providers/auth_providers.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color textColor;
  final TextStyle? textStyle;
  final double elevation;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;

  const MyAppBar({
    super.key,
    required this.title,
    this.textColor = AppColors.black,
    this.textStyle,
    this.elevation = 4,
    this.centerTitle = true,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final backgroundColor =
        user?.gender == 'Female'
            ? AppColors.femaleBackground
            : AppColors.maleBackground;
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor,
      elevation: 0.0,
      centerTitle: true,
      leading: leading,
      actions: actions
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
