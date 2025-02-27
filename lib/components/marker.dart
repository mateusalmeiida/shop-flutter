import 'package:flutter/material.dart';

class Marker extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  const Marker({
    required this.child,
    required this.value,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
            right: 8,
            top: 4,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.secondary,
              ),
              constraints: BoxConstraints(minHeight: 14, minWidth: 14),
              child: Text(
                textAlign: TextAlign.center,
                value,
                style: TextStyle(fontSize: 10),
              ),
            ))
      ],
    );
  }
}
