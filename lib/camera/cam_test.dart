import 'package:camera/camera.dart';
import 'package:ffi/ffi.dart';
import 'package:isometry/native/tracer_binding.dart';
import 'package:isometry/native/tracer_model.dart';
import 'package:isometry/camera/camera_service.dart';


import 'package:flutter/material.dart';

class CamTest extends StatefulWidget 
{
  const CamTest({super.key});

  @override
  State<CamTest> createState() => _CamTestState();
}

class _CamTestState extends State<CamTest> 
{
  late final TracerBinding _tracer;
  late final CameraService _cameraService;
  bool _isCameraReady = false;

  @override
  void initState()
  {
    super.initState();
    _tracer = TracerBinding();
    _cameraService = CameraService(_tracer);

    _setupCamera();
  }

  Future<void> _setupCamera() async
  {
    final modelPath = await getModelPath(TracerModel.yolo8nPose320);
    final pathNative = modelPath.toNativeUtf8();

    bool ok = _tracer.tracerInit(pathNative);

    malloc.free(pathNative);
    debugPrint("[!] Intialize Tracer Status: $ok");

    await _cameraService.initialize();
    
    if (mounted) {
      setState(() 
      {
        _isCameraReady = true;
      });
      debugPrint("[!] Camera Initialized Successfully");

      await _cameraService.startStreaming(_cameraService.handleFrame);
      debugPrint("[!] Live stream sent to C++");
    }
  }

  @override
  void dispose()
  {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: SafeArea
      (
        child: Column
        (

          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: 
          [
            Center
            (
              child: InkWell
              (
                onTap: () 
                {
                  Navigator.of(context).pop(context);
                }, 
                child: Text('Back Button')
              ),
            ),

            Expanded
            (
              child: ColoredBox
              (
                color: Colors.amber,
                child: SizedBox
                (
                  //CAM HERE
                  child: _isCameraReady && _cameraService.controller != null
                    ? CameraPreview(_cameraService.controller!)
                    : const Center(
                      child: CircularProgressIndicator(),
                    ), 
                ),
              )
            ),
          ],
        )
      ),
    );
  }
}