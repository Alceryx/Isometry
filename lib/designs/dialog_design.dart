// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:isometry/designs/custom_transitions.dart';

//-------------
//CALL FUNCTION
//-------------

Future<T?> showCustomDialog<T>
({
  required BuildContext context,
  required WidgetBuilder pageBuilder,
})
{
  return showGeneralDialog
  (
    barrierColor: Color.fromARGB(230, 0, 0, 0),
    context: context, 
    pageBuilder: (context, anim1, anim2) => pageBuilder(context),
    transitionBuilder: (context, anim1, anim2, child)
    {return RapidFadeAnimation(child: child);}
  );
}

//-------------
//DIALOG DESIGN
//-------------

class DialogDesign extends StatelessWidget 
{
  final String title;
  final TextEditingController titleController;
  final TextEditingController typeController;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap; 
  final String leftButtonText; 
  final String rightButtonText; 
  final CornerButton? cornerButton;

  const DialogDesign
  ({
    super.key,
    required this.title,
    required this.titleController,
    required this.typeController,
    required this.onLeftTap,
    required this.onRightTap,
    required this.leftButtonText,
    required this.rightButtonText,
    this.cornerButton 
  });

  @override
  Widget build(BuildContext context) 
  {
    return Padding
    (
      padding: EdgeInsets.only 
      (bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Center
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
                      DialogTextField
                      (
                        hintText: 'Enter a Group\'s Title',
                        controller: titleController, 
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
      
                      DialogTextField
                      (
                        hintText: 'Enter a Group\'s Type',
                        controller: typeController, 
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
        
            //-------------
            //CORNER BUTTON
            //-------------
      
            Positioned
            (
              top: 23,
              right: 9,
              child: cornerButton ?? SizedBox.shrink()
            )
          ],
        ),
      ),
    );
  }
}

//--------------------
//CORNER BUTTON DESIGN
//--------------------

class CornerButton extends StatelessWidget {
  const CornerButton
  ({
    super.key,
    required this.img, 
    required this.onCornerTap,
  });

  final String img; 
  final VoidCallback? onCornerTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector
    (
      onTap: onCornerTap,
      child: SvgPicture.asset
      ('assets/ui/button_close.svg', height: 25,)
    );
  }
}

class DialogTextField extends StatelessWidget 
{
  const DialogTextField
  ({
    super.key,
    required this.controller,
    required this.hintText, 
  });

  final TextEditingController controller;
  final String hintText; 

  @override
  Widget build(BuildContext context) 
  {
    final entryBorderDefault = OutlineInputBorder
    (
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide
      (
        width: 1.5,
        color: Theme.of(context).colorScheme.onSurface
      )
    );

    final entryBorderFocused = OutlineInputBorder
    (
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide
      (
        width: 1.5,
        color: Theme.of(context).colorScheme.primary
      )
    );
    
    return Expanded
    (
      child: Material
      (
        type: MaterialType.transparency,
        child: TextField
        (
          controller: controller,
          style: Theme.of(context).textTheme.displaySmall,
          decoration: InputDecoration
          (
            isDense: true,
            contentPadding: EdgeInsets.symmetric
            (vertical: 5),
            border: entryBorderDefault,
            enabledBorder: entryBorderDefault,
            focusedBorder: entryBorderFocused,
            errorBorder: entryBorderFocused,
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith
            (
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.2
            )
          )
        ),
      ),
    );
  }
}