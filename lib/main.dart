import 'package:flutter/material.dart';
import 'package:personal_image_gallery_app/constants/app_colors.dart';
import 'package:personal_image_gallery_app/providers/auth_providers.dart';
import 'package:personal_image_gallery_app/providers/gallery_providers.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/gallery/gallery_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'Personal Image Gallery',
      theme: ThemeData(
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: AppColors.white,
        textTheme: TextTheme(bodyLarge: TextStyle(color: AppColors.darkGrey)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.white,
          ),
        ),
      ),
      home: FutureBuilder(
        future: context.read<AuthProvider>().autoLogin(),
        builder: (context, snapshot) {
          final auth = context.watch<AuthProvider>();

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return auth.isLoggedIn ? const GalleryScreen() : const LoginScreen();
        },
      ),
    );
  }
}
