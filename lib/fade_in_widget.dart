import 'package:flutter/material.dart';

class FadeInWidget extends StatefulWidget {
  const FadeInWidget({
    super.key,
    required bool shouldAnimate,
    required Duration duration,
    required Curve curve,
    required Widget child,
  })  : _shouldAnimate = shouldAnimate,
        _duration = duration,
        _curve = curve,
        _child = child;

  final bool _shouldAnimate;
  final Duration _duration;
  final Curve _curve;
  final Widget _child;

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    if (widget._shouldAnimate) {
      _controller = AnimationController(
        duration: widget._duration,
        vsync: this,
      );
      _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller!,
          curve: widget._curve,
        ),
      );
      _controller!.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget._shouldAnimate) {
      return widget._child;
    }
    return FadeTransition(
      opacity: _animation!,
      child: widget._child,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
