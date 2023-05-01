import 'package:boring_table/boring_table.dart';
import 'package:flutter/material.dart';

class BoringFilterTableHeader<T> extends StatefulWidget {
  const BoringFilterTableHeader(
      {super.key,
      this.decoration,
      this.rowActions,
      required this.rowHeader,
      required this.orderItems,
      required this.isSelectedOrder,
      required this.setBuilder,
      required this.groupActions,
      required this.rowActionsColumnLabel,
      required this.rawItems,
      required this.isSelected});

  final Map<TableHeaderElement, bool> rowHeader;
  final List<BoringFilterRowAction>? rowActions;
  final String rowActionsColumnLabel;
  final BoringTableDecoration? decoration;
  final bool groupActions;
  final List<T> rawItems;
  final List<ValueNotifier<bool>> isSelected;
  final List<ValueNotifier<bool>> isSelectedOrder;
  final Function setBuilder;
  final List<T> orderItems;

  @override
  State<BoringFilterTableHeader> createState() =>
      _BoringFilterTableHeaderState();
}

class _BoringFilterTableHeaderState extends State<BoringFilterTableHeader> {
  final GlobalKey _headerActionsKey = GlobalKey();
  bool built = false;

  Widget additionalActionsRow(BuildContext context, int index) =>
      widget.rowActions != null
          ? Row(
              key: _headerActionsKey,
              mainAxisSize: MainAxisSize.min,
              children: widget.rowActions!
                  .asMap()
                  .entries
                  .map((e) => e.value.build(context, null))
                  .toList(),
            )
          : Container();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild());
  }

  void afterBuild() {
    if (built) return;
    if (mounted) {
      setState(() {
        built = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ColoredBox(
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
    final List<Widget> list = [];
    int count = 0;
    widget.rowHeader.forEach((key, value) {
      if (value) {
        list.add(key.isSelectAll
            ? _selectAllWidget(key, textTheme, count)
            : _standardRowWidget(key, textTheme, count));
      }
      count++;
    });

    return Row(children: [
      ...list,
      if (widget.rowActions?.isNotEmpty ?? false)
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

  Widget _selectAllWidget(
      TableHeaderElement key, TextTheme textTheme, int index) {
    return ValueListenableBuilder(
      valueListenable: widget.isSelected[index],
      builder: (BuildContext context, bool value, Widget? child) {
        return Expanded(
            flex: key.flex,
            child: Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      widget.isSelected[index].value = !value;
                      key.onPressed!.call(widget.isSelected[index].value);
                    },
                    child: !value
                        ? key.tableHeaderDecoration.unCheckIcon
                        : key.tableHeaderDecoration.checkIcon,
                  ),
                ),
                const SizedBox(width: 8),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      if (key.orderBy != null &&
                          !widget.isSelectedOrder[index].value) {
                        widget.orderItems.clear();
                        (await key.orderBy?.call())?.forEach((e) {
                          widget.orderItems.add(e);
                        });

                        widget.setBuilder.call();

                        for (int i = 0; i < widget.isSelectedOrder.length; i++) {
                          if (i != index) {
                            widget.isSelectedOrder[i].value = false;
                          } else {
                            widget.isSelectedOrder[i].value = true;
                          }
                        }
                      }
                    },
                    child: Text(
                      key.label,
                      textAlign: key.alignment,
                      style: widget.decoration?.headerTextStyle ??
                          textTheme.titleMedium!.copyWith(
                            color: Colors.grey.shade800,
                          ),
                    ),
                  ),
                ),
                if (key.orderBy != null)
                  ValueListenableBuilder(
                    valueListenable: widget.isSelectedOrder[index],
                    builder: (BuildContext context, bool value, Widget? child) {
                      return value
                          ? Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: key.tableHeaderDecoration.orderIcon)
                          : Container();
                    },
                  ),
              ],
            ));
      },
    );
  }

  Widget _standardRowWidget(
      TableHeaderElement key, TextTheme textTheme, int index) {
    return Expanded(
        flex: key.flex,
        child: MouseRegion(
          cursor: key.onPressed != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: () async {
              if (key.orderBy != null && !widget.isSelectedOrder[index].value) {
                widget.orderItems.clear();
                (await key.orderBy?.call())?.forEach((e) {
                  widget.orderItems.add(e);
                });

                widget.setBuilder.call();

                for (int i = 0; i < widget.isSelectedOrder.length; i++) {
                  if (i != index) {
                    widget.isSelectedOrder[i].value = false;
                  } else {
                    widget.isSelectedOrder[i].value = true;
                  }
                }
              }
            },
            child: Row(
              children: [
                Text(
                  key.label,
                  textAlign: key.alignment,
                  style: widget.decoration?.headerTextStyle ??
                      textTheme.titleMedium!
                          .copyWith(color: Colors.grey.shade800),
                ),
                if (key.orderBy != null)
                  ValueListenableBuilder(
                    valueListenable: widget.isSelectedOrder[index],
                    builder: (BuildContext context, bool value, Widget? child) {
                      return value
                          ? Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: key.tableHeaderDecoration.orderIcon)
                          : Container();
                    },
                  ),
              ],
            ),
          ),
        ));
  }
}
