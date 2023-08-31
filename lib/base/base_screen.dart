import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  State<StatefulWidget> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: widget.body,
    );
  }
}
