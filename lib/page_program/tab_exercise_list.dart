import 'package:flutter/material.dart';
import 'package:isometry/designs/dialog_design.dart';
import 'package:isometry/dialog_data.dart';
import 'package:isometry/data_manager.dart';
import 'package:isometry/page_program/exercise_card_data_provider.dart';
import 'package:provider/provider.dart';

class ExerciseList extends StatefulWidget 
{
  final int index;
  const ExerciseList
  ({
    super.key,
    required this.index
  });

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> 
{
  @override
  Widget build(BuildContext context) 
  {
    final grpData = context.watch<GrpDataProvider>().cards[widget.index]; 
    return Scaffold
    (
      body: Column
      (
        children: 
        [
          TextButton
          (
            onPressed: () 
            {
              Navigator.of(context).pop(context); 
            },
            child: Text('Back Button'),
          ),
      
          TextButton //Add Exercise Button
          (
            onPressed: () 
            {
              context.read<GrpDataProvider>().addExercise
              (widget.index, ExerciseCardData(name: 'Exercise 1'));
            },
            child: Text('Add Exercise'),
          ),
      
          Expanded
          (
            child: ListView.builder
            (
              itemCount: grpData.exercises.length,
              itemBuilder: (context, index)
              {
                final exerciseCard = grpData.exercises[index];
                return Row
                (
                  children: 
                  [
                    Text(exerciseCard.name),
                    TextButton
                    (
                      onPressed: () {},
                      child: Text('Options')
                    )
                  ],
                ); 
              }
            ),
          )
        ],
      ),
    );
  }
}