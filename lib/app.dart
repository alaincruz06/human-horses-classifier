import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humans_or_horses/presentation/pages/horse_humman_classifier_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Clasificador de Humanos y Caballos',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HorseHumanClassifier(),
    );
  }
}
