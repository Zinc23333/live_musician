import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap([this.size = 4.0]) : super(key: null);
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size, width: size);
  }
}
