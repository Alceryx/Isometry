import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabExerciseList extends StatefulWidget 
{
  const TabExerciseList({super.key});

  @override
  State<TabExerciseList> createState() => _TabExerciseListState();
}

class _TabExerciseListState extends State<TabExerciseList> 
{
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
                                        'IT WORKED!', 
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
              
                      SizedBox
                      (
                        width: double.infinity,
                        child: ColoredBox
                        (
                          color: Theme.of(context).colorScheme.secondary,
                          child: Padding
                          (
                            padding: const EdgeInsets.symmetric
                            (horizontal: 10, vertical: 5),
                            child: Text
                            (
                              'PLANCHE PRESS', 
                              style: Theme.of(context).textTheme.displayLarge?.
                              copyWith(color: Theme.of(context).colorScheme.onPrimary),
                            ),
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
                  )
                ],
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
                              SvgPicture.asset('assets/ui/tab_exercise/list_add.svg'),
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
                    )
                  ],
                ),
              )
            ],
          ),
        )
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