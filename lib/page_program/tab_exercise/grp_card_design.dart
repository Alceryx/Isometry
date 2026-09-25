import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:isometry/data_manager.dart';

class GrpCardDesign extends StatelessWidget 
{
  final VoidCallback? onOptionTap;
  final VoidCallback? onCardTap;  
  // final GrpData grpData; 

  const GrpCardDesign
  ({
    super.key,
    required this.onCardTap, 
    this.onOptionTap
  });

  @override
  Widget build(BuildContext context) 
  {
    final grpData = context.watch<GrpData>(); 

    return LayoutBuilder
    (
      builder: (context, constraints) 
      {
        final cardWidth = constraints.maxWidth;
        final optionButtonWitdh = cardWidth * 0.36;

        return Column
        (
          children: 
          [
            Stack
            (
              children: 
              [
                GestureDetector
                (
                  behavior: HitTestBehavior.translucent,
                  onTap: onCardTap,
                  child: SvgPicture.asset('assets/ui/grp_card.svg')
                ),
            
                GestureDetector
                (
                  behavior: HitTestBehavior.translucent,
                  onTap: onCardTap,
                  child: Padding
                  (
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Column
                    (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: 
                      [
                        Text
                        (
                          grpData.subTitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.surface)
                        ),
                        
                        Text
                        (
                          grpData.title, style: Theme.of(context).textTheme.titleLarge?.copyWith
                          (color: Theme.of(context).colorScheme.surface)
                        )
                      ],
                    ),
                  ),
                ),
            
                Align
                (
                  alignment: const Alignment(1, 0),
                  child: GestureDetector
                  (
                    behavior: HitTestBehavior.deferToChild,
                    onTap: onOptionTap,
                    child: SvgPicture.asset
                    ('assets/ui/button_option.svg', width: optionButtonWitdh),
                  )
                )
              ],
            ),
          ],
        );
      }
    );
  }
}

class AddCard extends StatelessWidget 
{
  final VoidCallback? onCardTap;  

  const AddCard
  ({
    super.key,
    required this.onCardTap
  });

  @override
  Widget build(BuildContext context) 
  {
    return GestureDetector
    (
      behavior: HitTestBehavior.deferToChild,
      onTap: onCardTap,
      child: SvgPicture.asset('assets/ui/add_card.svg')
    );
  }
}