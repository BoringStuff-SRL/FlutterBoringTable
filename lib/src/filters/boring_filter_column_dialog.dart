import 'package:boring_table/src/filters/boring_filter.dart';
import 'package:boring_table/src/filters/boring_filter_style.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

class BoringFilterColumnDialog extends StatelessWidget {
  const BoringFilterColumnDialog({
    super.key,
    required this.headerRow,
    required this.setBuilder,
    required this.style,
  });

  final Map<TableHeaderElement, bool> headerRow;
  final VoidCallback setBuilder;
  final BoringFilterStyle? style;

  static void showColumnDialog(BuildContext context,
      {required Map<TableHeaderElement, bool> headerRow,
      required VoidCallback setBuilder,
      BoringFilterStyle? style}) {
    showDialog(
        context: context,
        builder: (context) {
          return BoringFilterColumnDialog(
              headerRow: headerRow, setBuilder: setBuilder, style: style);
        });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      titlePadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      contentPadding: const EdgeInsets.symmetric(horizontal: 35),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      title: const Text('_selectRow'),
      content: SizedBox(
          width: 300,
          height: 300,
          child: Column(
            children: _generateRow(),
          )),
      actions: [
        ElevatedButton(
          onPressed: () {
            setBuilder.call();
            Navigator.pop(context);
          },
          child: Text('apply'),
        ),
      ],
    );
  }

  List<Widget> _generateRow() {
    final List<Widget> list = [];
    headerRow.forEach((key, value) {
      list.add(Row(
        children: [
          Checkbox(
              value: value,
              onChanged: (v) {
                headerRow[key] = v!;
              }),
          Text(key.label),
        ],
      ));
    });
    return list;
  }

  void _removeAllFilters() {
    setBuilder.call();
  }
}
