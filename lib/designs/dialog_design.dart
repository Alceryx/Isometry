// import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isometry/data_manager.dart';

import 'package:isometry/designs/custom_transitions.dart';
import 'package:isometry/designs/text_trim.dart';
import 'package:provider/provider.dart';

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
    final double dialogWidth = 365;
    final double defaultBottomPadding = 200;
    final double keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final double bottomButtonHeight = 40; 
    return Padding
    (
      padding: EdgeInsets.only 
      (bottom: keyboardSpace + defaultBottomPadding),
      child: Center
      (
        child: SizedBox
        (
          width: dialogWidth,
          child: Stack
          (
            // alignment: AlignmentGeometry.centerStart,
            children: 
            [
              //---------
              //DIALOG BG
              //---------
              Column
              (
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: 
                [
                  SizedBox(height: 15),
                  SvgPicture.asset('assets/ui/dialog_card.svg')
                ]
              ),
          
              //------------
              //DIALOG TITLE
              //------------
          
              Positioned.fill
              (
                child: Text
                (
                  dialogTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith
                  (color: Theme.of(context).colorScheme.primary,
                  height: 1),
                ),
              ),

              //--------------
              //BOTTOM BUTTONS
              //--------------
          
              Positioned
              (
                top: 170, left: 100,
                child: Row
                (
                  children: 
                  [
                    GestureDetector
                    (
                      onTap: onLeftTap,
                      child: SizedBox
                      (
                        height: bottomButtonHeight,
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
                        ),
                      )
                    ),
                    SizedBox(width: 8,),
                              
                    GestureDetector
                    (
                      onTap: onRightTap,
                      child: SizedBox
                      (
                        height: bottomButtonHeight,
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
                        ),
                      )
                    ),
                  ],
                ),
              ),
        
              //-------------
              //DIALOG FIELDS
              //-------------
              
              Column
              (
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: 
                [
                  SizedBox(height: 55,),
        
                  firstField,
                  SizedBox(height: 10,),
                  
                  secondField,
                  SizedBox()
                ],
              ),
          
              //-------------
              //CORNER BUTTON
              //-------------
                
              Positioned
              (
                top: 23,
                right: 9,
                child: cornerButton ?? SizedBox.shrink()
              ),
            ],
          ),
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
    final double fieldHeight = 25; 
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
            SizedBox(width: 17,),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: 
          [
            SizedBox(width: 17,),
            SizedBox
            (
              width: 5, height: fieldHeight,
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
    return Material
    (
      type: MaterialType.transparency,
      child: TextField
      (
        controller: textFieldController,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: textFieldDecor(hintText, context)
      ),
    );
  }
}

//TEXTFIELD DECORATION
InputDecoration textFieldDecor(String hintText, BuildContext context) 
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

  return InputDecoration
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
  );
}

//---------------------
//DIALOG DROPDOWN FIELD
//---------------------

class DialogDropdownField extends DialogField
{
  final TagListLocal localTags; 

  const DialogDropdownField
  ({
    super.key,
    required super.fieldTitle,
    required this.localTags, 
  });

  @override
  Widget buildField(BuildContext context) 
  {
    return _TagFieldBody(localTags: localTags);
  }
}

class _TagFieldBody extends StatefulWidget 
{
  final TagListLocal localTags;

  const _TagFieldBody
  ({
    super.key,
    required this.localTags
  });

  @override
  State<_TagFieldBody> createState() => __TagFieldBodyState();
}

class __TagFieldBodyState extends State<_TagFieldBody> 
{
  final TextEditingController _tagFieldController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _expanded = false; 

  @override
  void dispose() 
  {
    _tagFieldController.dispose();
    _focusNode.dispose(); 
    super.dispose();
  }
  //------------------
  //DROPDOWN BEHAVIOUR
  //------------------

  void _expandDropdown()
  {
    setState(() => _expanded = true);
    _focusNode.requestFocus(); 
  }

  void _collapseDropdown()
  {
    setState(() => _expanded = false);
    _focusNode.unfocus(); 
  }

  //--------------
  //TAG MANAGEMENT
  //--------------

  void _submitTag(TagListGlobal globalTags, String rawTagTitle)
  {
    final String newTagTitle = rawTagTitle.trim();
    if (newTagTitle.isEmpty) return; 

    final existingMatches = globalTags.items.where
    ((tag) => tag.title == newTagTitle);

    //Add New Tag if Not Alr Existed
    final TagData tag = existingMatches.isNotEmpty 
    ? existingMatches.first
    : TagData
    (
      title: newTagTitle, 
      style: TagStyle
      (
        tagColour: Theme.of(context).colorScheme.primary, 
        isFilled: false
      )
    );

    if(existingMatches.isEmpty) globalTags.addItem(tag);

    //Assign Current Tag is not Alr Assigned
    if(!widget.localTags.items.contains(tag)) widget.localTags.addItem(tag);

    _tagFieldController.clear();
    setState(() {});
  }
  
  void _assignOrDeassign (TagData tag)
  {
    final int tagIndex = widget.localTags.items.indexOf(tag);
    final bool tagIsAssigned = tagIndex >= 0
    ? true
    : false; 

    tagIsAssigned 
    ? widget.localTags.deleteItem(tagIndex)
    : widget.localTags.addItem(tag);
  }

  void _deleteGlobalTag (TagListGlobal globalTags, TagData tag)
  {
    final int globalTagIndex = globalTags.items.indexOf(tag); 
    if (globalTagIndex >= 0) globalTags.deleteItem(globalTagIndex);

    //This only delete the tag for the current exercise, not on other ones yet
    final int localTagIndex = widget.localTags.items.indexOf(tag); 
    if (localTagIndex >= 0) widget.localTags.deleteItem(localTagIndex);
    //Cascade delete in managed in ...
  }

