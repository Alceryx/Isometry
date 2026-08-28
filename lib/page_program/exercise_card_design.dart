import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isometry/page_program/exercise_card_data.dart';

class GrpCardDesign extends StatelessWidget 
{
  final String img; 
  final bool isAddCard; 
  final VoidCallback? onOptionTap; 
  final GrpCardData cardData; 

  const GrpCardDesign
  ({
    super.key,
    required this.img,
    required this.isAddCard,
    required this.cardData,
    this.onOptionTap
  });

  @override
  Widget build(BuildContext context) 
  {
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
                SvgPicture.asset(img),
            
                Padding
                (
                  padding: const EdgeInsets.all(6.0),
                  child: Column
                  (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: 
                    [
                      Text
                      (
                        cardData.type, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.surface)
                      ),
                      
                      Text
                      (
                        cardData.title, style: Theme.of(context).textTheme.titleLarge?.copyWith
                        (color: Theme.of(context).colorScheme.surface)
                      )
                    ],
                  ),
                ),
            
                isAddCard? SizedBox(height: 0, width: 0,)
                : Align
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