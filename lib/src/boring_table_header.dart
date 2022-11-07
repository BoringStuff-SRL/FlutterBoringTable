import 'package:boring_table/boring_table.dart';
import 'package:boring_table/models/models.dart';
import 'package:flutter/material.dart';

class BoringTableHeader extends StatefulWidget {
  BoringTableHeader({
    super.key,
    required this.rowHeader,
    this.rowActions,
    required this.rowActionsColumnLabel,
  });

  final List<TableHeaderElement> rowHeader;
  final List<BoringRowAction>? rowActions;
  final String rowActionsColumnLabel;

  @override
  State<BoringTableHeader> createState() => _BoringTableHeaderState();
}

class _BoringTableHeaderState extends State<BoringTableHeader> {
  Widget additionalActionsRow(BuildContext context, int index) =>
      widget.rowActions != null
          ? Row(
              key: _headerActionsKey,
              mainAxisSize: MainAxisSize.min,
              children: widget.rowActions!
                  .asMap()
                  .entries
                  .map((e) => e.value.build(context, index))
                  .toList(),
            )
          : Container();

  final GlobalKey _headerActionsKey = GlobalKey();
  bool built = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild());
  }

  void afterBuild() {
    print("HERE");
    if (built) return;
    setState(() {
      built = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild);
    final textTheme = Theme.of(context).textTheme;
    print(_headerActionsKey.currentContext);
    return
        // Second header row
        ColoredBox(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35.0,
          vertical: 23.0,
        ),
        child: Stack(
          children: [
            Offstage(offstage: true, child: additionalActionsRow(context, 0)),
            actualRow(textTheme),
          ],
        ),
      ),
    );
  }

  Row actualRow(TextTheme textTheme) {
    return Row(children: [
      ...widget.rowHeader
          .map(
            (item) => Expanded(
                flex: item.flex,
                child: Text(
                  item.label,
                  textAlign: item.alignment,
                  style: textTheme.titleMedium!.copyWith(
                    color: Colors.grey.shade800,
                  ),
                )),
          )
          .toList(),
      SizedBox(
          width: _headerActionsKey.currentContext != null
              ? (_headerActionsKey.currentContext!.findRenderObject()
                      as RenderBox)
                  .size
                  .width
              : 0,
          child: Text(
            widget.rowActionsColumnLabel,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium!.copyWith(
              color: Colors.grey.shade800,
            ),
          ))
    ]);
  }
}
