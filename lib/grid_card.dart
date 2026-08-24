import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GrpCard extends StatelessWidget 
{
  final String title;
  final String type;  
  const GrpCard
  ({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) 
  {
    return Container
    (
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration
      (
        image: DecorationImage(image: AssetImage('assets/ui/grp_card.png'))
      ),
      child: Stack
      (
        children: 
        [
          // Positioned.fill
          // (
          //   child: SvgPicture.asset
          //   (
          //     'assets/ui/grp_card.svg', 
          //     width: cardWidth,
          //   )
          // )
        ],
      ),
    );
  }
}