import 'package:flutter/material.dart';

class LoadingOverlay extends StatefulWidget {
  final bool isLoading;
  final double opacity;
  final Color? color;
  final Widget progressIndicator;
  final Widget child;
  const LoadingOverlay({Key? key,
    required this.isLoading,
    required this.child,
    this.opacity = 0.5,
    this.progressIndicator = const CircularProgressIndicator(),
    this.color
  }) : super(key: key);

  @override
  _LoadingOverlayState createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool? _overlayVisible;

  _LoadingOverlayState();

  @override
  void initState() {
    super.initState();
    _overlayVisible = false;
    _animationController =  AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _animation.addStatusListener((status) {
      status == AnimationStatus.forward? setState(()=>{_overlayVisible = true}) : null;
      status == AnimationStatus.dismissed? setState(()=>{_overlayVisible = false}) : null;
    });
    if(widget.isLoading){
      _animationController.forward();
    }

  }

  @override
  void didUpdateWidget(covariant LoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(!oldWidget.isLoading && widget.isLoading){
      _animationController.forward();
    }

    if(oldWidget.isLoading && !widget.isLoading){
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widgets =<Widget>[];
    widgets.add(widget.child);

    if(_overlayVisible == true){
      final modal = FadeTransition(opacity: _animation,
        child: Stack(
          children: [
            Opacity(opacity: widget.opacity, child: ModalBarrier(
              dismissible: false,
              color: widget.color??Theme.of(context).colorScheme.background,
            ),),
            Center(
              child: widget.progressIndicator,
            )
          ],
        ),
      );
      widgets.add(modal);
    }
    return Stack(children: widgets,);
  }
}