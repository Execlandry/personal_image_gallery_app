import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lottie/lottie.dart';
import 'package:personal_image_gallery_app/constants/app_colors.dart';
import 'package:personal_image_gallery_app/providers/auth_providers.dart';
import 'package:personal_image_gallery_app/providers/gallery_providers.dart';
import 'package:personal_image_gallery_app/screens/widgets/appbar.dart';
import 'package:provider/provider.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isLoading = true);
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppColors.maleBackground,
              toolbarWidgetColor: AppColors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(title: 'Crop Image'),
          ],
        );

        if (cropped != null) {
          context.read<GalleryProvider>().addImage(cropped.path);
          Navigator.pop(context);
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final color =
        user?.gender == 'Female'
            ? AppColors.femaleBackground
            : AppColors.maleBackground;

    return Scaffold(
      backgroundColor: color,
      appBar: MyAppBar(title: 'Upload Image'),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Lottie.asset(
                          'assets/animations/car1.json',
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Preserve Your Memories',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                            shadows: [
                              Shadow(
                                color: AppColors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Upload your favorite moments to your personal gallery',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Upload options card
                    Stack(
                      alignment: Alignment.centerRight,

                      children: [
                        Container(
                          
                          decoration: BoxDecoration(
                            color: AppColors.grey,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              // Gallery option
                              _buildUploadOption(
                                icon: Icons.photo_library_rounded,
                                label: 'Choose from Gallery',
                                color: AppColors.secondaryColor,
                                source: ImageSource.gallery,
                              ),

                              const SizedBox(height: 25),

                              // Camera option with decorative animation
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  _buildUploadOption(
                                    icon: Icons.camera_alt_rounded,
                                    label: 'Take a Photo',
                                    color: AppColors.primaryColor,
                                    source: ImageSource.camera,
                                  ),
                                  // Positioned(
                                  //   right: -25,
                                  //   child: Transform.rotate(
                                  //     angle: 0.3,
                                  //     child: Lottie.asset(
                                  //       'assets/animations/cat1.json',
                                  //       height: 100,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          // Positioned(
                                  //   right: -25,
                                  //   child: Transform.rotate(
                                  //     angle: 0.3,
                                  //     child: Lottie.asset(
                                  //       'assets/animations/cat1.json',
                                  //       height: 100,
                                  //     ),
                                  //   ),
                                  // ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: AppColors.black.withOpacity(0.6),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.black,
                      ),
                      strokeWidth: 5,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Processing your image...',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required Color color,
    required ImageSource source,
  }) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(18),
      shadowColor: color.withOpacity(0.4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [color, Color.lerp(color, AppColors.black, 0.1)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _pickImage(source),
          splashColor: AppColors.black.withOpacity(0.2),
          highlightColor: AppColors.black.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: AppColors.black),
                const SizedBox(width: 15),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
