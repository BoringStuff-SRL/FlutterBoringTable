import 'package:flutter/material.dart';

abstract class BoringTableRowElement {
  List<Widget> toTableRow();
}

class TableHeaderElement {
  final String label;
  final Widget? icon;
  final Widget? secondaryIcon;
  final int flex;
  final TextAlign alignment;
  final bool isSelectAll;
  final Future<void> Function(bool? value)? onPressed;

  TableHeaderElement({
    required this.label,
    this.icon,
    this.secondaryIcon,
    this.isSelectAll = false,
    this.flex = 1,
    this.onPressed,
    this.alignment = TextAlign.start,
  });

  TableHeaderElement.selectedAll({
    required this.label,
    this.icon,
    this.secondaryIcon,
    required this.onPressed,
    this.isSelectAll = true,
    this.flex = 1,
    this.alignment = TextAlign.start,
  });
}
