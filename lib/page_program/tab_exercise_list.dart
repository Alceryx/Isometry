import 'package:flutter/material.dart';
import 'package:isometry/page_program/tab_exercise_list_design.dart';
import 'package:provider/provider.dart';

import 'package:isometry/data_manager.dart';

class TabExerciseList extends StatefulWidget 
{
  final GrpData grpData; 

  const TabExerciseList
  ({
    super.key,
    required this.grpData,
  });

  @override
  State<TabExerciseList> createState() => _TabExerciseListState();
}

class _TabExerciseListState extends State<TabExerciseList> 
{
  @override
  Widget build(BuildContext context) 
  {
    final exerciseData = context.watch<ExerciseList>();
    return TabExerciseListDesign
    (
      grpTitle: widget.grpData.title,
      grpSubtitle: widget.grpData.subTitle,
    );
  }
}

// class Temp extends StatelessWidget {
//   const Temp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold
//     (
//       body: Column
//       (
//         children: 
//         [
//           TextButton
//           (
//             onPressed: () 
//             {
//               Navigator.of(context).pop(context); 
//             },
//             child: Text('Back Button'),
//           ),
      
//           TextButton //Add Exercise Button
//           (
//             onPressed: () 
//             {
//               context.read<ExerciseList>().addItem
//               (
//                 ExerciseData(title: 'Exercise1', tags: TagListLocal())
//               );
//             },
//             child: Text('Add Exercise'),
//           ),
      
//           Expanded
//           (
//             child: ListView.builder
//             (
//               itemCount: exerciseData.items.length,
//               itemBuilder: (context, index)
//               {
//                 final exerciseCard = exerciseData.items[index];
//                 return Row
//                 (
//                   children: 
//                   [
//                     Text(exerciseCard.title),
//                     TextButton
//                     (
//                       onPressed: () {},
//                       child: Text('Options')
//                     )
//                   ],
//                 ); 
//               }
//             ),
//           )
//         ],
//       ),
//     );;
//   }
// }