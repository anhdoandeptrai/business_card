import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EZNECT - Digital Business Card',
      initialRoute: AppRoutes.welcome,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
