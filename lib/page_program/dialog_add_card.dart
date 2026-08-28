import 'package:flutter/material.dart';
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
    return AlertDialog
    (
      title: Text
      (
        'New Exercise Group',
        style: Theme.of(context).textTheme.titleMedium?.copyWith
        (
          color: Theme.of(context).colorScheme.primary
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      content: Column
      (
        mainAxisSize: MainAxisSize.min,
        children: 
        [
          TextField
          (
            controller: titleController,
            style: Theme.of(context).textTheme.displaySmall,
            decoration: InputDecoration
            (
              border: InputBorder.none,
              hintText: 'Enter a Title',
              hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith
              (
                color: Theme.of(context).colorScheme.onSurface
              )
            )
          ),

          TextField
          (
            controller: typeController,
            style: Theme.of(context).textTheme.displaySmall,
            decoration: InputDecoration
            (
              border: InputBorder.none,
              hintText: 'Enter a Type',
              hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith
              (
                color: Theme.of(context).colorScheme.onSurface
              )
            )
          )
        ],
      ),

      actions: 
      [
        TextButton
        (
          
          onPressed: () 
          {
            final newCard = GrpCardData
            (
              title: titleController.text, 
              type: typeController.text, 
            );

            context.read<GrpDataProvider>().addCard(newCard);
            Navigator.pop(context);
          }, 
          child: Text('Add')
        ),

        TextButton
        (
          onPressed: () => Navigator.pop(context), 
          child: Text('Cancel')
        )
      ],
    );
  }
}