import 'package:flutter/material.dart';
import 'package:isometry/dialog_design.dart';
import 'package:isometry/page_program/exercise_card_data.dart';
import 'package:isometry/page_program/exercise_card_data_provider.dart';
import 'package:provider/provider.dart';

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
      needCloseButton: false,
    );
    
  }
}