// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BoringFilterStyle {
  final InputDecoration? textInputDecoration;
  final InputDecoration? searchDecoration;
  final BoxDecoration? dropdownBoxDecoration;
  final IconData? prefixIcon;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;
  final ButtonStyle? applyFiltersButtonStyle;
  final ButtonStyle? removeFiltersButtonStyle;
  final TextStyle? applyFiltersTextStyle;
  final TextStyle? removeFiltersTextStyle;
  final String? applyFiltersText;
  final String? removeFiltersText;
  final Widget? openFiltersDialogWidget;
  final Text? filterDialogTitle;
  final Alignment? filterDialogTitleAlignment;
  final Widget? closeIcon;
  final Widget? closeActiveIcon;
  final Widget? checkIcon;
  final Widget? unCheckIcon;
  final ChipThemeData? chipThemeData;
  final double? chipSpacing;

  BoringFilterStyle(
      {this.textInputDecoration,
      this.dropdownBoxDecoration,
      this.hintStyle,
      this.titleStyle,
      this.prefixIcon,
      this.applyFiltersButtonStyle,
      this.removeFiltersButtonStyle,
      this.applyFiltersTextStyle,
      this.removeFiltersTextStyle,
      this.applyFiltersText,
      this.openFiltersDialogWidget,
      this.removeFiltersText,
      this.filterDialogTitle,
      this.filterDialogTitleAlignment,
      this.closeActiveIcon,
      this.searchDecoration,
      this.closeIcon,
      this.checkIcon,
      this.unCheckIcon,
      this.chipThemeData,
      this.chipSpacing});
}
