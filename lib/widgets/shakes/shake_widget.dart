// import 'package:flutter/material.dart';

// class ShakeWidget extends StatefulWidget {
//   final Widget child;
//   final double shakeOffset;
//   final VoidCallback onTap;

//   const ShakeWidget({
//     Key? key,
//     required this.child,
//     this.shakeOffset = 5.0,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   _ShakeWidgetState createState() => _ShakeWidgetState();
// }

// class _ShakeWidgetState extends State<ShakeWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _animation = TweenSequence<double>([
//       TweenSequenceItem(
//           tween: Tween(begin: 0, end: widget.shakeOffset), weight: 1),
//       TweenSequenceItem(
//           tween: Tween(begin: widget.shakeOffset, end: -widget.shakeOffset),
//           weight: 2),
//       TweenSequenceItem(
//           tween: Tween(begin: -widget.shakeOffset, end: widget.shakeOffset),
//           weight: 2),
//       TweenSequenceItem(
//           tween: Tween(begin: widget.shakeOffset, end: 0), weight: 1),
//     ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _shakeAnimation() {
//     _controller.forward(from: 0.0).then((_) {
//       if (mounted) _controller.reset();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         _shakeAnimation();
//         widget.onTap();
//       },
//       child: AnimatedBuilder(
//         animation: _animation,
//         builder: (context, child) {
//           return Transform.translate(
//             offset: Offset(_animation.value, 0),
//             child: child,
//           );
//         },
//         child: widget.child,
//       ),
//     );
//   }
// }
