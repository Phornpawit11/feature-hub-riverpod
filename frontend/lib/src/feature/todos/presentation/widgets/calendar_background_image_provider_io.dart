import 'dart:io';

import 'package:flutter/widgets.dart';

ImageProvider<Object>? buildCalendarBackgroundImageProvider(String imagePath) {
  if (imagePath.trim().isEmpty) {
    return null;
  }

  return FileImage(File(imagePath));
}
