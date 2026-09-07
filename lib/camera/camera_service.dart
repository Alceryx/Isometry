import 'dart:ffi';

import 'package:isometry/native/keypoint.dart';
import 'package:isometry/native/tracer_binding.dart';

import 'package:camera/camera.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

class CameraService 
{
  CameraController? controller;
  bool isStreaming = false;
  bool isProcessing = false;

  final TracerBinding tracer;
  CameraService(this.tracer);

  Future<void> initialize() async
  {
    try
    {
      final cameras = await availableCameras();
      controller = CameraController(cameras.first, ResolutionPreset.max);
      await controller!.initialize();
    }
    catch (e)
    {
      debugPrint('[!] Encounter an Error: $e');
    }
  }

  Future<void> startStreaming(void Function(CameraImage image) onFrame) async
  {
    if (controller == null) 
    {
      debugPrint('Controller does not exxist, cannot start stream');
      return;
    }
    await controller!.startImageStream(onFrame);
    isStreaming = true;
  }

  Future<void> stopStreaming() async
  {
    await controller?.stopImageStream();
    isStreaming = false;
  }

  Future<void> dispose() async
  {
    await controller?.dispose();
  }

  void handleFrame(CameraImage image)
  {
    if (isProcessing) return;
    isProcessing = true;

    int frameSize = 0;
    for (var plane in image.planes)
    {
      frameSize += plane.bytes.length;
    }

    Pointer<Uint8>? nativePixels;
    Pointer<Float>? nativeKeypoints;

    try
    {
      nativePixels = malloc.allocate<Uint8>(frameSize);
      nativeKeypoints = malloc.allocate<Float>(17 * sizeOf<Float>() * 3);

      final nativeBytesList = nativePixels.asTypedList(frameSize);
      int offset = 0;
      for (var plane in image.planes) {
        nativeBytesList.setAll(offset, plane.bytes);
        offset += plane.bytes.length;
      }

      TracerPixelFormat format;
      switch (image.format.group)
      {
        case ImageFormatGroup.yuv420: format = TracerPixelFormat.i420; break;
        case ImageFormatGroup.bgra8888: format = TracerPixelFormat.bgra; break;
        case ImageFormatGroup.nv21: format = TracerPixelFormat.nv21; break;
        default: return;
      }

      debugPrint("PIXEL FORMAT: ${format.value}");

      final sw = Stopwatch()..start();
      bool success = tracer.tracerProcessFrame(
        nativePixels,
        image.width,
        image.height,
        format.value,
        nativeKeypoints
      );
      debugPrint('Frame time: ${sw.elapsedMilliseconds}ms');

      if (success)
      {
        debugPrint("FUCK YEAH");
      }
    }
    catch (e)
    {
      debugPrint("Error processing frame: $e");
    } finally {
      if (nativePixels != null) malloc.free(nativePixels);
      if (nativeKeypoints != null) malloc.free(nativeKeypoints);

      isProcessing = false;
    }
  }
}