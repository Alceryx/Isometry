import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:isometry/designs/page_layouts.dart';
import 'package:isometry/designs/custom_transitions.dart';
import 'package:isometry/designs/dialog_design.dart';
import 'package:isometry/page_program/exercise_card_design.dart';

import 'package:isometry/dialog_data.dart';
import 'package:isometry/page_program/exercise_card_data.dart';
import 'package:isometry/page_program/exercise_card_data_provider.dart';

import 'package:isometry/page_program/tab_session.dart';
import 'package:isometry/page_program/tab_exercise_list.dart';

class ExerciseGrpTab extends StatefulWidget 
{
  const ExerciseGrpTab({super.key});

  @override
  State<ExerciseGrpTab> createState() => _ExerciseGrpTabState();
}

class _ExerciseGrpTabState extends State<ExerciseGrpTab> 
{
  final double toolHeight = 33;
  final double cornerSize = 60; 

  @override
  Widget build(BuildContext context) 
  {
    final cardData = context.watch<GrpDataProvider>();
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
                pageTitle: 'Program', 
                tabTitle: 'Exercise',
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
                                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 7),
                                child: TextField
                                (
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith
                                  (
                                    color: Theme.of(context).colorScheme.onSurface
                                  ),
                                  decoration: InputDecoration
                                  (
                                    border: InputBorder.none,
                                    hintText: 'Search',
                                    hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith
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
                                  fit: BoxFit.fill, alignment: Alignment.center,
                                )
                              ),
                        
                              SvgPicture.asset('assets/ui/grid_border/border_tr.svg')
                            ],
                          ),
                        ), //Top Grid Row
                    
                        Expanded
                        (
                          child: 
                          Row
                          (
                            crossAxisAlignment: CrossAxisAlignment.stretch, //Force children's vertical stretch
                            children: 
                            [
                              SvgPicture.asset('assets/ui/grid_border/border_l.svg', fit: BoxFit.fill, alignment: Alignment.center, width: cornerSize,),
                              
                              Expanded(child: ColoredBox(color: Theme.of(context).colorScheme.surface)),
                    
                              SvgPicture.asset('assets/ui/grid_border/border_r.svg', fit: BoxFit.fill, alignment: Alignment.center, width: cornerSize,)
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
                        itemCount: cardData.cards.length + 1,
                        itemBuilder: (context, index) 
                        {
                          if (index < cardData.cards.length)
                          {
                            final card = cardData.cards[index];
                            return GrpCardDesign
                            (
                              cardData: GrpCardData
                              (title: card.title, type: card.type),
                              img: 'assets/ui/grp_card.svg',
                              isAddCard: false,
                              onCardTap: () 
                              {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) 
                                {
                                  return ExerciseList(index: index);
                                }));
                              },
                              onOptionTap: ()
                              {
                                showCustomDialog
                                (
                                  context: context, 
                                  pageBuilder: (context) => EditCardDialog
                                  (
                                    index: index, 
                                    edittingCard: cardData.cards[index]
                                  ),
                                );
                              },
                            );
                          }
                          else //Add Card Button
                          {
                            return GrpCardDesign
                            (
                              cardData: GrpCardData
                              (title: '', type: ''),
                              img: 'assets/ui/add_card.svg',
                              isAddCard: true,
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