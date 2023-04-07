import 'package:boring_table/src/filters/boring_filter.dart';
import 'package:boring_table/src/filters/boring_filter_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BoringFilterDialog extends StatelessWidget {
  const BoringFilterDialog({
    super.key,
    required this.filters,
    required this.setBuilder,
    required this.style,
  });

  final List<BoringFilter> filters;
  final VoidCallback setBuilder;
  final BoringFilterStyle? style;

  static void showFiltersDialog(
    BuildContext context, {
    required List<BoringFilter> filters,
    required VoidCallback setBuilder,
    BoringFilterStyle? style,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return BoringFilterDialog(
          filters: filters,
          setBuilder: setBuilder,
          style: style,
        );
      },
    );
  }

  void _removeAllFilters() {
    for (var filter in filters) {
      filter.valueController.setValue(null);
    }
    setBuilder.call();
  }

  Widget _wrapper({required String title, required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: style?.titleStyle),
          const SizedBox(
            height: 7,
          ),
          child,
          const SizedBox(
            height: 7,
          ),
        ],
      );

  List<Widget> getWidgets() {
    return filters
        .map((filter) {
          switch (filter.type) {
            case BoringFilterType.text:
              final controller =
                  TextEditingController(text: filter.valueController.value);
              return ValueListenableBuilder(
                  valueListenable: filter.valueController,
                  builder: (context, value, child) {
                    return _wrapper(
                      title: filter.title,
                      child: TextField(
                        decoration: style?.textInputDecoration?.copyWith(
                                hintText: filter.hintText,
                                hintStyle: style?.hintStyle) ??
                            InputDecoration(),
                        controller: controller,
                        onChanged: (value) {
                          if (value == '') {
                            filter.valueController.setValue(null);
                          } else {
                            filter.valueController.setValue(value);
                          }
                        },
                      ),
                    );
                  });

            case BoringFilterType.dropdown:
              return _wrapper(
                title: filter.title,
                child: ValueListenableBuilder(
                  valueListenable: filter.valueController,
                  builder: (context, value, child) {
                    return Container(
                      decoration: style?.dropdownBoxDecoration,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.5, horizontal: 8),
                      child: DropdownButton(
                          value: value,
                          hint: Text(
                            filter.hintText,
                            style: style?.hintStyle,
                          ),
                          isExpanded: true,
                          underline: Container(),
                          items: filter.values!
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(filter.showingValues![
                                      filter.values!.indexOf(e)]),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            filter.valueController.setValue(value);
                          }),
                    );
                  },
                ),
              );
          }
        })
        .cast<Widget>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 700,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: style?.filterDialogTitleAlignment ?? Alignment.center,
              child: style?.filterDialogTitle ?? const SizedBox.shrink(),
            ),
            Wrap(
              runAlignment: WrapAlignment.center,
              spacing: 10,
              children: [
                ...getWidgets(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _removeAllFilters();
                    Navigator.pop(context);
                  },
                  style: style?.removeFiltersButtonStyle,
                  child: Text(style?.removeFiltersText ?? 'Remove filters'),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    setBuilder.call();
                    Navigator.pop(context);
                  },
                  style: style?.applyFiltersButtonStyle,
                  child: Text(style?.applyFiltersText ?? 'Apply filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}