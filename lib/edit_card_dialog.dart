import 'package:flutter/material.dart';
import 'package:isometry/exercise_grp_card.dart';
import 'package:isometry/exercise_grp_data.dart';
import 'package:provider/provider.dart';

class EditCardDialog extends StatefulWidget 
{
  final int index; 
  final GrpCard edittingCard;
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
    return AlertDialog
    (
      title: Text
      (
        'Editing ${widget.edittingCard.title}',
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
              hintText: 'Enter a New Title',
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
              hintText: 'Enter a New Type',
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
          child: Text('Delete'),
          onPressed: () 
          {
            context.read<GrpData>().deleteCard(widget.index);
            Navigator.pop(context);
          }, 
        ),

        TextButton
        (
          child: Text('Save'),
          onPressed: () 
          {
            context.read<GrpData>().updateCard
            (
              widget.index, 
              GrpCard
              (
                title: titleController.text, 
                type: typeController.text, 
                img: widget.edittingCard.img, 
                isAddCard: false
              )
            );
            Navigator.pop(context);
          },
        ),

        TextButton
        (
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context), 
        )
      ],
    );
  }
}