  Future<void> _renameTag(TagData tag) async 
  {
    final TextEditingController renameController = TextEditingController();
    final String? newTitle = await showDialog<String>
    (
      context: context,
      builder: (dialogContext) => AlertDialog
      (
        title: const Text('Rename Tag'),
        content: TextField(controller: renameController, autofocus: true),
        actions: 
        [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Cancel')),
          TextButton
          (
            onPressed: ()
            {
              Navigator.pop(dialogContext, renameController.text.trim()); 
            },
            child: Text('Save')
          )
        ],
      )
    );

    if (newTitle != null && newTitle.isNotEmpty && newTitle != tag.title) 
    {tag.edit(TagData(title: newTitle, style: tag.style));}
  }

  //STYLING

  List<TagStyle> fixedStyles(BuildContext context)
  {
    final palette = Theme.of(context).colorScheme; 
    return 
    [
      TagStyle(tagColour: palette.primary, isFilled: true),
      TagStyle(tagColour: palette.secondary, isFilled: true),
      TagStyle(tagColour: palette.primary, isFilled: false),
      TagStyle(tagColour: palette.secondary, isFilled: false),
    ];
  } 
  

  void _cycleStyle(TagData tag) 
  {
  final styles = fixedStyles(context);

  //Get the current style
  final index = styles.indexWhere
  (
    (s) => s.tagColour == tag.style.tagColour 
    && s.isFilled == tag.style.isFilled,
  );

  //Cycle thru the list; wrap around if at the end using %
  final next = (index + 1) % styles.length;
  tag.edit(TagData(title: tag.title, style: styles[next]));
}



  @override
  Widget build(BuildContext context) 
  {
    final globalTags = context.watch<TagListGlobal>();
    final String autocompleteQuery = _tagFieldController.text.trim().toLowerCase(); 

    //Autocomplete as user types
    final visibleTags = autocompleteQuery.isEmpty
    ? globalTags.items
    : globalTags.items.where((tag) => tag.title.toLowerCase().contains(autocompleteQuery)).toList();  

    return TapRegion
    (
      onTapOutside: (_) => _collapseDropdown(),
      child: ListenableBuilder
      (
        listenable: widget.localTags, 
        builder: (context, _) 
        {
          final int textFieldFlex = 3; 
          return Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: 
            [
              GestureDetector
              (
                onTap: _expandDropdown,
                child: SizedBox
                (
                  height: 25,
                  child: Row
                  (
                    children: 
                    [
                      Expanded
                      (
                        flex: textFieldFlex,
                        child: Material
                        (
                          type: MaterialType.transparency,
                          child: TextField
                          (
                            controller: _tagFieldController,
                            focusNode: _focusNode,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: textFieldDecor('SEARCH/ADD', context),
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (enteredValue) => _submitTag
                            (globalTags, enteredValue)
                          ),
                        ),
                      ),
                      const SizedBox(width: 8,),
                  
                      Expanded
                      (
                        flex: textFieldFlex + 1,
                        child: ListView.builder
                        (
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.localTags.items.length,
                          itemBuilder: (context, index) 
                          {
                            final TagData tag = widget.localTags.items.reversed.toList()[index];
                            return Padding
                            (
                              padding: const EdgeInsets.only(right: 5),
                              child: ExerciseTagDesign(tagData: tag)
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              if(_expanded)
              Container
              (
                constraints: const BoxConstraints(maxHeight: 250),
                decoration: BoxDecoration
                (
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color:Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.zero,
                ),
                child: ListView.builder
                (
                  itemCount: visibleTags.length,
                  itemBuilder: (context, index)
                  {
                    final tag = visibleTags[index]; 
                    return ChangeNotifierProvider<TagData>.value
                    (
                      value: tag,
                      child: Consumer<TagData>
                      (
                        builder: (context, tag, _)
                        {
                          final bool assigned = widget.localTags.items.contains(tag);
                          return SizedBox
                          (
                            
                            child: Row
                            (
                              children: 
                              [
                                IconButton
                                (
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _deleteGlobalTag(globalTags, tag),
                                ),
                                SizedBox(width: 5,),
                                
                                GestureDetector
                                (
                                  onTap: () => _renameTag(tag),
                                  child: ExerciseTagDesign(tagData: tag)
                                ),
                                Spacer(),

                                IconButton
                                (
                                  onPressed: () => _cycleStyle(tag), 
                                  icon: Icon(Icons.palette_outlined)
                                ),
                                IconButton  
                                (
                                  icon: Icon(assigned ? Icons.remove_circle_outline : Icons.circle),
                                  onPressed: () => _assignOrDeassign(tag)
                                ),
                                SizedBox(width: 5,)
                              ],
                            ),
                          );
                        }
                      ),
                    );
                  }
                ),
              )
            ],
          );
        }
      )
    );
  }
}

class ExerciseTagDesign extends StatelessWidget 
{
  final TagData tagData;

  const ExerciseTagDesign
  ({
    super.key,
    required this.tagData
  });

  @override
  Widget build(BuildContext context) 
  {
    return Container
    (
      alignment: Alignment.center,
      height: 22,
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration
      (
        color: tagData.style.isFilled
        ? tagData.style.tagColour
        : Color.fromARGB(0,0,0,0),
        border: Border.all
        (color:tagData.style.tagColour)
      ),
      child: TextTrimmer
      (
        content: tagData.title, 
        trimMetrics: TrimMetrics.secondaryTypeface,
        style: Theme.of(context).textTheme.bodyMedium,
        textColor: tagData.style.isFilled
        ? Theme.of(context).colorScheme.surface
        : tagData.style.tagColour,
      ),
    );
  }
}