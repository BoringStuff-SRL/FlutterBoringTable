import 'package:boring_table/models/models.dart';
import 'package:boring_table/src/boring_row_action.dart';

import 'package:flutter/material.dart';

import 'boring_table_decoration.dart';

class BoringTableBody extends StatelessWidget {
  const BoringTableBody(
      {super.key,
      this.onTap,
      required this.maxWidth,
      required this.rowBuilder,
      required this.headerRow,
      required this.rowCount,
      this.decoration,
      this.dense = false,
      this.rowActions = const []});

  final double maxWidth;
  final List<Widget> Function(BuildContext context, int index) rowBuilder;
  final List<TableHeaderElement> headerRow;
  final int rowCount;
  final void Function(int)? onTap;
  final List<BoringRowAction> rowActions;
  final bool dense;
  final BoringTableDecoration? decoration;

  List<Widget> buildRow(BuildContext context, int index) =>
      rowBuilder(context, index)
          .asMap()
          .entries
          .map(
            (item) =>
                Expanded(flex: headerRow[item.key].flex, child: item.value),
          )
          .toList();

  Widget additionalActionsRow(BuildContext context, int index) =>
      rowActions.length > 1
          ? PopupMenuButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              itemBuilder: (context) {
                return rowActions
                    .asMap()
                    .entries
                    .map((e) => PopupMenuItem(
                          onTap: () => e.value.onTap,
                          child: Row(
                            children: [
                              if (e.value.icon != null) e.value.icon!,
                              const SizedBox(
                                width: 10,
                              ),
                              if (e.value.buttonText != null)
                                Text(e.value.buttonText!),
                            ],
                          ),
                        ))
                    .toList();
              },
              child: rowActions.elementAt(0).popMenuIcon,
            )
          : Row(
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
        prototypeItem: rowCount > 0 ? itemAtPosition(context, 0) : null,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: rowCount,
        itemBuilder: ((context, index) {
          return (itemAtPosition(context, index));
        }),
      ),
    );
  }

  Widget itemAtPosition(BuildContext context, int index) {
    final tx = Theme.of(context);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        InkWell(
          hoverColor:
              decoration?.rowHoverColor ?? tx.primaryColor.withOpacity(0.2),
          splashColor:
              decoration?.rowSplashColor ?? tx.primaryColor.withOpacity(0.1),
          highlightColor:
              decoration?.rowHighlightColor ?? tx.primaryColor.withOpacity(0.1),
          onTap: () => onTap?.call(index),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: decoration?.rowPadding ??
                    EdgeInsets.symmetric(
                        horizontal: 35.0, vertical: dense ? 30 : 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...buildRow(context, index),
                    additionalActionsRow(context, index),
                  ],
                ),
              ),
              if (decoration?.showDivider ?? false)
                Container(
                    color: decoration?.dividerColor ?? tx.dividerColor,
                    height: 0.7)
            ],
          ),
        ),
      ],
    );
  }
}
