// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class BoringFilter<T> {
  bool Function(T element, BoringFilterValueController valueController) where;
  final String title;
  final String hintText;
  final BoringFilterValueController valueController;
  final BoringFilterType _type;
  final List<dynamic>? values;
  final List<String>? showingValues;

  BoringFilterType get type => _type;

  BoringFilter({
    required this.where,
    required this.valueController,
    required this.title,
    required this.hintText,
    required BoringFilterType type,
    this.values,
    this.showingValues,
  }) : _type = type {
    if (type == BoringFilterType.dropdown) {
      assert(
          values != null &&
              values!.isNotEmpty &&
              showingValues != null &&
              showingValues!.length == values!.length,
          "Please specify some values for the dropdown filter");
    }
  }
}

class BoringTextFilter<T> extends BoringFilter<T> {
  BoringTextFilter({
    required super.where,
    required super.valueController,
    required super.title,
    required super.hintText,
  }) : super(type: BoringFilterType.text);
}

class BoringDropdownFilter<T> extends BoringFilter<T> {
  BoringDropdownFilter({
    required super.where,
    required super.valueController,
    required super.title,
    required super.hintText,
    required super.values,
    required super.showingValues,
    this.searchMatchFn,
  }) : super(type: BoringFilterType.dropdown) {
    assert(valueController is BoringFilterValueController<List>,
        'The type of the value for the valueController must be a List');
    assert(valueController.value != null,
        "Please give an initialValue to the value controller. It can also be [] (empty list)");
  }

  bool Function(DropdownMenuItem<dynamic> dropdownMenuItem, String value)?
      searchMatchFn;
}

class BoringDropdownMultiChoiceFilter<T> extends BoringFilter<T> {
  BoringDropdownMultiChoiceFilter({
    required super.where,
    required super.valueController,
    required super.title,
    required super.hintText,
    required super.values,
    required super.showingValues,
    this.searchMatchFn,
  }) : super(type: BoringFilterType.dropdownMultiChoice) {
    assert(valueController is BoringFilterValueController<List>,
        'The type of the value for the valueController must be a List');
    assert(valueController.value != null,
        "Please give an initialValue to the value controller. It can also be [] (empty list)");
  }

  bool Function(DropdownMenuItem<dynamic> dropdownMenuItem, String value)?
      searchMatchFn;
}

class BoringFilterValueController<T> extends ValueNotifier<T?> {
  BoringFilterValueController({T? initialValue}) : super(initialValue);

  void setValue(T? val) {
    super.value = val;
    notifyListeners();
  }

  void reset() {
    
    if (value is List) {
      (value as List).clear();
    } else {
      value = null;
    }
    notifyListeners();
  }

  void sendNotification() {
    notifyListeners();
  }
}

enum BoringFilterType { text, dropdown, dropdownMultiChoice }
