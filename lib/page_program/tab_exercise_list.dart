import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:isometry/data_manager.dart';

class TabExerciseList extends StatefulWidget 
{
  const TabExerciseList
  ({
    super.key
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
              context.read<ExerciseList>().addItem
              (
                ExerciseData(title: 'Exercise1', tags: TagListLocal())
              );
            },
            child: Text('Add Exercise'),
          ),
      
          Expanded
          (
            child: ListView.builder
            (
              itemCount: exerciseData.items.length,
              itemBuilder: (context, index)
              {
                final exerciseCard = exerciseData.items[index];
                return Row
                (
                  children: 
                  [
                    Text(exerciseCard.title),
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