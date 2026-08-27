import 'package:flutter/material.dart';
import 'package:isometry/exercise_grp_card.dart';
import 'package:isometry/exercise_grp_data.dart';
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
            final newCard = GrpCard
            (
              title: titleController.text, 
              type: typeController.text, 
              img: 'assets/ui/grp_card.svg',
              isAddCard: false,
            );

            context.read<GrpData>().addCard(newCard);
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