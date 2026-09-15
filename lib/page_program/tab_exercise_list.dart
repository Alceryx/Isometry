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
      onAddTap: () 
      {
        context.read<ExerciseList>().addItem
        (
          ExerciseData(title: 'Exercise1', tags: TagListLocal())
        );
      },
      exerciseListBuilder: ListView.builder
      (
        itemCount: exerciseData.items.length,
        itemBuilder: (context, index)
        {
          final exerciseCard = exerciseData.items[index];
          return Padding
          (
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ExerciseCard
            (
              onOptionTap: () {}
            ),
          );
        }
      ),
    );
  }
}