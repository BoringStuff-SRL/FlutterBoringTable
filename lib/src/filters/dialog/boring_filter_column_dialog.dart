import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../../utils/close_button.dart';
import '../decoration/boring_filter_column_style.dart';

class BoringFilterColumnDialog extends StatelessWidget {
  BoringFilterColumnDialog({
    super.key,
    required this.headerRow,
    required this.setBuilder,
    required this.style,
  });

  final Map<TableHeaderElement, bool> headerRow;
  final VoidCallback setBuilder;
  final BoringFilterColumnStyle? style;
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  final Map<TableHeaderElement, ValueNotifier<bool>> _tempMap = {};

  static void showColumnDialog(BuildContext context,
          {required Map<TableHeaderElement, bool> headerRow,
          required VoidCallback setBuilder,
          BoringFilterColumnStyle? style}) =>
      showDialog(
          context: context,
          builder: (context) => BoringFilterColumnDialog(
              headerRow: headerRow, setBuilder: setBuilder, style: style));

  @override
  Widget build(BuildContext context) {
    headerRow.forEach((key, value) =>
        _tempMap.addEntries({key: ValueNotifier(value)}.entries));
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      insetPadding: const EdgeInsets.all(8),
      titlePadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      contentPadding: const EdgeInsets.symmetric(horizontal: 35),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      title: _title(context),
      content: SizedBox(
          width: 300,
          height: 300,
          child: SingleChildScrollView(
            child: Column(children: _generateRow()),
          )),
      actions: [
        TextButton(
          onPressed: () {
            _removeAllFilters();
            Navigator.pop(context);
          },
          style: style?.removeFiltersButtonStyle,
          child: Text(style?.removeText ?? 'Remove',
              style: style?.removeFiltersTextStyle),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            _applyChange();
            Navigator.pop(context);
          },
          style: style?.applyFiltersButtonStyle,
          child: Text(style?.applyText ?? 'Apply',
              style: style?.applyFiltersTextStyle),
        ),
      ],
    );
  }

  _title(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: style?.title ?? const Text('Title'),
          ),
          MouseRegion(
            onEnter: (event) {
              _isHovered.value = true;
            },
            onExit: (event) {
              _isHovered.value = false;
            },
            child: UniBouncingButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: ValueListenableBuilder(
                valueListenable: _isHovered,
                builder: (BuildContext context, bool value, Widget? child) {
                  return value
                      ? style?.closeActiveIcon ?? const Icon(Icons.clear)
                      : style?.closeIcon ?? const Icon(Icons.clear);
                },
              ),
            ),
          )
        ],
      );

  List<Widget> _generateRow() {
    final List<Widget> list = [];

    _tempMap.removeWhere((key, value) => !key.showOnColumFilter);

    _tempMap.forEach((key, value) {
      list.add(MouseRegion(
        child: GestureDetector(
          onTap: () {
            if (!_tempMap[key]!.value) {
              _tempMap[key]!.value = !(_tempMap[key]!.value);
            } else if (!_isLast()) {
              _tempMap[key]!.value = !(_tempMap[key]!.value);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              children: [
                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: value,
                      builder: (BuildContext context, bool v, Widget? child) {
                        return v
                            ? style?.checkIcon ?? const Icon(Icons.check_box)
                            : style?.unCheckIcon ??
                                const Icon(
                                    Icons.check_box_outline_blank_outlined);
                      },
                    ),
                    const SizedBox(width: 10),
                    Text(key.label, style: style?.checkTextStyle)
                  ],
                ),
                const SizedBox(height: 5),
                const Divider()
              ],
            ),
          ),
        ),
      ));
    });
    return list;
  }

  bool _isLast() {
    List<bool> flag = [];

    _tempMap.forEach((key, v) {
      if (v.value) {
        flag.add(v.value);
      }
    });

    return flag.length <= 1;
  }

  void _applyChange() {
    _tempMap.forEach((k, v) => headerRow[k] = v.value);
    setBuilder.call();
  }

  void _removeAllFilters() {
    _tempMap.forEach((k, v) => headerRow[k] = true);
    setBuilder.call();
  }
}
