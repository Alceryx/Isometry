import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
// import 'package:flutter_svg/flutter_svg.dart';

import 'package:isometry/designs/page_elements.dart';
import 'package:isometry/designs/dialog_design.dart';
import 'package:isometry/page_program/tab_exercise/grp_card_design.dart';

import 'package:isometry/dialog_data.dart';
import 'package:isometry/data_manager.dart';

import 'package:isometry/page_program/tab_exercise/tab_exercise_list.dart';
import 'package:isometry/page_program/tab_session/tab_session.dart';

class TabGrpGrid extends StatefulWidget 
{
  const TabGrpGrid({super.key});

  @override
  State<TabGrpGrid> createState() => _TabExerciseGrpState();
}

class _TabExerciseGrpState extends State<TabGrpGrid> 
{
  @override
  Widget build(BuildContext context) 
  {
    final gridData = context.watch<GridData>();

    return Scaffold
    (
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea
      (
        child: Padding
        (
          padding: const EdgeInsets.only
          (bottom: 20, top: 10, left: 20, right: 20),
          child: Column
          (
            children: 
            [
              //-----------
              //PAGE HEADER
              //-----------

              PageHeader
              (
                pageTitle: 'PROGRAM', 
                tabTitle: 'EXERCISE',
                onNextTap: () 
                {
                  Navigator.of(context).push
                  (MaterialPageRoute(builder: (context) 
                  {
                    return SessionTab();
                  }));
                },
              ),
          
              //--------
              //TOOL BAR  
              //--------

              Padding
              (
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: PageSearchBar(toolHeight: 33,),
              ),
              
              //---------
              //CARD GRID
              //---------

              PageListViewer
              (
                listViewer: GridView.builder
                (
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount
                  (
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: gridData.items.length + 1,
                  itemBuilder: (context, index) 
                  {
                    if (index < gridData.items.length)
                    {
                      return ChangeNotifierProvider.value
                      (
                        value: gridData.items[index],
                        child: GrpCardDesign
                        (
                          onCardTap: () 
                          {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) 
                            {
                              return ChangeNotifierProvider.value
                              (
                                value: context.read<GridData>().items[index].exercises,
                                child: TabExerciseList(grpData: gridData.items[index]),
                              );
                            }));
                          },
                          onOptionTap: ()
                          {
                            showCustomDialog
                            (
                              context: context, 
                              pageBuilder: (context) 
                              {
                                return ChangeNotifierProvider.value
                                (
                                  value: context.read<GridData>().items[index],
                                  child: GridEditDialog
                                  (
                                    index: index,
                                    edittingItem: gridData.items[index]
                                  ),
                                ); 
                              }
                            );
                          },
                        ),
                      );
                    }
                    else
                    {
                      return AddCard
                      (
                        onCardTap: () 
                        {
                          showCustomDialog
                          (
                            context: context,
                            pageBuilder: (context) => AddCardDialog(),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],//COL FOR WHOLE PAGE
          ),
        ),
      ),
    );
  }
}