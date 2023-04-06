// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BoringFilterStyle {
  final InputDecoration? textInputDecoration;
  final BoxDecoration? dropdownBoxDecoration;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;
  final ButtonStyle? applyFiltersButtonStyle;
  final ButtonStyle? removeFiltersButtonStyle;
  final String? applyFiltersText;
  final String? removeFiltersText;
  final Widget? openFiltersDialogWidget;
  final Text? filterDialogTitle;

  final Alignment? filterDialogTitleAlignment;

  BoringFilterStyle({
    this.textInputDecoration,
    this.dropdownBoxDecoration,
    this.hintStyle,
    this.titleStyle,
    this.applyFiltersButtonStyle,
    this.removeFiltersButtonStyle,
    this.applyFiltersText,
    this.openFiltersDialogWidget,
    this.removeFiltersText,
    this.filterDialogTitle,
    this.filterDialogTitleAlignment,
  });
}
