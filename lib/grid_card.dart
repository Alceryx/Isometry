import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GrpCard extends StatelessWidget 
{
  final String title;
  final String type;  
  final String img; 
  const GrpCard
  ({
    super.key,
    required this.title,
    required this.type, 
    required this.img
  });

  @override
  Widget build(BuildContext context) 
  {
    return Padding
    (
      padding: const EdgeInsets.only(top: 10),
      child: Stack
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
                  type, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary)
                ),
                Text
                (
                  title, style: Theme.of(context).textTheme.titleLarge?.copyWith
                  (color: Theme.of(context).colorScheme.onPrimary)
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}