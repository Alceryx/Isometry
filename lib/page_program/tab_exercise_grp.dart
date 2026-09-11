import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:isometry/designs/page_layouts.dart';
import 'package:isometry/designs/dialog_design.dart';
import 'package:isometry/page_program/exercise_card_design.dart';

import 'package:isometry/dialog_data.dart';
import 'package:isometry/data_manager.dart';

import 'package:isometry/page_program/tab_session.dart';
import 'package:isometry/page_program/tab_exercise_list.dart';

class TabGrpGrid extends StatefulWidget 
{
  const TabGrpGrid({super.key});

  @override
  State<TabGrpGrid> createState() => _TabExerciseGrpState();
}

class _TabExerciseGrpState extends State<TabGrpGrid> 
{
  final double toolHeight = 33;
  final double cornerSize = 60; 

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
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox
                (
                  height: toolHeight,
                  child: Row
                  (
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: 
                    [
                      Expanded
                      (
                        child: SizedBox
                        (
                          child: Stack
                          (
                            alignment: Alignment.centerRight,
                            children: 
                            [
                              Row
                              (
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: 
                                [
                                  Expanded
                                  (
                                    child: ColoredBox
                                    (color: Theme.of(context).colorScheme.surface)
                                  ),
                                  SvgPicture.asset('assets/ui/search_bar.svg')
                                ]
                              ),

                              Padding
                              (
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: TextField
                                (
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith
                                  (
                                    color: Theme.of(context).colorScheme.onSurface
                                  ),
                                  decoration: InputDecoration
                                  (
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: 'SEARCH',
                                    hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith
                                    (
                                      color: Theme.of(context).colorScheme.onSurface
                                    )
                                  )
                                ),
                              )
                            ], //Search Bar
                          )
                        )
                      ),
                      SizedBox(width: 10),
                            
                      GestureDetector
                      (
                        onTap: () {},
                        child: SvgPicture.asset
                        (
                          'assets/ui/button_sort.svg',
                        ),
                      ),
                      SizedBox(width: 10,),
                            
                      GestureDetector
                      (
                        onTap: () {},
                        child: SvgPicture.asset
                        (
                          'assets/ui/button_select.svg',
                        ),
                      )
                    ] // ROW FOR TOOL BAR
                  ),
                ),
              ),
              
              //---------
              //CARD GRID
              //---------

              Expanded
              (
                child: Stack
                (
                  children: 
                  [
                    Column
                    (
                      children: 
                      [
                        SizedBox
                        (
                          height: cornerSize,
                          child: Row
                          (
                            children: 
                            [
                              SvgPicture.asset('assets/ui/grid_border/border_tl.svg'),
                        
                              Expanded
                              ( 
                                child: SvgPicture.asset
                                (
                                  'assets/ui/grid_border/border_t.svg', 
                                  fit: BoxFit.fill
                                )
                              ),
                        
                              SvgPicture.asset('assets/ui/grid_border/border_tr.svg')
                            ], //Top Grid Row
                          ),
                        ),

                        Expanded
                        (
                          child: 
                          Row
                          (
                            crossAxisAlignment: CrossAxisAlignment.stretch, //Force children's vertical stretch
                            children: 
                            [
                              SvgPicture.asset('assets/ui/grid_border/border_l.svg', fit: BoxFit.fill, width: cornerSize,),
                              
                              Expanded(child: ColoredBox(color: Theme.of(context).colorScheme.surface)),
                    
                              SvgPicture.asset('assets/ui/grid_border/border_r.svg', fit: BoxFit.fill, width: cornerSize,)
                            ], //Mid Grid Row
                          ),
                        ),
                    
                        SizedBox
                        (
                          height: cornerSize,
                          child: Row
                          (
                            children: 
                            [
                              SvgPicture.asset('assets/ui/grid_border/border_bl.svg'),
                              Expanded
                              (
                                child: SvgPicture.asset('assets/ui/grid_border/border_b.svg', fit: BoxFit.fill,)
                              ),
                              SvgPicture.asset('assets/ui/grid_border/border_br.svg')
                            ], //Bottom Grid Row
                          ),
                        ),
                      ], //COL FOR GRID BG
                    ),


                    Padding
                    (
                      padding: const EdgeInsets.all(15.0),
                      child: GridView.builder
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
                            // final card = gridData.items[index];
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
                                      child: TabExerciseList(),
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
                                          edittingCard: gridData.items[index]
                                        ),
                                      ); 
                                    }
                                  );
                                },
                              ),
                            );
                          }
                          else //Add Card Button
                          {
                            //TO DO: Add a separate add card instead of recycling grpcarddesign. 

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
                  ]
                )
              ),
            ],//COL FOR WHOLE PAGE
          ),
        ),
      ),
    );
  }
}