import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter GetX App',
      theme: AppTheme.light,
      getPages: AppPages.pages,
      home: const _DefaultHome(),
    );
  }
}

class _DefaultHome extends StatelessWidget {
  const _DefaultHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello GetX')),
      body: const Center(child: Text('Starter')),
    );
  }
}
