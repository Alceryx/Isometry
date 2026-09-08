import 'package:flutter/material.dart';
import 'package:isometry/designs/dialog_design.dart';
import 'package:isometry/data_manager.dart';
import 'package:provider/provider.dart';

class GridEditDialog extends StatefulWidget 
{
  final GrpData edittingCard;
  final int index; 

  const GridEditDialog
  ({
    super.key,
    required this.index,
    required this.edittingCard
  });

  @override
  State<GridEditDialog> createState() => _EditCardDialogState();
}

class _EditCardDialogState extends State<GridEditDialog> 
{

  late final TextEditingController titleController 
    = TextEditingController(text: widget.edittingCard.title);
  late final TextEditingController subtitleController
    = TextEditingController(text: widget.edittingCard.subTitle);

  @override
  void dispose() 
  {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return CustomDialog
    (
      dialogTitle: 'EDITING', 

      firstField: DialogTextField
      (
        fieldTitle: 'TITLE', 
        textFieldController: titleController, 
        hintText: 'NEW TITLE'
      ),

      secondField: DialogTextField
      (
        fieldTitle: 'SUBTITLE', 
        textFieldController: subtitleController, 
        hintText: 'NEW SUBTITLE'
      ),

      leftButtonText: 'CANCEL', 
      rightButtonText: 'SAVE',

      onLeftTap: () => Navigator.pop(context),  
      
      onRightTap: ()
      {
        context.read<GrpData>().edit
        (
          GrpData
          (
            title: titleController.text, 
            subTitle: subtitleController.text, 
            exercises: ExerciseList()
          )
        );
        Navigator.pop(context);
      }, 
      
      cornerButton: CornerButton
      (
        img: 'assets/ui/button_close.svg', 
        onCornerTap: ()
        {
          context.read<GridData>().deleteItem(widget.index);
          Navigator.pop(context);
        },
      ),
    );
  }
}


class AddCardDialog extends StatefulWidget 
{
  const AddCardDialog({super.key});

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> 
{
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();

  @override
  void dispose() 
  {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return CustomDialog
    (
      dialogTitle: 'ADDING', 
      firstField: DialogTextField
      (
        fieldTitle: 'TITLE', 
        textFieldController: titleController, 
        hintText: 'NEW TITLE'
      ), 
      secondField: DialogTextField
      (
        fieldTitle: 'SUBTITLE',
        textFieldController: subtitleController,
        hintText: 'NEW SUBTITLE',
      ),
      leftButtonText: 'CANCEL',
      rightButtonText: 'ADD',
      onRightTap: () 
      {
        final newGrp = GrpData
        (
          title: titleController.text, 
          subTitle: subtitleController.text,
          exercises: ExerciseList(),
        );

        context.read<GridData>().addItem(newGrp);
        Navigator.pop(context);
      }, 

      onLeftTap: () => Navigator.pop(context), 
      
    );
  }
}

//TO DO: Make edit & add dialogs recyclable. 