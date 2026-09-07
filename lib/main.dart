import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:isometry/page_program/tab_exercise_grp.dart';
import 'package:isometry/data_manager.dart';

void main() 
{  runApp
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
          secondary: Color(0xFFD8D9D9),
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
            fontFamily: 'Liberator',
            fontSize: 57,
            fontWeight: FontWeight.w500,
          ),

          displaySmall: TextStyle
          (
            fontFamily: 'Liberator',
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),

          titleLarge: TextStyle
          (
            fontFamily: 'Liberator',
            fontSize: 40,
            fontWeight: FontWeight.w300,
          ),

          titleMedium: TextStyle
          (
            fontFamily: 'Liberator',
            fontSize: 24,
            fontWeight: FontWeight.w100,
          ),

          titleSmall: TextStyle
          (
            fontFamily: 'Liberator',
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),

      ),
      home: TabGrpGrid(),
    );
  }
}