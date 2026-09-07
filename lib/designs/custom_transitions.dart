import 'package:flutter/material.dart';

class RapidFadeAnimation extends StatefulWidget 
{
  final Widget child;
  const RapidFadeAnimation({super.key, required this.child});

  @override
  State<RapidFadeAnimation> createState() => _RapidFadeAnimationState();
}

class _RapidFadeAnimationState extends State<RapidFadeAnimation> 
with SingleTickerProviderStateMixin
{
  late AnimationController _controller;
  int _loopCount = 0; 

  @override
  void initState() 
  {
    super.initState();
    _controller = AnimationController
    (
      vsync: this, 
      duration: const Duration(milliseconds: 100)
    );

    _controller.addStatusListener((status) 
    {
      if (status == AnimationStatus.completed) 
      {
        _loopCount++;
        if (_loopCount < 4) 
        {
          _controller.forward(from: 0.0);
        }
      }
    });

    _controller.forward();
  }

  @override
  void dispose()
  {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return FadeTransition
    (
      opacity: _controller,
      child: widget.child,
    );
  }
}