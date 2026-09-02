import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

enum TracerModel {
  yolo8nPose('yolov8n-pose.onnx'),
  yolo8nPose320('yolov8n-pose-320.onnx'),
  yolo11nPose('yolo11n-pose.onnx');

  final String name;
  const TracerModel(this.name);

  static const String _asset = 'assets/models';
  String get assetPath => '$_asset/$name';
}

Future<String> getModelPath(TracerModel model) async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/${model.name}');

  if (!await file.exists()) {
    final byteData = await rootBundle.load(model.assetPath);
    await file.writeAsBytes(byteData.buffer.asUint8List());
  }

  return file.path;
}
