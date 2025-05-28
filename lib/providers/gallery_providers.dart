import 'package:flutter/material.dart';

class GalleryProvider with ChangeNotifier {
  final List<String> _images = [];
  static const int maxImages = 6;

  List<String> get images => _images;

  void addImage(String imagePath) {
    if (_images.length < maxImages) {
      _images.insert(0, imagePath);
      notifyListeners();
    }
  }

  void removeImage(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  void reorderImages(int oldIndex, int newIndex) {
    final image = _images.removeAt(oldIndex);
    _images.insert(newIndex, image);
    notifyListeners();
  }
}