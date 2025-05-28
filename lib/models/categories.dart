import 'package:flutter/material.dart';
import 'package:personal_image_gallery_app/constants/app_colors.dart';

class Categories {
  String name;
  String iconPath;
  Color boxColor;

  Categories({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<Categories> getCategories() {
    List<Categories> categories = [];

    categories.add(
      Categories(
        iconPath: 'assets/icons/india.svg',
        name: "Goa",
        boxColor: AppColors.boxColor1,
      ),
    );
    categories.add(
      Categories(
        iconPath: 'assets/icons/greece.svg',
        name: "Santorini",
        boxColor: AppColors.boxColor2,
      ),
    );
    categories.add(
      Categories(
        iconPath: 'assets/icons/germany.svg',
        name: "Berlin",
        boxColor: AppColors.boxColor1,
      ),
    );
    categories.add(
      Categories(
        iconPath: "assets/icons/india.svg",
        name: "Taj Mahal",
        boxColor: AppColors.boxColor2,
      ),
    );

    return categories;
  }
}
