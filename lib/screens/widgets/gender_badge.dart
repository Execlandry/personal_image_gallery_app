import 'package:flutter/material.dart';
import 'package:personal_image_gallery_app/constants/app_colors.dart';

class GenderBadge extends StatelessWidget {
  final String gender;
  final double size;
  final bool showBackground;

  const GenderBadge({
    super.key,
    required this.gender,
    this.size = 40.0,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final isFemale = gender.toLowerCase() == 'female';
    final emoji = isFemale ? '👧' : '👦';

    return Container(
      width: size,
      height: size,
      decoration:
          showBackground
              ? BoxDecoration(
                color:
                    isFemale
                        ? AppColors.femaleBackground
                        : AppColors.maleBackground,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              )
              : null,
      child: Center(
        child: Text(emoji, style: TextStyle(fontSize: size * 0.7, height: 1.2)),
      ),
    );
  }
}
