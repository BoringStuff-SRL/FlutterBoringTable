import 'dart:math';
import 'package:boring_table/models/models.dart';
import 'package:boring_table/src/boring_row_action.dart';
import 'package:boring_table/src/boring_table_body.dart';
import 'package:boring_table/src/boring_table_header.dart';
import 'package:boring_table/src/boring_table_title.dart';
import 'package:boring_table/src/sliver_persistent_row.dart';

import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class BoringTable extends StatefulWidget {
  const BoringTable(
      {super.key,
      this.onTap,
      this.title,
      this.minWidth,
      required this.headerRow,
      required this.rowBuilder,
      required this.rowCount,
      this.widgetWhenEmpty,
      this.rowActionsColumnLabel,
      this.rowActions = const []});

  factory BoringTable.fromList(
      {required List<TableHeaderElement> headerRow,
      required List<BoringTableRowElement> items,
      Widget? widgetWhenEmpty,
      BoringTableTitle? title,
      double? minWidth,
      List<BoringRowAction>? rowActions,
      String? rowActionsColumnLabel,
      void Function(int)? onTap}) {
    return BoringTable(
      headerRow: headerRow,
      rowBuilder: (context, index) => items[index].toTableRow(),
      rowCount: items.length,
      onTap: onTap,
      widgetWhenEmpty: widgetWhenEmpty,
      rowActionsColumnLabel: rowActionsColumnLabel,
      rowActions: rowActions ?? [],
      title: title,
      minWidth: minWidth,
    );
  }

  final List<TableHeaderElement> headerRow;
  final List<Widget> Function(BuildContext context, int index) rowBuilder;
  final int rowCount;
  final void Function(int)? onTap;
  final BoringTableTitle? title;
  final double? minWidth;
  final String? rowActionsColumnLabel;
  final List<BoringRowAction> rowActions;
  final Widget? widgetWhenEmpty;
  //TODO final String? subtitle;
  //TODO final Widget footer;

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
        elevation: 8,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            if (widget.title != null) widget.title!,
            header(maxWidth),
            Expanded(
              child: (widget.rowCount == 0 && widget.widgetWhenEmpty != null)
                  ? widget.widgetWhenEmpty!
                  : Scrollbar(
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      controller: _second,
                      child: SingleChildScrollView(
                        controller: _second,
                        scrollDirection: Axis.horizontal,
                        child: BoringTableBody(
                          onTap: widget.onTap,
                          maxWidth: maxWidth,
                          rowBuilder: widget.rowBuilder,
                          headerRow: widget.headerRow,
                          rowCount: widget.rowCount,
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
            rowHeader: widget.headerRow,
            rowActionsColumnLabel: widget.rowActionsColumnLabel ?? "",
            rowActions: widget.rowActions,
          ),
        ),
      );

  Widget footer() => const Padding(padding: EdgeInsets.all(16.0));
}
