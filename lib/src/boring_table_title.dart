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
        child: LayoutBuilder(
          builder: (context, _) {
            final width = MediaQuery.of(context).size.width;

            return Row(
              children: <Widget>[
                if (width > 750) Expanded(child: title),
                if (width > 950) const Spacer(),
                ...actions
              ],
            );
          },
        ));
  }
}
