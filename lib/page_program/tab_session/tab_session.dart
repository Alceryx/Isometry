import 'package:flutter/material.dart';
import 'package:isometry/data_manager.dart';
import 'package:isometry/designs/page_elements.dart';
import 'package:provider/provider.dart';

class SessionTab extends StatefulWidget 
{
  const SessionTab({super.key});

  @override
  State<SessionTab> createState() => _SessionTabState();
}

class _SessionTabState extends State<SessionTab> 
{
  @override
  Widget build(BuildContext context) 
  {
    final sessionList = context.watch<SessionList>(); 

    return Scaffold
    (
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SafeArea
      (
        
        child: Padding
        (
          padding: const EdgeInsets.only
          (bottom: 20, top: 10, left: 20, right: 20),
          child: Column
          (
            children: 
            [
              PageHeader
              (
                pageTitle: 'PROGRAM',
                tabTitle: 'SESSION',
                backButton: PageBackButton
                (
                  onBacktap: () 
                  {
                    Navigator.of(context).pop(context);
                  }
                ),
                onNextTap: () 
                {
                  
                },
              ),
              SizedBox(height: 10,),

              PageSearchBar(toolHeight: 33,),
              SizedBox(height: 10,),
              
              PageListViewer
              (
                listViewer: ListView.builder
                (
                  itemCount: sessionList.items.length + 1,
                  itemBuilder: (context, index) 
                  {
                    if (index < sessionList.items.length)
                    {
                      return ChangeNotifierProvider.value
                      (
                        value: sessionList.items[index],
                        child: Padding
                        (
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: SessionCardDesign
                          (
                            onCardTap: () {},
                            onOptionTap: () 
                            {
                              print('object');
                              showDialog
                              (
                                context: context, 
                                builder: (context)
                                {
                                  final TextEditingController editController = TextEditingController();
                                  editController.text = sessionList.items[index].title; 
                                  return ChangeNotifierProvider.value
                                  (
                                    value: context.read<SessionList>().items[index],
                                    child: AlertDialog
                                    (
                                      title: Text('Editing'),
                                      content: TextField
                                      (
                                        decoration: InputDecoration
                                        (
                                          hintText: 'New title'
                                        ),
                                        controller: editController,
                                      ),
                                      actions: 
                                      [
                                        TextButton
                                        (
                                          onPressed: () 
                                          {
                                            sessionList.items[index].edit(SessionData
                                            (title: editController.text, isScheduled: sessionList.items[index].isScheduled, blockList: sessionList.items[index].blockList));
                      
                                            Navigator.pop(context);
                                          }, 
                                          child: Text('Save')
                                        ),
                                        TextButton
                                        (
                                          onPressed: () => Navigator.pop(context), 
                                          child: Text('Cancel')
                                        )
                                      ],
                                    ),
                                  );
                                }
                              );
                            }, 
                          ),
                        ),
                      );
                    }
                    else 
                    {
                      return TextButton
                      (
                        onPressed: () => sessionList.addItem
                        (
                          SessionData
                          (
                            title: 'New Session', 
                            isScheduled: false, 
                            blockList: BlockList()
                          )
                        ), 
                        child: Text('Add Session')
                      );
                    }
                  }
                )
              )
            ]
          ),
        )
      ),
    );
  }
}

class SessionCardDesign extends StatelessWidget 
{
  const SessionCardDesign
  ({
    super.key,
    required this.onOptionTap,
    required this.onCardTap
  });

  final VoidCallback? onOptionTap;
  final VoidCallback? onCardTap; 

  @override
  Widget build(BuildContext context) 
  {
    final sessionData = context.watch<SessionData>(); 

    return GestureDetector
    (
      onTap: onCardTap,
      child: Row
      (
        children: 
        [
          Text(sessionData.title),
          Spacer(),
          TextButton
          (
            onPressed: onOptionTap,
            child: Text('Edit')
          )
        ],
      ),
    );
  }
}