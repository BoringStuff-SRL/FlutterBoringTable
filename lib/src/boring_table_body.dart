import 'package:boring_table/models/models.dart';
import 'package:boring_table/src/boring_row_action.dart';
import 'package:flutter/material.dart';

class BoringTableBody extends StatelessWidget {
  const BoringTableBody(
      {super.key,
      this.onTap,
      required this.maxWidth,
      required this.rowBuilder,
      required this.headerRow,
      required this.rowCount,
      this.dense = false,
      this.rowActions = const []});

  final double maxWidth;
  final List<Widget> Function(BuildContext context, int index) rowBuilder;
  final List<TableHeaderElement> headerRow;
  final int rowCount;
  final void Function(int)? onTap;
  final List<BoringRowAction> rowActions;
  final bool dense;

  List<Widget> buildRow(BuildContext context, int index) =>
      rowBuilder(context, index)
          .asMap()
          .entries
          .map(
            (item) =>
                Expanded(flex: headerRow[item.key].flex, child: item.value),
          )
          .toList();

  Widget additionalActionsRow(BuildContext context, int index) => Row(
        mainAxisSize: MainAxisSize.min,
        children: rowActions
            .asMap()
            .entries
            .map((e) => e.value.build(context, index))
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: ListView.builder(
        prototypeItem: itemAtPosition(context, 0),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: rowCount,
        itemBuilder: ((context, index) {
          return (itemAtPosition(context, index));
        }),
      ),
    );
  }

  Widget itemAtPosition(BuildContext context, int index) => InkWell(
        hoverColor: Theme.of(context).primaryColor.withOpacity(0.2),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
        onTap: () => onTap?.call(index),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 35.0, vertical: dense ? 0 : 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...buildRow(context, index),
              additionalActionsRow(context, index)
            ],
          ),
        ),
      );
}
