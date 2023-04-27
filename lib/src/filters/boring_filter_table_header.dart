import 'package:boring_table/boring_table.dart';
import 'package:boring_table/utils/close_button.dart';
import 'package:flutter/material.dart';

class BoringFilterTableHeader<T> extends StatefulWidget {
  const BoringFilterTableHeader(
      {super.key,
      this.decoration,
      required this.rowHeader,
      this.rowActions,
      required this.groupActions,
      required this.rowActionsColumnLabel,
      required this.rawItems});

  final Map<TableHeaderElement, bool> rowHeader;
  final List<BoringFilterRowAction>? rowActions;
  final String rowActionsColumnLabel;
  final BoringTableDecoration? decoration;
  final bool groupActions;
  final List<T> rawItems;

  @override
  State<BoringFilterTableHeader> createState() =>
      _BoringFilterTableHeaderState();
}

class _BoringFilterTableHeaderState extends State<BoringFilterTableHeader> {
  Widget additionalActionsRow(BuildContext context, int index) =>
      widget.rowActions != null
          ? Row(
              key: _headerActionsKey,
              mainAxisSize: MainAxisSize.min,
              children: widget.rowActions!
                  .asMap()
                  .entries
                  .map((e) => e.value.build(context, null))
                  .toList(),
            )
          : Container();

  final GlobalKey _headerActionsKey = GlobalKey();
  bool built = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild());
  }

  void afterBuild() {
    //print("HERE");
    if (built) return;
    setState(() {
      built = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild);
    final textTheme = Theme.of(context).textTheme;

    return
        // Second header row
        ColoredBox(
      color: widget.decoration?.headerColor ?? Theme.of(context).primaryColor,
      child: Padding(
        padding: widget.decoration?.headerPadding ??
            const EdgeInsets.symmetric(
              horizontal: 35.0,
              vertical: 23.0,
            ),
        child: Stack(
          children: [
            Offstage(offstage: true, child: additionalActionsRow(context, 0)),
            actualRow(textTheme),
          ],
        ),
      ),
    );
  }

  Row actualRow(TextTheme textTheme) {
    final List<Widget> list = [];
    widget.rowHeader.forEach((key, value) {
      if (value) {
        list.add(key.isSelectAll
            ? _selectAllWidget(key, textTheme)
            : _standardRowWidget(key, textTheme));
      }
    });

    return Row(children: [
      ...list,
      if (widget.rowActions?.isNotEmpty ?? false)
        SizedBox(
            width: _headerActionsKey.currentContext != null
                ? widget.groupActions
                    ? 85
                    : (_headerActionsKey.currentContext!.findRenderObject()
                            as RenderBox)
                        .size
                        .width
                : 0,
            child: Text(
              widget.rowActionsColumnLabel,
              textAlign: TextAlign.center,
              style: widget.decoration?.headerTextStyle ??
                  textTheme.titleMedium!.copyWith(
                    color: Colors.grey.shade800,
                  ),
            ))
    ]);
  }

  Widget _selectAllWidget(TableHeaderElement key, TextTheme textTheme) {
    ValueNotifier<bool> isSelected = ValueNotifier(false);
    return ValueListenableBuilder(
      valueListenable: isSelected,
      builder: (BuildContext context, bool value, Widget? child) {
        return Expanded(
            flex: key.flex,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  isSelected.value = !value;
                  key.onPressed!.call();
                },
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: !value
                            ? key.secondaryIcon ??
                                const Icon(Icons.check_box_outline_blank)
                            : key.icon ?? const Icon(Icons.check_box)),
                    Text(
                      key.label,
                      textAlign: key.alignment,
                      style: widget.decoration?.headerTextStyle ??
                          textTheme.titleMedium!.copyWith(
                            color: Colors.grey.shade800,
                          ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget _standardRowWidget(TableHeaderElement key, TextTheme textTheme) {
    return Expanded(
        flex: key.flex,
        child: MouseRegion(
          cursor: key.onPressed != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.none,
          child: GestureDetector(
            onTap: key.onPressed,
            child: Row(
              children: [
                if (key.icon != null)
                  Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: key.icon),
                Text(
                  key.label,
                  textAlign: key.alignment,
                  style: widget.decoration?.headerTextStyle ??
                      textTheme.titleMedium!.copyWith(
                        color: Colors.grey.shade800,
                      ),
                ),
              ],
            ),
          ),
        ));
  }
}
