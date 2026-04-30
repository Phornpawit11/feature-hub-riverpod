import 'package:flutter/widgets.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/widgets/calendar_background_image_provider_stub.dart'
    if (dart.library.io)
    'package:todos_riverpod/src/feature/todos/presentation/widgets/calendar_background_image_provider_io.dart'
    as provider_factory;

ImageProvider<Object>? buildCalendarBackgroundImageProvider(String imagePath) {
  return provider_factory.buildCalendarBackgroundImageProvider(imagePath);
}
