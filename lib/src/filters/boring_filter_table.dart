import 'dart:math';

import 'package:boring_table/models/models.dart';
import 'package:boring_table/src/boring_table_decoration.dart';
import 'package:boring_table/src/boring_table_title.dart';
import 'package:boring_table/src/filters/boring_filter.dart';
import 'package:boring_table/src/filters/boring_filter_column_dialog.dart';
import 'package:boring_table/src/filters/boring_filter_dialog.dart';
import 'package:boring_table/src/filters/boring_filter_table_body.dart';
import 'package:boring_table/src/filters/boring_filter_table_header.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'boring_filter_row_action.dart';
import 'boring_filter_style.dart';

class BoringFilterTable<T> extends StatefulWidget {
  const BoringFilterTable(
      {super.key,
      this.onTap,
      this.title,
      this.filterStyle,
      this.minWidth,
      this.decoration,
      required this.filters,
      required this.headerRow,
      required this.toTableRow,
      required this.rawItems,
      this.widgetWhenEmpty,
      this.rowActionsColumnLabel,
      this.shape,
      this.footer,
      this.cardElevation,
      this.groupActionsMenuShape,
      this.actionGroupTextStyle,
      this.groupActions = false,
      this.groupActionsWidget = const Icon(Icons.more_vert),
      this.rowActions = const []});

  final List<TableHeaderElement> headerRow;
  final void Function(T)? onTap;
  final BoringTableTitle? title;
  final double? minWidth;
  final String? rowActionsColumnLabel;
  final List<BoringFilterRowAction<T>> rowActions;
  final Widget? widgetWhenEmpty;
  final double? cardElevation;
  final ShapeBorder? shape;
  final BoringTableDecoration? decoration;
  final Widget? footer;
  final bool groupActions;
  final TextStyle? actionGroupTextStyle;
  final Widget groupActionsWidget;
  final ShapeBorder? groupActionsMenuShape;
  final List<BoringFilter<T>>? filters;
  final List<T>? rawItems;
  final BoringFilterStyle? filterStyle;
  final List<Widget> Function(T element)? toTableRow;

  //TODO final String? subtitle;

  @override
  State<BoringFilterTable<T>> createState() => _BoringFilterTableState<T>();
}

class _BoringFilterTableState<T> extends State<BoringFilterTable<T>> {
  final controller = ScrollController();
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _first;
  late ScrollController _second;

  late int _rowCount = 0;
  late List<Widget> Function(BuildContext context, int index) _rowBuilder;
  late List<T> filteredItems;

  double get minWidth => widget.minWidth ?? widget.headerRow.length * 200.0;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _first = _controllers.addAndGet();
    _second = _controllers.addAndGet();

    for (var e in widget.headerRow) {
      _buildHeaderList.value.addEntries({e: true}.entries);
    }

    setBuilder();
  }

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  void setBuilder() {
    filteredItems = [];
    for (T item in widget.rawItems!) {
      bool isAcceptable = true;
      for (BoringFilter<T> filter in widget.filters!) {
        if (!filter.where(item, filter.valueController)) {
          isAcceptable = false;
          break;
        }
      }
      if (isAcceptable) {
        filteredItems.add(item);
      }
    }
    _rowCount = (filteredItems.length);

    _rowBuilder = (context, index) => widget.toTableRow!(filteredItems[index]);
  }

  final ValueNotifier<Map<TableHeaderElement, bool>> _buildHeaderList =
      ValueNotifier({});

  @override
  void didUpdateWidget(covariant BoringFilterTable<T> oldWidget) {
    print("boring table has updated");
    setBuilder();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = max(
        constraints.maxWidth,
        minWidth,
      );
      return Card(
        elevation: widget.cardElevation ?? 38,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        shape: widget.shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
        child: Column(
          children: [
            widget.title != null
                ? widget.filters != null
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                  onTap: () {
                                    BoringFilterColumnDialog.showColumnDialog(
                                      context,
                                      headerRow: _buildHeaderList.value,
                                      setBuilder: () {
                                        setState(() {
                                          setBuilder();
                                        });
                                      },
                                      style: widget.filterStyle,
                                    );
                                  },
                                  child: const Icon(Icons.add))),
                          Expanded(
                            child: widget.title!,
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                BoringFilterDialog.showFiltersDialog(
                                  context,
                                  filters: widget.filters!,
                                  setBuilder: () {
                                    setState(() {
                                      setBuilder();
                                    });
                                  },
                                  style: widget.filterStyle,
                                );
                              },
                              child:
                                  widget.filterStyle?.openFiltersDialogWidget ??
                                      const Icon(Icons.filter_alt_sharp),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      )
                    : widget.title!
                : Container(),
            header(maxWidth),
            Expanded(
              child: (_rowCount == 0 && widget.widgetWhenEmpty != null)
                  ? Center(child: widget.widgetWhenEmpty!)
                  : Scrollbar(
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      controller: _second,
                      child: SingleChildScrollView(
                          controller: _second,
                          scrollDirection: Axis.horizontal,
                          child: BoringFilterTableBody<T>(
                            groupActionsWidget: widget.groupActionsWidget,
                            decoration: widget.decoration,
                            onTap: (widget.onTap as void Function(T)),
                            maxWidth: maxWidth,
                            rawItems: filteredItems,
                            rowBuilder: _rowBuilder,
                            headerRow: _buildHeaderList.value,
                            groupActionsMenuShape: widget.groupActionsMenuShape,
                            rowCount: _rowCount,
                            groupActions: widget.groupActions,
                            actionGroupTextStyle: widget.actionGroupTextStyle,
                            rowActions: widget.rowActions,
                          )),
                    ),
            ),
            footer()
          ],
        ),
      );
    });
  }

  Widget header(double maxWidth) {
    return SingleChildScrollView(
      controller: _first,
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: BoringFilterTableHeader(
          decoration: widget.decoration,
          rowHeader: _buildHeaderList.value,
          rowActionsColumnLabel: widget.rowActionsColumnLabel ?? "",
          groupActions: widget.groupActions,
          rowActions: widget.rowActions,
          rawItems: filteredItems,
        ),
      ),
    );
  }

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
