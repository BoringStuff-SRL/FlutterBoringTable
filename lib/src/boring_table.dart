import 'dart:math';

import 'package:boring_table/models/models.dart';
import 'package:boring_table/src/boring_row_action.dart';
import 'package:boring_table/src/boring_table_body.dart';
import 'package:boring_table/src/boring_table_decoration.dart';
import 'package:boring_table/src/boring_table_header.dart';
import 'package:boring_table/src/boring_table_title.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class BoringTable extends StatefulWidget {
  const BoringTable(
      {super.key,
      this.onTap,
      this.title,
      this.minWidth,
      this.decoration,
      required this.headerRow,
      required this.rowBuilder,
      required this.rowCount,
      this.widgetWhenEmpty,
      this.footer,
      this.rowActionsColumnLabel,
      this.borderRadius,
      this.groupActionsMenuShape,
      this.cardElevation,
      this.actionGroupTextStyle,
      this.groupActions = false,
      this.groupActionsWidget = const Icon(Icons.more_vert),
      this.rowActions = const []});

  BoringTable.fromList(
      {super.key,
      this.onTap,
      this.title,
      this.minWidth,
      this.decoration,
      required this.headerRow,
      required List<BoringTableRowElement> items,
      this.widgetWhenEmpty,
      this.rowActionsColumnLabel,
      this.borderRadius,
      this.footer,
      this.cardElevation,
      this.groupActionsMenuShape,
      this.actionGroupTextStyle,
      this.groupActions = false,
      this.groupActionsWidget = const Icon(Icons.more_vert),
      this.rowActions = const []})
      : rowBuilder = ((context, index) => items[index].toTableRow()),
        rowCount = items.length;

  final List<TableHeaderElement> headerRow;
  final List<Widget> Function(BuildContext context, int index) rowBuilder;
  final int rowCount;
  final void Function(int)? onTap;
  final BoringTableTitle? title;
  final double? minWidth;
  final String? rowActionsColumnLabel;
  final List<BoringRowAction> rowActions;
  final Widget? widgetWhenEmpty;
  final double? cardElevation;
  final double? borderRadius;
  final BoringTableDecoration? decoration;
  final Widget? footer;
  final bool groupActions;
  final TextStyle? actionGroupTextStyle;
  final Widget groupActionsWidget;
  final ShapeBorder? groupActionsMenuShape;

  //TODO final String? subtitle;

  @override
  State<BoringTable> createState() => _BoringTableState();
}

class _BoringTableState extends State<BoringTable> {
  final controller = ScrollController();
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _first;
  late ScrollController _second;

  double get minWidth => widget.minWidth ?? widget.headerRow.length * 200.0;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _first = _controllers.addAndGet();
    _second = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = max(
        constraints.maxWidth,
        minWidth,
      );
      return Card(
        elevation: widget.cardElevation ?? 8,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
        ),
        child: Column(
          children: [
            if (widget.title != null) widget.title!,
            header(maxWidth),
            Expanded(
              child: (widget.rowCount == 0 && widget.widgetWhenEmpty != null)
                  ? Center(child: widget.widgetWhenEmpty!)
                  : Scrollbar(
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      controller: _second,
                      child: SingleChildScrollView(
                        controller: _second,
                        scrollDirection: Axis.horizontal,
                        child: BoringTableBody(
                          groupActionsWidget: widget.groupActionsWidget,
                          decoration: widget.decoration,
                          onTap: widget.onTap,
                          maxWidth: maxWidth,
                          rowBuilder: widget.rowBuilder,
                          headerRow: widget.headerRow,
                          groupActionsMenuShape: widget.groupActionsMenuShape,
                          rowCount: widget.rowCount,
                          groupActions: widget.groupActions,
                          actionGroupTextStyle: widget.actionGroupTextStyle,
                          rowActions: widget.rowActions,
                        ),
                      ),
                    ),
            ),
            footer()
          ],
        ),
      );
    });
  }

  Widget header(double maxWidth) => SingleChildScrollView(
        controller: _first,
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: BoringTableHeader(
            decoration: widget.decoration,
            rowHeader: widget.headerRow,
            rowActionsColumnLabel: widget.rowActionsColumnLabel ?? "",
            groupActions: widget.groupActions,
            rowActions: widget.rowActions,
          ),
        ),
      );

  Widget footer() => Column(
        children: [
          Container(
              color: widget.decoration?.dividerColor ??
                  Theme.of(context).dividerColor,
              height: 0.7),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.footer ?? Container(),
          )
        ],
      );
}
