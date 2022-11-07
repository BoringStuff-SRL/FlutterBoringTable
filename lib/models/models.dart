import 'package:flutter/material.dart';

abstract class BoringTableRowElement {
  List<Widget> toTableRow();
}

class TableHeaderElement {
  final String label;
  final int flex;
  final TextAlign alignment;
  TableHeaderElement({
    required this.label,
    this.flex = 1,
    this.alignment = TextAlign.start,
  });
}
