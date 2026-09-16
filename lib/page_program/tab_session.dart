import 'package:flutter/material.dart';
import 'package:isometry/designs/page_elements.dart';

class SessionTab extends StatefulWidget 
{
  const SessionTab({super.key});

  @override
  State<SessionTab> createState() => _SessionTabState();
}

class _SessionTabState extends State<SessionTab> 
{
  @override
  Widget build(BuildContext context) {
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
                tabTitle: 'Session',
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
              )
            ]
          ),
        )
      ),
    );
  }
}