import 'package:boring_table/src/filters/boring_filter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../utils/close_button.dart';
import '../decoration/boring_filter_style.dart';

class BoringFilterDialog extends StatelessWidget {
  BoringFilterDialog({
    super.key,
    required this.filters,
    required this.setBuilder,
    required this.style,
  });

  final List<BoringFilter> filters;
  final VoidCallback setBuilder;
  final BoringFilterStyle? style;
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _title(context),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      insetPadding: const EdgeInsets.all(8),
      titlePadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      contentPadding: const EdgeInsets.symmetric(horizontal: 35),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      content: SizedBox(
        width: 700,
        child: Wrap(
          runAlignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: [
            ...getWidgets(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _removeAllFilters();
            Navigator.pop(context);
          },
          style: style?.removeFiltersButtonStyle,
          child: Text(style?.removeFiltersText ?? 'Remove',
              style: style?.removeFiltersTextStyle),
        ),
        const SizedBox(width: 15),
        ElevatedButton(
          onPressed: () {
            setBuilder.call();
            Navigator.pop(context);
          },
          style: style?.applyFiltersButtonStyle,
          child: Text(style?.applyFiltersText ?? 'Apply',
              style: style?.applyFiltersTextStyle),
        ),
      ],
    );
  }

  _title(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: style?.filterDialogTitleAlignment ?? Alignment.center,
              child: style?.filterDialogTitle ?? const SizedBox.shrink(),
            ),
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

  void _removeAllFilters() {
    for (var filter in filters) {
      filter.valueController.reset();
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
              return _textField(filter);
            case BoringFilterType.dropdown:
              return _dropdownSingleChoice(filter);
            case BoringFilterType.dropdownMultiChoice:
              return _dropdownMultiChoice(filter);
            case BoringFilterType.chips:
              return _chips(filter);
          }
        })
        .cast<Widget>()
        .toList();
  }

  _searchDefaultMatchFn(item, searchValue) =>
      item.value.toString().toLowerCase().contains(searchValue.toLowerCase());

  _onMenuStateChange(isOpen, searchEditController) =>
      !isOpen ? searchEditController.clear() : null;

  Widget _textField(BoringFilter filter) {
    final controller =
        TextEditingController(text: filter.valueController.value);
    return ValueListenableBuilder(
        valueListenable: filter.valueController,
        builder: (context, value, child) {
          return _wrapper(
            title: filter.title,
            child: TextField(
              decoration: style?.textInputDecoration?.copyWith(
                      hintText: filter.hintText, hintStyle: style?.hintStyle) ??
                  const InputDecoration(),
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
  }

  Widget _dropdownSingleChoice(BoringFilter filter) {
    final TextEditingController searchController = TextEditingController();
    return _wrapper(
      title: filter.title,
      child: ValueListenableBuilder(
        valueListenable: filter.valueController,
        builder: (context, value, child) {
          return DropdownButtonFormField2(
            dropdownOverButton: true,
            isExpanded: true,
            searchInnerWidgetHeight: 20,
            dropdownElevation: 0,
            decoration: style?.textInputDecoration,
            buttonHeight: 20,
            itemHeight: 50,
            focusColor: Colors.transparent,
            buttonSplashColor: Colors.transparent,
            buttonHighlightColor: Colors.transparent,
            buttonOverlayColor: MaterialStateProperty.resolveWith(
                (states) => Colors.transparent),
            dropdownMaxHeight: 250,
            searchController: searchController,
            items: (filter as BoringDropdownFilter)
                .values!
                .map((e) => DropdownMenuItem(
                    value: e,
                    child:
                        Text(filter.showingValues![filter.values!.indexOf(e)])))
                .toList(),
            hint: Text(filter.hintText, style: style?.hintStyle),
            dropdownDecoration: style?.dropdownBoxDecoration,
            onChanged: ((value) => filter.valueController.setValue(value)),
            searchInnerWidget: Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: searchController,
                decoration: style?.searchDecoration,
              ),
            ),
            searchMatchFn: (item, searchValue) =>
                (filter).searchMatchFn?.call(item, searchValue) ??
                _searchDefaultMatchFn(item, searchValue),
            onMenuStateChange: (isOpen) =>
                _onMenuStateChange(isOpen, searchController),
          );
        },
      ),
    );
  }

  Widget _dropdownMultiChoice(BoringFilter filter) {
    final TextEditingController searchController = TextEditingController();
    return _wrapper(
      title: filter.title,
      child: ValueListenableBuilder(
        valueListenable: filter.valueController,
        builder: (context, value, child) {
          return DropdownButtonFormField2(
            dropdownOverButton: false,
            isExpanded: true,
            searchInnerWidgetHeight: 20,
            dropdownElevation: 0,
            decoration: style?.textInputDecoration,
            buttonHeight: 20,
            itemHeight: 50,
            focusColor: Colors.transparent,
            value: filter.valueController.value.isNotEmpty
                ? filter.valueController.value.first
                : null,
            buttonSplashColor: Colors.transparent,
            buttonHighlightColor: Colors.transparent,
            buttonOverlayColor: MaterialStateProperty.resolveWith(
                (states) => Colors.transparent),
            dropdownMaxHeight: 250,
            searchController: searchController,
            items: (filter as BoringDropdownMultiChoiceFilter).values!.map((e) {
              return DropdownMenuItem(
                value: e,
                child: StatefulBuilder(
                  builder: (context, menuState) {
                    final isSelected =
                        (filter.valueController.value as List).contains(e);

                    return GestureDetector(
                      onTap: () {
                        if (!isSelected) {
                          (filter.valueController.value as List).add(e);
                        } else {
                          (filter.valueController.value as List).remove(e);
                        }

                        filter.valueController.sendNotification();
                        menuState(() {});
                      },
                      child: SizedBox(
                        height: double.infinity,
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              isSelected
                                  ? style?.checkIcon ?? Icon(Icons.check_box)
                                  : style?.unCheckIcon ??
                                      Icon(Icons.check_box_outline_blank),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(filter
                                    .showingValues![filter.values!.indexOf(e)]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
            hint: Text(filter.hintText, style: style?.hintStyle),
            dropdownDecoration: style?.dropdownBoxDecoration,
            onChanged: (value) {},
            selectedItemBuilder: (context) {
              return [
                Text(
                  (filter.valueController.value as List)
                      .map((e) =>
                          filter.showingValues![filter.values!.indexOf(e)])
                      .join(', '),
                ),
              ];
            },
            searchInnerWidget: Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: searchController,
                decoration: style?.searchDecoration,
              ),
            ),
            searchMatchFn: (item, searchValue) =>
                (filter as BoringDropdownMultiChoiceFilter)
                    .searchMatchFn
                    ?.call(item, searchValue) ??
                _searchDefaultMatchFn(item, searchValue),
            onMenuStateChange: (isOpen) =>
                _onMenuStateChange(isOpen, searchController),
          );
        },
      ),
    );
  }

  Widget _chips(BoringFilter filter) {
    return _wrapper(
      title: filter.title,
      child: ValueListenableBuilder(
        valueListenable: filter.valueController,
        builder: (context, value, child) {
          return ChipTheme(
            data: style?.chipThemeData ?? const ChipThemeData(),
            child: Wrap(
              spacing: style?.chipSpacing ?? 10,
              children: [
                for (dynamic value in (filter as BoringChipFilter).values)
                  _buildChip(filter, value),
              ],
            ),
          );
        },
      ),
    );
  }

  ChoiceChip _buildChip(BoringFilter filter, dynamic chipValue) {
    bool isSelected =
        (filter.valueController.value as List).contains(chipValue);
    return ChoiceChip(
      label: Text(
        (filter as BoringChipFilter)
            .showingValues[filter.values.indexOf(chipValue)],
      ),
      avatar: filter.chipIcon,
      selected: isSelected,
      onSelected: (value) {
        if (value) {
          (filter.valueController.value as List).add(chipValue);
        } else {
          (filter.valueController.value as List).remove(chipValue);
        }
        (filter.valueController.sendNotification());
      },
    );
  }
}
