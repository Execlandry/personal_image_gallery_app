import 'package:flutter/material.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_image_gallery_app/constants/app_colors.dart';
import 'package:personal_image_gallery_app/providers/auth_providers.dart';
import 'package:personal_image_gallery_app/providers/gallery_providers.dart';
import 'package:personal_image_gallery_app/screens/auth/login_screen.dart';
import 'package:personal_image_gallery_app/screens/gallery/image_upload_screen.dart';
import 'package:personal_image_gallery_app/screens/widgets/appbar.dart';
import 'package:personal_image_gallery_app/models/categories.dart';
import 'package:personal_image_gallery_app/screens/widgets/image_grid_item.dart';
import 'package:provider/provider.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<Categories> categories = [];
  final double _imageBorderRadius = 16.0;
  final int _maxItems = 6;

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  void _getCategories() {
    categories = Categories.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final backgroundColor =
        user?.gender == 'Female'
            ? AppColors.femaleBackground
            : AppColors.maleBackground;
    final gallery = context.watch<GalleryProvider>();

    List<Object> gridItems = [
      ...gallery.images,
      ...List.generate(
        _maxItems - gallery.images.length,
        (index) => 'add_button_$index',
      ),
    ];

    final nonDraggableItems =
        gridItems
            .where((item) => item is String && item.startsWith('add_button'))
            .toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: MyAppBar(
        title: "Image Gallery",
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.black),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: _searchField(),
          ),
          const SizedBox(height: 24),

          _buildCategoryList(),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 16),
            child: Text(
              "Your Gallery",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontSize: 18,
              ),
            ),
          ),

          Expanded(
            child: AnimatedReorderableGridView<Object>(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              items: gridItems,
              itemBuilder: (BuildContext context, int index) {
                final item = gridItems[index];

                if (item is String && item.startsWith('add_button')) {
                  return _buildAddButtonItem(item);
                }

                return ImageGridItem(
                  key: ValueKey(item),
                  image: item as String,
                  index: index,
                  isFirst: index == 0,
                  gender: user?.gender,
                  borderRadius: _imageBorderRadius,
                  dragEnabled: !nonDraggableItems.contains(item),
                );
              },
              sliverGridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
              enterTransition: [FlipInX(), ScaleIn()],
              exitTransition: [SlideInLeft()],
              insertDuration: const Duration(milliseconds: 300),
              removeDuration: const Duration(milliseconds: 300),
              nonDraggableItems: nonDraggableItems,
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < gallery.images.length &&
                    newIndex < gallery.images.length) {
                  context.read<GalleryProvider>().reorderImages(
                    oldIndex,
                    newIndex,
                  );
                }
              },
              isSameItem: (a, b) => a == b,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Travel Log',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 120,
          child: ListView.separated(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: categories[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(categories[index].iconPath),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      categories[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddButtonItem(String item) {
    return InkWell(
      key: ValueKey(item),
      borderRadius: BorderRadius.circular(_imageBorderRadius),
      onTap: () => _navigateToUploadScreen(context),
      child: AspectRatio(
        aspectRatio: 0.85,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(_imageBorderRadius),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.4),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.add_a_photo,
                  size: 24,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Add Photo',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          hintText: 'Search Cities or Countries',
          hintStyle: const TextStyle(color: AppColors.darkGrey, fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: SvgPicture.asset('assets/icons/Search.svg'),
          ),
          suffixIcon: Container(
            width: 60,
            padding: const EdgeInsets.only(right: 12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // VerticalDivider(
                //   color: AppColors.black,
                //   indent: 10,
                //   endIndent: 10,
                //   thickness: 1,
                // ),
                SizedBox(width: 8),
                Icon(Icons.tune, color: AppColors.black),
              ],
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }


  void _navigateToUploadScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ImageUploadScreen()),
    );
  }
}
