import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    return Center
    (
      child: Padding
      (
        padding: const EdgeInsets.all(15),
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
                SizedBox(height: 25),
                SvgPicture.asset('assets/ui/dialog_card.svg')
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
                    'Editing',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith
                    (color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(height: 10,),
              
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
                                
                      Text
                      (
                        'Title',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith
                        (color: Theme.of(context).colorScheme.primary),
                      ),
                      SizedBox(width: 10,),
                    ],
                  ),

                  Row
                  (
                    children: 
                    [
                      SizedBox(width: 20,),
                      SizedBox
                      (
                        width: 5, height: 23,
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
                                contentPadding: EdgeInsets.all(2),
                                enabledBorder: OutlineInputBorder
                                (
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide
                                  (
                                    width: 2,
                                    color: Theme.of(context).colorScheme.onSurface
                                  )
                                ),
                                hintText: 'Enter a New Title',
                                hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith
                                (
                                  color: Theme.of(context).colorScheme.onSurface
                                )
                              )
                            ),
                          
                        ),
                      ),

                      SizedBox(width: 35,)
                    ],
                  ),
                  SizedBox(height: 5,),

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
                                
                      Text
                      (
                        'Type',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith
                        (color: Theme.of(context).colorScheme.primary),
                      ),
                      SizedBox(width: 10,),
                    ],
                  ),

                  Row
                  (
                    children: 
                    [
                      SizedBox(width: 20,),
                      SizedBox
                      (
                        width: 5, height: 23,
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
                                contentPadding: EdgeInsets.all(2),
                                enabledBorder: OutlineInputBorder
                                (
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide
                                  (
                                    width: 2,
                                    color: Theme.of(context).colorScheme.onSurface
                                  )
                                ),
                                hintText: 'Enter a New Type',
                                hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith
                                (
                                  color: Theme.of(context).colorScheme.onSurface
                                )
                              )
                            ),
                          
                        ),
                      ),

                      SizedBox(width: 35,)
                    ],
                  ),
                  SizedBox(height: 8,),

                  Expanded
                  (
                    child:Row
                    (
                      children: 
                      [
                        SizedBox(width: 105,),
                        GestureDetector
                        (
                          onTap: () 
                          {
                            context.read<GrpDataProvider>().deleteCard(widget.index);
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset('assets/ui/button_delete.svg')),
                        SizedBox(width: 5,),
                        GestureDetector
                        (
                          onTap: ()
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
                          child: SvgPicture.asset('assets/ui/button_save.svg')
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            ),

            Positioned
            (
              top: 33,
              right: 9,
              child: GestureDetector
              (
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset
                ('assets/ui/button_close.svg', height: 25,)
              )
            )
          ],
        ),
      ),
    );
    // return AlertDialog
    // (
    //   title: Text
    //   (
    //     'Editing ${widget.edittingCard.title}',
    //     style: Theme.of(context).textTheme.titleMedium?.copyWith
    //     (
    //       color: Theme.of(context).colorScheme.primary
    //     ),
    //   ),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    //   content: Column
    //   (
    //     mainAxisSize: MainAxisSize.min,
    //     children: 
    //     [
    //       TextField
    //       (
    //         controller: titleController,
    //         style: Theme.of(context).textTheme.displaySmall,
    //         decoration: InputDecoration
    //         (
    //           border: InputBorder.none,
    //           hintText: 'Enter a New Title',
    //           hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith
    //           (
    //             color: Theme.of(context).colorScheme.onSurface
    //           )
    //         )
    //       ),

    //       TextField
    //       (
    //         controller: typeController,
    //         style: Theme.of(context).textTheme.displaySmall,
    //         decoration: InputDecoration
    //         (
    //           border: InputBorder.none,
    //           hintText: 'Enter a New Type',
    //           hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith
    //           (
    //             color: Theme.of(context).colorScheme.onSurface
    //           )
    //         )
    //       )
    //     ],
    //   ),

    //   actions: 
    //   [
    //     TextButton
    //     (
    //       child: Text('Delete'),
    //       onPressed: () 
    //       {
    //         context.read<GrpDataProvider>().deleteCard(widget.index);
    //         Navigator.pop(context);
    //       }, 
    //     ),

    //     TextButton
    //     (
    //       child: Text('Save'),
    //       onPressed: () 
    //       {
    //         context.read<GrpDataProvider>().updateCard
    //         (
    //           widget.index, 
    //           GrpCardData
    //           (
    //             title: titleController.text, 
    //             type: typeController.text, 
    //           )
    //         );
    //         Navigator.pop(context);
    //       },
    //     ),

    //     TextButton
    //     (
    //       child: Text('Cancel'),
    //       onPressed: () => Navigator.pop(context), 
    //     )
    //   ],
    // );
  }
}