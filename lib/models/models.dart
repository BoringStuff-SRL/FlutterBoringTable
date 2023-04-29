import 'package:flutter/material.dart';

abstract class BoringTableRowElement {
  List<Widget> toTableRow();
}

class TableHeaderElement<T> {
  final String label;
  final Widget? icon;
  final Widget? secondaryIcon;
  final int flex;
  final TextAlign alignment;
  final bool isSelectAll;
  final Future<void> Function(bool? value)? onPressed;
  final bool showOnColumFilter;
  final Future<List<T>> Function(bool? value)? orderBy;

  TableHeaderElement({
    required this.label,
    this.icon,
    this.secondaryIcon,
    this.isSelectAll = false,
    this.showOnColumFilter = true,
    this.flex = 1,
    this.onPressed,
    this.alignment = TextAlign.start,
    this.orderBy,
  });

  TableHeaderElement.selectedAll({
    required this.label,
    this.icon,
    this.secondaryIcon,
    required this.onPressed,
    this.showOnColumFilter = true,
    this.isSelectAll = true,
    this.flex = 1,
    this.orderBy,
    this.alignment = TextAlign.start,
  });
}
