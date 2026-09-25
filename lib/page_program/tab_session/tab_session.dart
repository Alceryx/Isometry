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
    final sessionData = context.watch<SessionList>(); 

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
                  itemCount: sessionData.items.length + 1,
                  itemBuilder: (context, index) 
                  {
                    if (index < sessionData.items.length)
                    {
                      return ChangeNotifierProvider.value
                      (
                        value: sessionData.items[index],
                        child: Row
                        (
                          children: 
                          [
                            Text(sessionData.items[index].title),
                            
                          ],
                        ),
                      );
                    }
                    else 
                    {
                      return TextButton
                      (
                        onPressed: () => sessionData.addItem
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