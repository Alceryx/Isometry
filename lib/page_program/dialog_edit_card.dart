import 'package:flutter/material.dart';
import 'package:isometry/dialog_design.dart';
import 'package:isometry/page_program/exercise_card_data.dart';
import 'package:isometry/page_program/exercise_card_data_provider.dart';
import 'package:provider/provider.dart';

class EditCardDialog extends StatefulWidget 
{
  final int index; 
  final GrpCardData edittingCard;
  const EditCardDialog
  ({
    super.key,
    required this.index,
    required this.edittingCard
  });

  @override
  State<EditCardDialog> createState() => _EditCardDialogState();
}

class _EditCardDialogState extends State<EditCardDialog> 
{

  late final TextEditingController titleController 
    = TextEditingController(text: widget.edittingCard.title);
  late final TextEditingController typeController
    = TextEditingController(text: widget.edittingCard.type);

  @override
  void dispose() 
  {
    titleController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return DialogDesign
    (
      title: 'Editing', 
      titleController: titleController, 
      typeController: typeController, 
      onLeftTap: () 
      {
        context.read<GrpDataProvider>().deleteCard(widget.index);
        Navigator.pop(context);
      },  
      onRightTap: ()
      {
        context.read<GrpDataProvider>().updateCard
        (
          widget.index, 
          GrpCardData
          (
            title: titleController.text, 
            type: typeController.text, 
          )
        );
        Navigator.pop(context);
      }, 
      leftButtonText: 'Delete', 
      rightButtonText: 'Save'
    );
  }
}
    