import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/my_app.dart';
import 'package:todos_riverpod/src/core/storage/hive_initializer.dart';

void main() async {
  await bootstrap();
}

Future<void> bootstrap() async {
  /// Initialize packages
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();
  await HiveInitializer.init();

  runApp(const ProviderScope(child: MyApp()));
}
