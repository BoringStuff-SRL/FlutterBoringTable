import 'dart:math';

import 'package:boring_table/models/models.dart';
import 'package:boring_table/src/boring_table_decoration.dart';
import 'package:boring_table/src/boring_table_title.dart';
import 'package:boring_table/src/filters/boring_filter.dart';
import 'package:boring_table/src/filters/boring_filter_table_body.dart';
import 'package:boring_table/src/filters/boring_filter_table_header.dart';
import 'package:boring_table/src/filters/dialog/boring_filter_column_dialog.dart';
import 'package:boring_table/src/filters/dialog/boring_filter_dialog.dart';
import 'package:boring_table/utils/close_button.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'boring_filter_row_action.dart';
import 'decoration/boring_filter_column_style.dart';
import 'decoration/boring_filter_style.dart';

class BoringFilterTable<T> extends StatefulWidget {
  const BoringFilterTable(
      {super.key,
      this.onTap,
      this.title,
      required this.filterStyle,
      required this.filterColumnStyle,
      this.minWidth,
      this.decoration,
      this.filters = const [],
      required this.headerRow,
      required this.toTableRow,
      required this.rawItems,
      this.widgetWhenEmpty,
      this.rowActionsColumnLabel,
      this.borderRadius,
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
  final double? borderRadius;
  final BoringTableDecoration? decoration;
  final Widget? footer;
  final bool groupActions;
  final TextStyle? actionGroupTextStyle;
  final Widget groupActionsWidget;
  final double? groupActionsMenuShape;
  final List<BoringFilter<T>>? filters;
  final List<T>? rawItems;
  final BoringFilterStyle filterStyle;
  final BoringFilterColumnStyle filterColumnStyle;
  final List<Widget> Function(T element)? toTableRow;

  @override
  State<BoringFilterTable<T>> createState() => _BoringFilterTableState<T>();
}

class _BoringFilterTableState<T> extends State<BoringFilterTable<T>> {
  final controller = ScrollController();
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _first;
  late ScrollController _second;

  final ValueNotifier<int> _rowCount = ValueNotifier(0);
  final List<ValueNotifier<bool>> _isSelected = [];
  final List<ValueNotifier<bool>> _isSelectedOrder = [];
  final List<T> _orderItems = [];
  late List<Widget> Function(BuildContext context, int index) _rowBuilder;
  late List<T> filteredItems;
  final Map<TableHeaderElement, bool> _buildHeaderList = {};

  double get minWidth => widget.minWidth ?? widget.headerRow.length * 200.0;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _first = _controllers.addAndGet();
    _second = _controllers.addAndGet();

    for (var e in widget.headerRow) {
      _buildHeaderList.addEntries({e: true}.entries);
      _isSelected.add(ValueNotifier(false));
      _isSelectedOrder.add(ValueNotifier(false));
    }
    setBuilder();
  }

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  void setBuilder({bool buildHeader = false}) {
    filteredItems = [];

    for (T item in _orderItems.isEmpty ? widget.rawItems! : _orderItems) {
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

    if (_rowCount.value != filteredItems.length) {
      _rowCount.value = filteredItems.length;
      _rowBuilder =
          (context, index) => widget.toTableRow!(filteredItems[index]);
    } else if (buildHeader) {
      _rowCount.notifyListeners();
    } else if (_orderItems.isNotEmpty) {
      _rowBuilder =
          (context, index) => widget.toTableRow!(filteredItems[index]);
      _rowCount.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.cardElevation ?? 38,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = max(constraints.maxWidth, minWidth);
          return ValueListenableBuilder(
            valueListenable: _rowCount,
            builder: (BuildContext context, int value, Widget? child) {
              return Column(
                children: [
                  _tableTitle(),
                  _header(maxWidth),
                  Expanded(
                    child: (value == 0 && widget.widgetWhenEmpty != null)
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
                                  onTap: widget.onTap,
                                  maxWidth: maxWidth,
                                  rawItems: filteredItems,
                                  rowBuilder: _rowBuilder,
                                  headerRow: _buildHeaderList,
                                  groupActionsMenuShape:
                                      widget.groupActionsMenuShape,
                                  rowCount: value,
                                  groupActions: widget.groupActions,
                                  actionGroupTextStyle:
                                      widget.actionGroupTextStyle,
                                  rowActions: widget.rowActions,
                                )),
                          ),
                  ),
                  _footer()
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _header(double maxWidth) {
    return SingleChildScrollView(
      controller: _first,
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: BoringFilterTableHeader(
            decoration: widget.decoration,
            orderItems: _orderItems,
            isSelected: _isSelected,
            isSelectedOrder: _isSelectedOrder,
            rowHeader: _buildHeaderList,
            rowActionsColumnLabel: widget.rowActionsColumnLabel ?? "",
            groupActions: widget.groupActions,
            rowActions: widget.rowActions,
            rawItems: filteredItems,
            setBuilder: setBuilder),
      ),
    );
  }

  Widget _tableTitle() {
    return widget.title != null
        ? Row(
            children: [
              if ((widget.decoration?.showColumnFilter ?? true))
                Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: _filterColumnWidget()),
              Expanded(child: widget.title!),
              if (widget.filters != null &&
                  widget.filters!.isNotEmpty &&
                  (widget.decoration?.showSearchFiler ?? true))
                _filterRowWidget(),
              const SizedBox(
                width: 20,
              ),
            ],
          )
        : Container();
  }

  Widget _filterColumnWidget() {
    return UniBouncingButton(
        onPressed: () {
          BoringFilterColumnDialog.showColumnDialog(context,
              headerRow: _buildHeaderList,
              setBuilder: () => setBuilder(buildHeader: true),
              style: widget.filterColumnStyle);
        },
        child: widget.filterColumnStyle.filterIcon ??
            const Icon(Icons.filter_alt_sharp));
  }

  Widget _filterRowWidget() {
    return UniBouncingButton(
      onPressed: () {
        BoringFilterDialog.showFiltersDialog(context,
            filters: widget.filters!,
            setBuilder: () => setBuilder(),
            style: widget.filterStyle);
      },
      child: widget.filterStyle.openFiltersDialogWidget ??
          const Icon(Icons.filter_alt_sharp),
    );
  }

  Widget _footer() => Column(
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
