import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PageHeader extends StatelessWidget 
{
  final String pageTitle;
  final String tabTitle; 
  final VoidCallback onNextTap;  
  final PageBackButton? backButton; 

  const PageHeader
  ({
    super.key,
    required this.pageTitle,
    required this.tabTitle,
    required this.onNextTap,
    this.backButton, 
  });

  @override
  Widget build(BuildContext context) 
  {
    return Column
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
                pageTitle, 
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
        SizedBox(height: 3,),

        //---------
        //TAB TITLE
        //---------

        SizedBox
        (
          height: 65,
          child: Row
          (
            children: 
            [
              //-----------
              //BACK BUTTON
              //-----------
              backButton ?? SizedBox(width: 0,),
          
              Expanded
              (
                child: Container
                (
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Row
                  (
                    children: 
                    [
                      Text
                      (
                        tabTitle, 
                        style: Theme.of(context).textTheme.displayLarge?.copyWith
                        (color: Theme.of(context).colorScheme.onPrimary)
                      ),
                      Spacer(flex: 1), 
                      Column
                      (
                        children: 
                        [
                          SizedBox(height: 5,),
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
                        Spacer(flex: 1,) //Need auto adj height not hard-coded
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              
              //-----------
              //NEXT BUTTON
              //-----------

              GestureDetector
              (
                onTap: onNextTap, 
                child: SvgPicture.asset('assets/ui/tab_navigator_next.svg',),
              ),
          
            ], //ROW FOR TAB TITLE
          ),
        ),
      ]
    );
  }
}

class PageBackButton extends StatelessWidget 
{
  final VoidCallback? onBacktap;

  const PageBackButton
  ({
    super.key,
    required this.onBacktap,
  });

  @override
  Widget build(BuildContext context) 
  {
    return Row
    (
      children: 
      [
        GestureDetector
        (
          onTap: onBacktap,
          child: SvgPicture.asset
          (
            'assets/ui/tab_navigator_back.svg',
            width: 0, height: 70,
          ),
        ),
        SizedBox(width: 10,),
      ],
    );
  }
}

class PageSearchBar extends StatelessWidget 
{
  final double toolHeight;

  const PageSearchBar
  ({
    super.key,
    required this.toolHeight
  });

  @override
  Widget build(BuildContext context) 
  {
    return SizedBox
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
    );
  }
}

class PageListViewer extends StatelessWidget 
{
  const PageListViewer
  ({
    super.key,
    required this.listViewer
  });

  final Widget listViewer; 

  @override
  Widget build(BuildContext context) 
  {
    final double cornerSize = 60;
    return Expanded
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
            child: listViewer
          ), 
        ]
      )
    );
  }
}