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
        

        

        //---------
        //TAB TITLE
        //---------

        Row
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
                padding: const EdgeInsets.only(left: 10, right: 5, top: 5),
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
              onTap: onNextTap, 
              child: SvgPicture.asset
              (
                'assets/ui/tab_navigator_next.svg',
                width: 0, height: 70,
              ),
            ),

          ], //ROW FOR TAB TITLE
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