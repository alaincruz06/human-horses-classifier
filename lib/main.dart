import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humans_or_horses/app.dart';
import 'package:humans_or_horses/presentation/controllers/horse_humman_classifier_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put<HorseHumanClassifierController>(
    HorseHumanClassifierController(),
    permanent: true,
  );

  runApp(
    const MyApp(),
  );
}
