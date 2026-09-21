import 'package:flutter/material.dart';
import 'package:isometry/designs/dialog_design.dart';
import 'package:isometry/dialog_data.dart';
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
    final exerciseListData = context.watch<ExerciseList>();
    return TabExerciseListDesign
    (
      grpTitle: widget.grpData.title,
      grpSubtitle: widget.grpData.subTitle,
      onAddTap: () 
      {
        showCustomDialog
        (
          context: context, 
          pageBuilder: (context) 
          {
            return ChangeNotifierProvider.value
            (
              value: exerciseListData,
              child: AddExerciseDialog(),
            );  
          }
        );
      },
      exerciseListBuilder: ListView.builder
      (
        itemCount: exerciseListData.items.length,
        itemBuilder: (context, index)
        {
          return Padding
          (
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ExerciseCard
            (
              exerciseData: exerciseListData.items[index],
              onOptionTap: () {}
            ),
          );
        }
      ),
    );
  }
}