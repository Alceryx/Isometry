import 'dart:ffi';
import 'package:flutter/material.dart';

class Keypoint
{
  static const int count = 17;
  static const int dims = 3;

  final Offset pos;
  final double conf;

  Keypoint(this.pos, this.conf); 

  static List<Keypoint> decode(Pointer<Float> raw, int count)
  {
    return List.generate(count, (i) => Keypoint(
      Offset(raw[i*3+0], raw[i*3+1]), 
      raw[i*3+2]
      ));
  }
}
