import 'package:boring_table/models/models.dart';
import 'package:boring_table/src/boring_row_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../boring_table.dart';



class BoringFilterTableBody<T> extends StatelessWidget {
  const BoringFilterTableBody(
      {super.key,
      this.onTap,
      required this.maxWidth,
      required this.rowBuilder,
      required this.headerRow,
      required this.rowCount,
      required this.rawItems,
      this.groupActionsMenuShape,
      this.groupActions = false,
      this.decoration,
      this.dense = false,
      this.actionGroupTextStyle,
      required this.groupActionsWidget,
      this.rowActions = const []});

  final double maxWidth;
  final List<T> rawItems;
  final List<Widget> Function(BuildContext context, int index) rowBuilder;
  final List<TableHeaderElement> headerRow;
  final int rowCount;
  final void Function(T)? onTap;
  final List<BoringRowAction<T>> rowActions;
  final bool dense;
  final BoringTableDecoration? decoration;
  final bool groupActions;
  final TextStyle? actionGroupTextStyle;
  final Widget groupActionsWidget;
  final ShapeBorder? groupActionsMenuShape;

  List<Widget> buildRow(BuildContext context, int index) {
    return rowBuilder(context, index)
        .asMap()
        .entries
        .map(
          (item) => Expanded(flex: headerRow[item.key].flex, child: item.value),
        )
        .toList();
  }

  Widget additionalActionsRow(BuildContext context, T item) => Row(
        mainAxisSize: MainAxisSize.min,
        children: rowActions
            .asMap()
            .entries
            .map((e) => e.value.build(context, item))
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
          return Container(
              color: index.isEven
                  ? decoration?.evenRowColor
                  : decoration?.oddRowColor,
              child: (itemAtPosition(context, index)));
        }),
      ),
    );
  }

  Widget _buildActionsGroup(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PopupMenuButton(
        splashRadius: 20,
        shape: groupActionsMenuShape,
        padding: EdgeInsets.zero,
        icon: groupActionsWidget,
        itemBuilder: (context) {
          return rowActions
              .asMap()
              .entries
              .map((e) => PopupMenuItem(
                    onTap: () {
                      e.value.onTap.call(rawItems[index]);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        e.value.icon ?? Container(),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          e.value.buttonText ?? "",
                          style: actionGroupTextStyle,
                        ),
                      ],
                    ),
                  ))
              .toList();
        },
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
              decoration?.rowHoverColor ?? tx.primaryColor.withOpacity(0.15),
          splashColor:
              decoration?.rowSplashColor ?? tx.primaryColor.withOpacity(0.1),
          highlightColor:
              decoration?.rowHighlightColor ?? tx.primaryColor.withOpacity(0.1),
          onTap: () => onTap?.call(rawItems[index]),
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
                    groupActions
                        ? _buildActionsGroup(context, index)
                        : additionalActionsRow(context, rawItems[index]),
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
