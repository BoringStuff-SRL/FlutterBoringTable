import 'package:flutter/material.dart';

abstract class BoringTableRowElement {
  List<Widget> toTableRow();
}

enum TableOrderState { asc, disc, standard }

class TableHeaderElement<T> {
  final String label;
  final int flex;
  final bool isSelectAll;
  final bool showOnColumFilter;
  final Widget? icon;
  final TextAlign alignment;
  final TableHeaderDecoration tableHeaderDecoration;
  final Future<void> Function(bool? value)? onPressed;
  final Future<List<T>> Function()? orderBy;



  TableHeaderElement({
    required this.label,
    required this.tableHeaderDecoration,
    this.icon,
    this.showOnColumFilter = true,
    this.flex = 1,
    this.onPressed,
    this.alignment = TextAlign.start,
    this.orderBy,
  }) : isSelectAll = false;

  TableHeaderElement.selectedAll({
    required this.label,
    required this.tableHeaderDecoration,
    this.icon,
    required this.onPressed,
    this.showOnColumFilter = true,
    this.flex = 1,
    this.orderBy,
    this.alignment = TextAlign.start,
  }) : isSelectAll = true;
}

class TableHeaderDecoration {
  final Widget checkIcon;
  final Widget unCheckIcon;
  final Widget orderAscIcon;
  final Widget orderDiscIcon;

  TableHeaderDecoration(
      {this.checkIcon = const Icon(Icons.check_box),
      this.unCheckIcon = const Icon(Icons.check_box_outline_blank),
      this.orderAscIcon = const Icon(Icons.arrow_drop_down),
      this.orderDiscIcon = const Icon(Icons.arrow_drop_up)});
}
