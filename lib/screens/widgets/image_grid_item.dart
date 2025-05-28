import 'dart:io';

import 'package:flutter/material.dart';
import 'package:personal_image_gallery_app/constants/app_colors.dart';
import 'package:personal_image_gallery_app/providers/gallery_providers.dart';
import 'package:personal_image_gallery_app/screens/widgets/gender_badge.dart';
import 'package:provider/provider.dart';

class ImageGridItem extends StatelessWidget {
  final String image;
  final int index;
  final bool isFirst;
  final String? gender;
  final bool dragEnabled;
  final double borderRadius;

  const ImageGridItem({
    super.key,
    required this.image,
    required this.index,
    required this.isFirst,
    this.gender,
    required this.dragEnabled,
    this.borderRadius = 16.0,
  });

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 4,
        title: Column(
          children: [
            Icon(
              Icons.warning_rounded,
              size: 48,
              color: AppColors.errorRed,
            ),
            const SizedBox(height: 8),
            const Text(
              'Delete Image',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const Text(
          'This action cannot be undone. Are you sure you want to permanently delete this image?',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.black,
          ),
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: AppColors.darkGrey),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorRed,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<GalleryProvider>().removeImage(index);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeleteDialog(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(image),
              fit: BoxFit.cover,
            ),
            if (isFirst && gender != null)
              Positioned(
                top: 8,
                right: 8,
                child: GenderBadge(gender: gender!),
              ),
            
            // if (dragEnabled)
            //   Positioned(
            //     bottom: 8,
            //     right: 8,
            //     child: ReorderableDragStartListener(
            //       index: index,
            //       child: const Icon(Icons.drag_handle, color: AppColors.white),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}