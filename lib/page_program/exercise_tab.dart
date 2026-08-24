import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isometry/exercise_grp_data.dart';
import 'package:isometry/grid_card.dart';

class ExerciseGrpTab extends StatefulWidget 
{
  const ExerciseGrpTab({super.key});

  @override
  State<ExerciseGrpTab> createState() => _ExerciseGrpTabState();
}

class _ExerciseGrpTabState extends State<ExerciseGrpTab> 
{
  final double toolHeight = 33;
  final double cornerSize = 65; 

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea
      (
        child: Padding
        (
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column
          (
            children: 
            [
          
              //----------
              //PAGE TITLE
              //----------
          
              Center
              (
                child: Row
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  [
                    SizedBox
                    (
                      width: 7,height: 7,
                      child: DecoratedBox
                      (
                        decoration: BoxDecoration
                        (color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text
                    (
                      'Program', 
                      style: Theme.of(context).textTheme.displaySmall?.copyWith
                      (
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    ),
                    SizedBox(width: 10),
                    SizedBox
                    (
                      width: 7,height: 7,
                      child: DecoratedBox
                      (
                        decoration: BoxDecoration
                        (color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
              
              //---------
              //TAB TITLE
              //---------
          
              Row
              (
                children: 
                [
                  Expanded
                  (
                    child: Container
                    (
                      padding: const EdgeInsets.only(left: 10, right: 5, top: 5),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Row
                      (
                        children: 
                        [
                          Text
                          (
                            'Exercises', 
                            style: Theme.of(context).textTheme.displayLarge?.copyWith
                            (color: Theme.of(context).colorScheme.onPrimary)
                          ),
                          Spacer(flex: 1), 
                          Column
                          (
                            children: 
                            [
                              SizedBox
                              (
                                width: 5, height: 15,
                                child: DecoratedBox
                                (
                                  decoration: BoxDecoration
                                  (
                                    border: Border.all
                                    (
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      width: 1.5,
                                      strokeAlign: BorderSide.strokeAlignInside, // Keeps border entirely inside
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              SizedBox
                              (
                                width: 5, height: 5,
                                child: DecoratedBox
                                (
                                  decoration: BoxDecoration
                                  (color: Theme.of(context).colorScheme.onPrimary),
                                ),
                              ),
                              SizedBox(height: 2),
                              SizedBox
                              (
                                width: 5,height: 5,
                                child: DecoratedBox
                                (
                                  decoration: BoxDecoration
                                  (color: Theme.of(context).colorScheme.onPrimary),
                                ),
                              ),
                            SizedBox(height: 35), //Need auto adj height not hard-coded
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
          
                  //-----------
                  //NEXT BUTTON
                  //-----------
          
                  SizedBox(width: 10),
                  GestureDetector
                  (
                    onTap: () {},
                    child: SvgPicture.asset
                    (
                      'assets/ui/tab_navigator.svg',
                      width: 0, height: 70,
                    ),
                  ),
                  
                ], //ROW FOR TAB TITLE
              ),
          
              //--------
              //TOOL BAR
              //--------
          
              Padding
              (
                padding: const EdgeInsets.symmetric( vertical: 10),
                child: Row
                (
                  children: 
                  [
                    SizedBox
                    (
                      height: toolHeight,
                      width: 230,
                      child: Stack
                      (
                        children: 
                        [
                          SvgPicture.asset
                          (
                            'assets/ui/search_bar.svg',
                            height: toolHeight,
                          ),
                      
                          Padding
                          (
                            padding: EdgeInsetsGeometry.all(7),
                            child: TextField
                            (
                              style: Theme.of(context).textTheme.displaySmall,
                              decoration: InputDecoration
                              (
                                border: InputBorder.none,
                                hintText: 'Search',
                                hintStyle: Theme.of(context).textTheme.displaySmall
                              ),
                            ),
                          )
                        ] 
                      ),
                    ),
                    Spacer(flex:3),
          
                    GestureDetector
                    (
                      onTap: () {},
                      child: SvgPicture.asset
                      (
                        'assets/ui/button_sort.svg',
                        height: toolHeight,
                      ),
                    ),
                    Spacer(flex:1),
          
                    SvgPicture.asset
                    (
                      'assets/ui/button_select.svg',
                      height: toolHeight,
                    )
                  ] // ROW FOR TOOL BAR
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

                    GridView.builder
                    (
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount
                      (
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: grpData.length, //user will decide this
                      itemBuilder: (context, index) 
                      {
                        final card = grpData[index];
                        return GrpCard
                        (
                          title: card['title'] as String,
                          type: card['type'] as String,
                        );
                      },
                    ), 
                  ]
                )
              ),
              
              SizedBox(height: 20,)
            ],//COL FOR WHOLE PAGE
          ),
        ),
      ),
    );
  }
}