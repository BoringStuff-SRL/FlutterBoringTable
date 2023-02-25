import 'package:flutter/material.dart';

class BoringTableTitle extends StatelessWidget {
  const BoringTableTitle({
    super.key,
    required this.title,
    this.actions = const [],
  });

  final Widget title;
  final List<Widget> actions;
  final bool largeScreen = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 25.0),
        child: Row(
          children: <Widget>[
            if (largeScreen)
              Expanded(
                child: title,
              ),
            if (largeScreen) const Spacer(),
            ...actions
          ],
        ));
  }
}
