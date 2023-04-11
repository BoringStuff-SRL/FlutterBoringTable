import 'package:flutter/material.dart';

class BoringTableTitle extends StatelessWidget {
  const BoringTableTitle({
    super.key,
    required this.title,
    this.actions = const [],
  });

  final Widget title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Row(
          children: <Widget>[Expanded(child: title), ...actions],
        ));
  }
}
