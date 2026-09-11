import 'package:ffi/ffi.dart';
import 'package:isometry/temp_design.dart';
import 'package:file_picker/file_picker.dart';

import 'package:isometry/native/tracer_binding.dart';
import 'package:isometry/native/tracer_model.dart';

import 'package:isometry/page_program/tab_exercise_grp.dart';
import 'package:isometry/data_manager.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async 
{
  TracerBinding tracer = TracerBinding();
  final path = await getModelPath(TracerModel.yolo11nPose);
  bool init = tracer.tracerInit(path.toNativeUtf8());
  debugPrint("Initialization Status: $init");

  WidgetsFlutterBinding.ensureInitialized();

  PlatformFile? result = await FilePicker.pickFile(type: FileType.video);
  if (result != null)
  {
    final video = result.path!;
    bool ok = tracer.tracerVideoCheck(video.toNativeUtf8());
    debugPrint("Video Input Path: $video | Video Load Status: $ok");
  }

  runApp
  (
    ChangeNotifierProvider
    (
      create: (context) => GridData(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      debugShowCheckedModeBanner: false,
      title: 'Isometry',
      theme: ThemeData
      (
        //------------------
        //---Colour Theme---
        //------------------

        colorScheme: const ColorScheme
        (
          brightness: Brightness.dark,

          //Red
          primary: Color(0xFFE53C3C),
          onPrimary: Color(0xFF1D1D1D),
          
          //White
          secondary: Color(0xFFD9D5CA),
          onSecondary: Color(0xFF1D1D1D),

          //BG
          surface: Color(0xFF27282D),
          onSurface: Color(0xFF595B65),

          //Error
          error: Color(0xFFE53C3C),
          onError: Color(0xFF1D1D1D),
        ),

        //------------------
        //----Text Theme----
        //------------------

        textTheme: const TextTheme
        (
          displayLarge: TextStyle
          (
            fontFamily: 'ChakraPetch',
            fontSize: 57,
            fontWeight: FontWeight.w900,
          ),

          displayMedium: TextStyle
          (
            fontFamily: 'ChakraPetch',
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),

          displaySmall: TextStyle
          (
            fontFamily: 'ChakraPetch',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),

          titleLarge: TextStyle
          (
            fontFamily: 'ChakraPetch',
            fontSize: 40,
            fontWeight: FontWeight.w600,
          ),

          titleMedium: TextStyle
          (
            fontFamily: 'ChakraPetch',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),

          titleSmall: TextStyle
          (
            fontFamily: 'ChakraPetch',
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),

          bodyLarge: TextStyle
          (
            fontFamily: 'MonaspaceKrypton',
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ), 
          
          bodyMedium: TextStyle
          (
            fontFamily: 'MonaspaceKrypton',
            fontSize: 18,
            fontWeight: FontWeight.w500
          ),

          bodySmall: TextStyle
          (
            fontFamily: 'MonaspaceKrypton',
            fontSize: 16,
            fontWeight: FontWeight.w300
          ),
        ),

      ),
      home: TabExerciseList()
    );
  }
}