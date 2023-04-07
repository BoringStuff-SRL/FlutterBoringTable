import 'package:boring_table/boring_table.dart';
import 'package:boring_table/models/models.dart';
import 'package:flutter/material.dart';

import 'boring_filter_row_action.dart';

class BoringFilterTableHeader<T> extends StatefulWidget {
  const BoringFilterTableHeader(
      {super.key,
      this.decoration,
      required this.rowHeader,
      this.rowActions,
      required this.groupActions,
      required this.rowActionsColumnLabel,
      required this.rawItems});

  final List<TableHeaderElement> rowHeader;
  final List<BoringFilterRowAction>? rowActions;
  final String rowActionsColumnLabel;
  final BoringTableDecoration? decoration;
  final bool groupActions;
  final List<T> rawItems;

  @override
  State<BoringFilterTableHeader> createState() =>
      _BoringFilterTableHeaderState();
}

class _BoringFilterTableHeaderState extends State<BoringFilterTableHeader> {
  Widget additionalActionsRow(BuildContext context, int index) =>
      widget.rowActions != null
          ? Row(
              key: _headerActionsKey,
              mainAxisSize: MainAxisSize.min,
              children: widget.rowActions!
                  .asMap()
                  .entries
                  .map(
                    (e) => e.value.build(context, null),
                  )
                  .toList(),
            )
          : Container();

  final GlobalKey _headerActionsKey = GlobalKey();
  bool built = false;

  @override
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

    return
        // Second header row
        ColoredBox(
      color: widget.decoration?.headerColor ?? Theme.of(context).primaryColor,
      child: Padding(
        padding: widget.decoration?.headerPadding ??
            const EdgeInsets.symmetric(
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
                  style: widget.decoration?.headerTextStyle ??
                      textTheme.titleMedium!.copyWith(
                        color: Colors.grey.shade800,
                      ),
                )),
          )
          .toList(),
      SizedBox(
          width: _headerActionsKey.currentContext != null
              ? widget.groupActions
                  ? 85
                  : (_headerActionsKey.currentContext!.findRenderObject()
                          as RenderBox)
                      .size
                      .width
              : 0,
          child: Text(
            widget.rowActionsColumnLabel,
            textAlign: TextAlign.center,
            style: widget.decoration?.headerTextStyle ??
                textTheme.titleMedium!.copyWith(
                  color: Colors.grey.shade800,
                ),
          ))
    ]);
  }
}