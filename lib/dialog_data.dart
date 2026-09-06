import 'package:flutter/material.dart';
import 'package:isometry/designs/dialog_design.dart';
import 'package:isometry/data_manager.dart';
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
      leftButtonText: 'Cancel', 
      rightButtonText: 'Save',
      cornerButton: CornerButton
      (
        img: 'assets/ui/button_close.svg', 
        onCornerTap: ()
        {
          context.read<GrpDataProvider>().deleteCard(widget.index);
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
  final TextEditingController typeController = TextEditingController();

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
      title: 'Adding', 
      titleController: titleController, 
      typeController: typeController, 
      onRightTap: () 
      {
        final newCard = GrpCardData
        (
          title: titleController.text, 
          type: typeController.text, 
        );

        context.read<GrpDataProvider>().addCard(newCard);
        Navigator.pop(context);
      }, 
      onLeftTap: () => Navigator.pop(context), 
      leftButtonText: 'Cancel',
      rightButtonText: 'Add',
    );
  }
}