import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:humans_or_horses/presentation/controllers/horse_humman_classifier_controller.dart';
import 'package:image_picker/image_picker.dart';

class HorseHumanClassifier extends GetView<HorseHumanClassifierController> {
  const HorseHumanClassifier({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificador de Humanos y Caballos'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value && controller.image == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedHorseHead,
                                  size: 32,
                                  color: Colors.brown,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'VS',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedUser02,
                                  size: 32,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Clasificador de Imágenes (con IA)',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Toma o sube una foto para clasificar si pertenece a un humano o a un caballo. (Es casi como magia!)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Image Display
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: controller.image != null
                            ? Image.file(
                                controller.image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.grey[50],
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons
                                            .strokeRoundedImageNotFound01,
                                        color:
                                            Theme.of(context).iconTheme.color!,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No hay imagen seleccionada',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Presiona alguna opción abajo para cargar una imagen',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.pickImage(
                                      context,
                                      ImageSource.camera,
                                    ),
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedCamera01,
                              color: Theme.of(context).iconTheme.color!,
                            ),
                            label: Text(
                              'Cámara',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.pickImage(
                                      context,
                                      ImageSource.gallery,
                                    ),
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedAlbum02,
                              color: Theme.of(context).iconTheme.color!,
                            ),
                            label: Text(
                              'Galería',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Loading Indicator
                    if (controller.isLoading.value)
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              const CircularProgressIndicator(strokeWidth: 3),
                              const SizedBox(height: 20),
                              const Text(
                                'Analizando imagen...',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Por favor espera mientras procesamos la imagen.',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Results Card
                    if (controller.prediction.isNotEmpty &&
                        !controller.isLoading.value)
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                controller
                                    .getPredictionColor()
                                    .withOpacity(0.1),
                                controller
                                    .getPredictionColor()
                                    .withOpacity(0.05),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: controller
                                            .getPredictionColor()
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Icon(
                                        controller.getPredictionIcon(),
                                        color: controller.getPredictionColor(),
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Predicción',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          controller.prediction,
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                controller.getPredictionColor(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Confianza: ${(controller.confidence.value * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey[200],
                                  ),
                                  child: Obx(
                                    () => FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: controller.confidence.value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          gradient: LinearGradient(
                                            colors: [
                                              controller
                                                  .getPredictionColor()
                                                  .withOpacity(0.7),
                                              controller.getPredictionColor(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Obx(
                                  () => Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: controller.confidence.value > 0.8
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: controller.confidence.value > 0.8
                                            ? Colors.green.withOpacity(0.3)
                                            : Colors.orange.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        HugeIcon(
                                          icon: controller
                                                      .confidence.value >
                                                  0.8
                                              ? HugeIcons
                                                  .strokeRoundedIdVerified
                                              : HugeIcons
                                                  .strokeRoundedInformationCircle,
                                          color:
                                              controller.confidence.value > 0.8
                                                  ? Colors.green
                                                  : Colors.orange,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            controller.confidence.value > 0.8
                                                ? 'Alto nivel de confianza'
                                                : 'Confianza moderada',
                                            style: TextStyle(
                                              color:
                                                  controller.confidence.value >
                                                          0.8
                                                      ? Colors.green[700]
                                                      : Colors.orange[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
