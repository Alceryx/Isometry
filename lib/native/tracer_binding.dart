import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

typedef TracerPingNative = Bool Function();
typedef TracerPingDart = bool Function();

typedef TracerShutDownNative = Void Function();
typedef TracerShutDownDart = void Function();

typedef TracerInitNative = Bool Function(Pointer<Utf8>);
typedef TracerInitDart = bool Function(Pointer<Utf8>);

typedef TracerProcessFrameNative = Bool Function(Pointer<Uint8>, Int, Int, Int, Pointer<Float>);
typedef TracerProcessFrameDart = bool Function(Pointer<Uint8>, int, int, int, Pointer<Float>);

enum TracerPixelFormat {
  nv21(0),
  nv12(1),
  i420(2),
  bgra(3),
  rgba(4),
  bgr(5);

  final int value;
  const TracerPixelFormat(this.value);
}

class TracerBinding 
{
  late final DynamicLibrary _lib;
  
  late TracerPingDart tracerPing;
  late TracerShutDownDart tracerShutdown;
  late TracerInitDart tracerInit;
  late TracerProcessFrameDart tracerProcessFrame;

  TracerBinding()
  {
    _lib = Platform.isAndroid ? DynamicLibrary.open('libtracer.so') : DynamicLibrary.open('tracer.dll');
    tracerPing = _lib.lookupFunction<TracerPingNative, TracerPingDart>('tracer_ping');
    tracerShutdown = _lib.lookupFunction<TracerShutDownNative, TracerShutDownDart>('tracer_shutdown');
    tracerInit = _lib.lookupFunction<TracerInitNative, TracerInitDart>('tracer_init');
    tracerProcessFrame = _lib.lookupFunction<TracerProcessFrameNative, TracerProcessFrameDart>('tracer_process_frame');
  }
}