import 'package:flutter/material.dart';

enum TrimMetrics
{
  mainTypeface
  (
    trimRatio: 1, 
    elevation: 0.9
  ),
  secondaryTypeface
  (
    trimRatio: 1,
    elevation: 0.8
  );

  const TrimMetrics
  ({
    required this.trimRatio, 
    required this.elevation
  });

  final double trimRatio;
  final double elevation;
}
class TextTrimmer extends StatelessWidget 
{
  final String content; 
  final TextStyle? style; 
  final Color textColor; 
  final TrimMetrics trimMetrics; 
  final int? maxLines; 

  const TextTrimmer
  ({
    super.key,
    required this.content,
    required this.style,
    required this.textColor,
    required this.trimMetrics,
    this.maxLines
  });
  
  double _getStringWidth(String text, TextStyle? style)
  {
    final painter = TextPainter
    (
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr
    )..layout();
    return painter.width; 
  }

  @override
  Widget build(BuildContext context) 
  {
    final double fontSize = style?.fontSize ?? 20;

    return LayoutBuilder
    (
      builder: (context, constraint) 
      {
        final maxWidth = constraint.maxWidth.isFinite
        ? constraint.maxWidth
        : double.infinity;
        
        final painter = TextPainter
        (
          text: TextSpan(text: content, style: style),
          textDirection: TextDirection.ltr,
          maxLines: maxLines
        )..layout(maxWidth: maxWidth);

        final double targetHeight = fontSize * trimMetrics.trimRatio 
        * painter.computeLineMetrics().length; 

        return SizedBox
        (
          height: targetHeight,
          width: _getStringWidth(content, style),
          child: OverflowBox
          (
            maxHeight: double.infinity,
            child: Text
            (content, style: style?.copyWith
            (height: trimMetrics.elevation, color: textColor),),
          ),
        );
      }
    );
  }
}
