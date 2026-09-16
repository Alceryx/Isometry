import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isometry/designs/text_trim.dart';

class TabExerciseListDesign extends StatelessWidget 
{
  final String grpTitle; 
  final String grpSubtitle;
  final VoidCallback onAddTap;
  final Widget exerciseListBuilder;

  const TabExerciseListDesign
  ({
    super.key,
    required this.grpTitle,
    required this.grpSubtitle,
    required this.onAddTap,
    required this.exerciseListBuilder
  });

  @override
  Widget build(BuildContext context) 
  {
    final double grpInfoBottomHeight = 60;
    final double listNavigatorHeight = grpInfoBottomHeight * 44.3/63; 
    final double grpInfoSubtitleHeight = 40;
    final double cornerSize = 25; 
    return Scaffold
    (
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea
      (
        child: Padding
        (
          padding: const EdgeInsets.all(20),
          child: Column
          (
            children: 
            [
              Stack
              (
                children: 
                [
                  //-------------
                  //GRP INFO CARD
                  //-------------
              
                  Column
                  (
                    children: 
                    [
                      SizedBox
                      (
                        height: grpInfoSubtitleHeight,
                        child: Row
                        (
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: 
                          [
                            ClipPath
                            (
                              clipper: SubtitleClipper(),
                              child: ColoredBox
                              (
                                color: Theme.of(context).colorScheme.secondary,
                                child: Padding
                                (
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  child: Row(
                                    children: 
                                    [
                                      Text
                                      (
                                        grpSubtitle, 
                                        style: Theme.of(context).textTheme.displayMedium?.
                                        copyWith(color: Theme.of(context).colorScheme.onPrimary),
                                      ),
                                      SizedBox(width: 30,)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

          
                      //GRP TITLE

                      SizedBox
                      (
                        width: double.infinity,
                        child: ColoredBox
                        (
                          color: Theme.of(context).colorScheme.secondary,
                          child: Padding
                          (
                            padding: const EdgeInsets.only
                            (left: 10, right: 10, top: 10, bottom: 5),
                            child: TextTrimmer
                            (
                              content: grpTitle, 
                              style: Theme.of(context).textTheme.displayLarge, 
                              textColor: Theme.of(context).colorScheme.onPrimary, 
                              trimMetrics: TrimMetrics.mainTypeface
                            )
                          ),
                        )
                      ),
              
                      SizedBox
                      (
                        height: grpInfoBottomHeight,
                        child: Row
                        (
                          children: 
                          [
                            SvgPicture.asset('assets/ui/tab_exercise/title_bl.svg'),
                            Expanded(child: SvgPicture.asset('assets/ui/tab_exercise/title_expandable.svg', fit: BoxFit.fill,)),
                            SvgPicture.asset('assets/ui/tab_exercise/title_br.svg'),
                          ],
                        ),
                      )
                    ], // COL FOR GRP INFO CARD
                  ),

                  Positioned
                  (
                    left: 0,
                    bottom: 0,
                    child: GestureDetector
                    (
                      onTap: () => Navigator.of(context).pop(),
                      child: SizedBox
                      (
                        height: grpInfoBottomHeight / 1.5,
                        child: SvgPicture.asset('assets/ui/tab_exercise/list_back.svg')
                      ),
                    ),
                  )
                ], //STACK FOR GRP DATA INFO
              ),

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
                          height: listNavigatorHeight,
                          child: Row
                          (
                            children: 
                            [
                              GestureDetector
                              (
                                onTap: onAddTap,
                                child: SvgPicture.asset('assets/ui/tab_exercise/list_add.svg')
                              ),
                              SvgPicture.asset('assets/ui/tab_exercise/list_link.svg'),
                              Expanded(child: SizedBox()),
                              SvgPicture.asset('assets/ui/tab_exercise/list_sort.svg')
                            ], // ROW FOR LIST NAVIGATION
                          ),
                        ),
                
                        SizedBox
                        (
                          height: cornerSize,
                          child: Row
                          (
                            children: 
                            [
                              SvgPicture.asset('assets/ui/tab_exercise/list_tl.svg'),
                              Expanded(child: SvgPicture.asset('assets/ui/tab_exercise/list_t.svg', fit: BoxFit.fill,)),
                              SvgPicture.asset('assets/ui/tab_exercise/list_tr.svg')
                            ], //LIST TOP ROW
                          ),
                        ),
                        
                        Expanded
                        (
                          child: Row
                          (
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: 
                            [
                              SizedBox
                              (
                                width: cornerSize,
                                child: SvgPicture.asset('assets/ui/tab_exercise/list_l.svg', fit: BoxFit.fill,)
                              ),
                              Expanded
                              (
                                child: SizedBox
                                (
                                  child: ColoredBox
                                  (color: Theme.of(context).colorScheme.surface),
                                ),
                              ),
                              SizedBox
                              (
                                width: cornerSize,
                                child: SvgPicture.asset('assets/ui/tab_exercise/list_r.svg',fit: BoxFit.fill)
                              )
                            ],
                          ),
                        ),
                
                        SizedBox
                        (
                          height: cornerSize,
                          child: Row
                          (
                            children: 
                            [
                              SvgPicture.asset('assets/ui/tab_exercise/list_bl.svg'),
                              Expanded(child: SvgPicture.asset('assets/ui/tab_exercise/list_b.svg', fit: BoxFit.fill,)),
                              SvgPicture.asset('assets/ui/tab_exercise/list_br.svg')
                            ], //LIST BOTTOM ROW
                          ),
                        )
                      ],
                    ),
                    
                    Padding
                    (
                      padding: const EdgeInsets.only
                      (top: 50.0, left: 15, right: 15, bottom: 20),
                      child: exerciseListBuilder
                    )
                  ], //STACK FOR EXERCISE LIST
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget 
{
  final String exerciseTitle; 
  final VoidCallback onOptionTap; 

  const ExerciseCard
  ({
    super.key, 
    required this.exerciseTitle,
    required this.onOptionTap
  });

  @override
  Widget build(BuildContext context) 
  {
    return SizedBox
    (
      height: 55,
      child: Row
      (
        children: 
        [
          GestureDetector
          (
            onTap: onOptionTap,
            child: SvgPicture.asset('assets/ui/tab_exercise/list_option.svg')
          ),
          SizedBox(width: 7,),
          Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              TextTrimmer
              (
                content: exerciseTitle, 
                trimMetrics: TrimMetrics.mainTypeface,
                style: Theme.of(context).textTheme.titleMedium,
                textColor: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(height: 5,),

              //PLACEHOLDER FOR TAG ROW
              Expanded
              (
                child: ColoredBox
                (
                  color: Theme.of(context).colorScheme.primary,
                  child: SizedBox
                  (
                    child: Padding
                    (
                      padding: const EdgeInsets.all(3),
                      child: TextTrimmer
                      (
                        content: 'ACCESSORY', 
                        trimMetrics: TrimMetrics.secondaryTypeface,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textColor: Theme.of(context).colorScheme.onPrimary
                      ),
                    )
                  )
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class SubtitleClipper extends CustomClipper<Path>
{
  @override Path getClip(Size size) 
  {
    return Path()
    ..moveTo(0, 0)
    ..lineTo(size.width-size.height, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close(); 
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) 
  => false;
}