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

class CustomDialog extends StatelessWidget 
{
  final String dialogTitle;
  final DialogField firstField; 
  final DialogField secondField; 
  final String leftButtonText; 
  final String rightButtonText; 
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap; 
  final CornerButton? cornerButton;

  const CustomDialog
  ({
    super.key,
    required this.dialogTitle,
    required this.firstField,
    required this.secondField,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftTap,
    required this.onRightTap,
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
                  Text
                  (
                    dialogTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith
                    (color: Theme.of(context).colorScheme.primary,
                    height: 1),
                  ),
                  SizedBox(height: 15,),
              
                  //--------------
                  //FIRST PROPERTY
                  //--------------
        
                  firstField,
                  SizedBox(height: 10,),
        
                  //---------------
                  //SECOND PROPERTY
                  //---------------
        
                  secondField,
                  SizedBox(height: 15,),
        
                  //--------------
                  //BOTTOM BUTTONS
                  //--------------

                  Expanded
                  (
                    child:Row
                    (
                      children: 
                      [
                        SizedBox(width: 106,),
                        GestureDetector
                        (
                          onTap: onLeftTap,
                          child: Stack
                          (
                            alignment: Alignment.center,
                            children: 
                            [
                              SvgPicture.asset('assets/ui/dialog_button_left.svg'),
                              Padding
                              (
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text
                                (
                                  leftButtonText,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith
                                  (color: Theme.of(context).colorScheme.primary),
                                ),
                              )
                            ],
                          )
                        ),
                        SizedBox(width: 8,),
      
                        GestureDetector
                        (
                          onTap: onRightTap,
                          child: Stack
                          (
                            alignment: Alignment.center,
                            children: 
                            [
                              SvgPicture.asset('assets/ui/dialog_button_right.svg'),
                              Padding
                              (
                                padding: const EdgeInsets.only(right: 3.0),
                                child: Text
                                (
                                  rightButtonText,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith
                                  (color: Theme.of(context).colorScheme.primary),
                                ),
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

class CornerButton extends StatelessWidget 
{
  const CornerButton
  ({
    super.key,
    required this.img, 
    required this.onCornerTap,
  });

  final String img; 
  final VoidCallback? onCornerTap;

  @override
  Widget build(BuildContext context) 
  {
    return GestureDetector
    (
      onTap: onCornerTap,
      child: SvgPicture.asset
      ('assets/ui/button_close.svg', height: 25,)
    );
  }
}

//-------------------
//DIALOG FIELD STRUCT
//-------------------

abstract class DialogField extends StatelessWidget
{
  const DialogField
  ({
    super.key,
    required this.fieldTitle
  });

  final String fieldTitle; 
  Widget buildField(BuildContext context);

  @override
  Widget build(BuildContext context) 
  {
    return Column
    (
      children: 
      [
        //-----
        //TITLE
        //-----

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
            SizedBox(width: 7,),
                      
            Text
            (
              fieldTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith
              (color: Theme.of(context).colorScheme.primary,
              height: 0.8),
            ),
          ],
        ),
        SizedBox(height: 4,),

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
            (child: buildField(context)),
            SizedBox(width: 30,)
          ]
        )
      ]
    );
  }
}

//-----------------
//DIALOG TEXT FIELD
//-----------------

class DialogTextField extends DialogField
{
  const DialogTextField
  ({
    super.key,
    required super.fieldTitle,
    required this.textFieldController,
    required this.hintText,
  });

  final TextEditingController textFieldController;
  final String hintText; 

  @override
  Widget buildField(BuildContext context) 
  {

    //CUSTOM BORDERS

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

    return Material
    (
      type: MaterialType.transparency,
      child: TextField
      (
        controller: textFieldController,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration
        (
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          border: entryBorderDefault,
          enabledBorder: entryBorderDefault,
          focusedBorder: entryBorderFocused,
          errorBorder: entryBorderFocused,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith
          (color: Theme.of(context).colorScheme.onSurface)
        )
      ),
    );
  }
}

//---------------------
//DIALOG DROPDOWN FIELD
//---------------------

class DialogDropdownField extends DialogField
{
  const DialogDropdownField
  ({
    super.key,
    required super.fieldTitle
  });

  @override
  Widget buildField(BuildContext context) 
  {
    return SizedBox(height: 10,);
  }
}

