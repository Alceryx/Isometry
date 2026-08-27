import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GrpCard extends StatelessWidget 
{
  final String title;
  final String type;  
  final String img; 
  final bool isAddCard; 
  final VoidCallback? onOptionTap; 
  
  const GrpCard
  ({
    super.key,
    required this.title,
    required this.type, 
    required this.img,
    required this.isAddCard,
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
                        type, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.surface)
                      ),
                      
                      Text
                      (
                        title, style: Theme.of(context).textTheme.titleLarge?.copyWith
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