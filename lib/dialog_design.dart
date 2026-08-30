import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DialogDesign extends StatelessWidget 
{
  final String title;
  final TextEditingController titleController;
  final TextEditingController typeController;
  final bool needCloseButton; 
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap; 
  final String leftButtonText; 
  final String rightButtonText; 

  const DialogDesign
  ({
    super.key,
    required this.title,
    required this.titleController,
    required this.typeController,
    this.needCloseButton = true, 
    required this.onLeftTap,
    required this.onRightTap,
    required this.leftButtonText,
    required this.rightButtonText
  });

  @override
  Widget build(BuildContext context) 
  {
    return Center
    (
      child: Stack
      (
        alignment: AlignmentGeometry.centerStart,
        children: 
        [
          Column
          (
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
            [
              SizedBox(height: 15),
              SvgPicture.asset('assets/ui/dialog_card.svg', width: 365,)
            ]
          ),
      
          Positioned.fill
          (
            child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: 
              [
                Transform.translate
                (
                  offset: Offset(0, 2.5),
                  child: Text
                  (
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith
                    (color: Theme.of(context).colorScheme.primary,
                    height: 1),
                  ),
                ),
                SizedBox(height: 15,),
            
                //--------------
                //TITLE PROPERTY
                //--------------
      
                Row
                (
                  children: 
                  [
                    SizedBox(width: 20,),
                    SizedBox
                    (
                      height: 10, width: 10,
                      child: ColoredBox
                      (color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(width: 10,),
                              
                    Transform.translate
                    (
                      offset: Offset(0, 1.4),
                      child: Text
                      (
                        'Title',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith
                        (color: Theme.of(context).colorScheme.primary,
                        height: 0.8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3,),
      
                Row
                (
                  children: 
                  [
                    SizedBox(width: 20,),
                    SizedBox
                    (
                      width: 5, height: 25,
                      child: ColoredBox(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(width: 5,),
                    Expanded
                    (
                      child: Material
                      (
                        type: MaterialType.transparency,
                        child: TextField
                          (
                            controller: titleController,
                            style: Theme.of(context).textTheme.displaySmall,
                            decoration: InputDecoration
                            (
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric
                              (vertical: 5),
                              enabledBorder: OutlineInputBorder
                              (
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide
                                (
                                  width: 1.5,
                                  color: Theme.of(context).colorScheme.onSurface
                                )
                              ),
                              hintText: 'Enter a New Title',
                              hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith
                              (
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.2
                              )
                            )
                          ),
                        
                      ),
                    ),
      
                    SizedBox(width: 35,)
                  ],
                ),
                SizedBox(height: 10,),
      
                //-------------
                //TYPE PROPERTY
                //-------------
      
                Row
                (
                  children: 
                  [
                    SizedBox(width: 20,),
                    SizedBox
                    (
                      height: 10, width: 10,
                      child: ColoredBox
                      (color: Theme.of(context).colorScheme.primary),
                    ),
                    SizedBox(width: 10,),
                              
                    Transform.translate
                    (
                      offset: Offset(0, 1.4),
                      child: Text
                      (
                        'Type',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith
                        (color: Theme.of(context).colorScheme.primary,
                        height: 0.8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3,),
      
                Row
                (
                  children: 
                  [
                    SizedBox(width: 20,),
                    SizedBox
                    (
                      width: 5, height: 25,
                      child: ColoredBox(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(width: 5,),
                    Expanded
                    (
                      child: Material
                      (
                        type: MaterialType.transparency,
                        child: TextField
                          (
                            controller: typeController,
                            style: Theme.of(context).textTheme.displaySmall,
                            decoration: InputDecoration
                            (
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric
                              (vertical: 5),
                              enabledBorder: OutlineInputBorder
                              (
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide
                                (
                                  width: 1.5,
                                  color: Theme.of(context).colorScheme.onSurface
                                )
                              ),
                              hintText: 'Enter a New Type',
                              hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith
                              (
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.2
                              )
                            )
                          ),
                        
                      ),
                    ),
      
                    SizedBox(width: 35,)
                  ],
                ),
                SizedBox(height: 15,),
      
                Expanded
                (
                  child:Row
                  (
                    children: 
                    [
                      SizedBox(width: 101,),
                      GestureDetector
                      (
                        onTap: onLeftTap,
                        child: Stack
                        (
                          alignment: Alignment.center,
                          children: 
                          [
                            SvgPicture.asset('assets/ui/dialog_button_left.svg'),
                            Text
                            (
                              leftButtonText,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith
                              (color: Theme.of(context).colorScheme.primary),
                            )
                          ],
                        )
                      ),
                      SizedBox(width: 5,),

                      GestureDetector
                      (
                        onTap: onRightTap,
                        child: Stack
                        (
                          alignment: Alignment.center,
                          children: 
                          [
                            SvgPicture.asset('assets/ui/dialog_button_right.svg'),
                            Text
                            (
                              rightButtonText,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith
                              (color: Theme.of(context).colorScheme.primary),
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
      
          //------------
          //CLOSE BUTTON
          //------------

          needCloseButton?
          Positioned
          (
            top: 23,
            right: 9,
            child: GestureDetector
            (
              onTap: () => Navigator.pop(context),
              
              child: SvgPicture.asset
              ('assets/ui/button_close.svg', height: 25,)
            )
          )
          : SizedBox()
        ],
      ),
    );
  }
}