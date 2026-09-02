import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isometry/page_program/exercise_tab.dart';

class CamTest extends StatefulWidget 
{
  const CamTest({super.key});

  @override
  State<CamTest> createState() => _CamTestState();
}

class _CamTestState extends State<CamTest> 
{
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
                  child: Placeholder(), 
                ),
              )
            ),
            
            // SizedBox
            // (
            //   height: 80,
            //   child: Row
            //   (
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: 
            //     [
            //       InkWell
            //       (
            //         onTap: () {}, 
            //         child: Text('Button 1')
            //       ),
              
            //       InkWell
            //       (
            //         onTap: () {}, 
            //         child: Text('Button 2')
            //       ),
              
            //       InkWell
            //       (
            //         onTap: () {}, 
            //         child: Text('Button 3')
            //       ),
            //     ],
            //   ),
            // )
          ],
        )
      ),
    );
  }
}