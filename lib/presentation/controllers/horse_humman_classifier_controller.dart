import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:image/image.dart' as img;
import 'package:humans_or_horses/presentation/constants/assets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HorseHumanClassifierController extends GetxController {
  HorseHumanClassifierController();

  File? image;
  String prediction = '';
  RxDouble confidence = 0.0.obs;
  RxBool isLoading = false.obs;
  Interpreter? _interpreter;

  @override
  Future<void> onInit() async {
    super.onInit();
    _loadModel();
  }

  @override
  void onClose() {
    _interpreter?.close();
    super.onClose();
  }

  Future<void> _loadModel() async {
    try {
      isLoading.value = true;
      final interpreterOptions = InterpreterOptions();

      _interpreter = await Interpreter.fromAsset(
        Assets.assetsHorseHumanModel,
        options: interpreterOptions..threads = 4,
      );
      debugPrint('Model loaded successfully');
    } catch (e) {
      debugPrint('Error loading model: $e');
      // Show error dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog(
          null,
          'Fallo al cargar el modelo: $e',
        );
      });
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorDialog(
    BuildContext? context,
    String message,
  ) {
    showDialog(
      context: context ?? Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? xFileImage = await picker.pickImage(source: source);

      if (xFileImage != null) {
        image = File(xFileImage.path);
        isLoading.value = true;
        prediction = '';
        confidence.value = 0.0;
        await _classifyImage();
      }
    } catch (e) {
      _showErrorDialog(
        context,
        'Fallo al seleccionar imagen: $e',
      );

      isLoading.value = false;
    }
  }

  Future<void> _classifyImage() async {
    if (_interpreter == null || image == null) {
      isLoading.value = false;
      return;
    }

    try {
      // Read and decode image
      Uint8List imageBytes = await image!.readAsBytes();
      img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        throw Exception('No se pudo decodificar la imagen');
      }

      // Resize image to 300x300 (matching training size)
      img.Image resizedImage = img.copyResize(
        decodedImage,
        width: 300,
        height: 300,
      );

      // Convert to float32 and normalize to [0,1]
      var input = Float32List(1 * 300 * 300 * 3);
      int pixelIndex = 0;

      for (int y = 0; y < 300; y++) {
        for (int x = 0; x < 300; x++) {
          // Get pixel as Pixel object (newer image package API)
          img.Pixel pixel = resizedImage.getPixel(x, y);

          // Extract RGB values using the Pixel object properties
          input[pixelIndex++] = pixel.r / 255.0;
          input[pixelIndex++] = pixel.g / 255.0;
          input[pixelIndex++] = pixel.b / 255.0;
        }
      }

      // Reshape for model input [1, 300, 300, 3]
      var inputTensor = input.reshape([1, 300, 300, 3]);

      // Prepare output tensor [1, 1] - single output neuron
      var outputTensor = Float32List(1).reshape([1, 1]);

      // Run inference
      _interpreter!.run(inputTensor, outputTensor);

      // Get prediction - output is sigmoid (0 = horse, 1 = human)
      double output = outputTensor[0][0];

      String predictedClass;
      double tempConfidence;

      if (output > 0.5) {
        predictedClass = 'Humano';
        tempConfidence = output;
      } else {
        predictedClass = 'Caballo';
        tempConfidence = 1.0 - output;
      }

      prediction = predictedClass;
      confidence.value = tempConfidence;
      isLoading.value = false;
    } catch (e) {
      debugPrint('Error classifying image: $e');

      isLoading.value = false;
      prediction = 'Ha ocurrido un error';
      confidence.value = 0.0;
      _showErrorDialog(null, 'Fallo al clasificar la imagen: $e');
    }
  }

  Color getPredictionColor() {
    if (prediction == 'Humano') {
      return Colors.blue;
    } else if (prediction == 'Caballo') {
      return Colors.brown;
    }
    return Colors.grey;
  }

  IconData getPredictionIcon() {
    if (prediction == 'Humano') {
      return HugeIcons.strokeRoundedUser02;
    } else if (prediction == 'Caballo') {
      return HugeIcons.strokeRoundedHorseHead;
    }
    return HugeIcons.strokeRoundedInformationCircle;
  }
}
