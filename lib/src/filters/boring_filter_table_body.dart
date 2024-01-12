import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  final Map<TableHeaderElement, bool> headerRow;
  final int rowCount;
  final void Function(T)? onTap;
  final List<BoringFilterRowAction<T>> rowActions;
  final bool dense;
  final BoringTableDecoration? decoration;
  final bool groupActions;
  final TextStyle? actionGroupTextStyle;
  final Widget groupActionsWidget;
  final double? groupActionsMenuShape;

  List<Widget> buildRow(BuildContext context, int index) {
    return rowBuilder(context, index)
        .asMap()
        .entries
        .map((item) => canBuildColumn(item.key)
            ? Expanded(flex: getColumnById(item.key).flex, child: item.value)
            : Container())
        .toList();
  }

  bool canBuildColumn(int index) {
    int x = 0;
    bool flag = true;
    headerRow.forEach((key, value) {
      if (x == index) {
        flag = value;
      }
      x++;
    });

    return flag;
  }

  TableHeaderElement getColumnById(int index) {
    int x = 0;
    TableHeaderElement column = TableHeaderElement(
        label: '', tableHeaderDecoration: TableHeaderDecoration());

    headerRow.forEach((key, value) {
      if (x == index) {
        column = key;
      }
      x++;
    });
    return column;
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
          prototypeItem: decoration?.prototypeItem ?? true
              ? (rowCount > 0 ? itemAtPosition(context, 0) : null)
              : null,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: rowCount,
          itemBuilder: ((context, index) {
            int count = -1;

            return Slidable(
              key: ValueKey(index),
              enabled: decoration?.enableSlideRow ?? true,
              startActionPane: rowActions.isNotEmpty
                  ? ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.35,
                      children: rowActions.map((e) {
                        count++;
                        return SlidableAction(
                            foregroundColor: Colors.white,
                            onPressed: (c) => e.onTap.call(rawItems[index]),
                            autoClose: true,
                            backgroundColor: count % 2 == 0
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(200)
                                : Theme.of(context).colorScheme.primary,
                            label: e.buttonText,
                            icon: e.icon?.icon);
                      }).toList())
                  : null,
              child: Container(
                  color: index.isEven
                      ? decoration?.evenRowColor
                      : decoration?.oddRowColor,
                  child: (itemAtPosition(context, index))),
            );
          }),
        ));
  }

  Widget _buildActionsGroup(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PopupMenuButton(
        splashRadius: 20,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(groupActionsMenuShape ?? 15))),
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
                        if (e.value.icon != null) e.value.icon!,
                        if (e.value.icon != null)
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
                    rowActions.isNotEmpty
                        ? groupActions
                            ? _buildActionsGroup(context, index)
                            : additionalActionsRow(context, rawItems[index])
                        : Container(),
                  ],
                ),
              ),
              if ((decoration?.showDivider ?? false) &&
                  decoration?.evenRowColor == null &&
                  decoration?.oddRowColor == null)
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
