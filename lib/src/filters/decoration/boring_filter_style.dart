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

  BoringFilterStyle copyWith(
    InputDecoration? textInputDecoration,
    InputDecoration? searchDecoration,
    BoxDecoration? dropdownBoxDecoration,
    IconData? prefixIcon,
    TextStyle? titleStyle,
    TextStyle? hintStyle,
    ButtonStyle? applyFiltersButtonStyle,
    ButtonStyle? removeFiltersButtonStyle,
    TextStyle? applyFiltersTextStyle,
    TextStyle? removeFiltersTextStyle,
    String? applyFiltersText,
    String? removeFiltersText,
    Widget? openFiltersDialogWidget,
    Text? filterDialogTitle,
    Alignment? filterDialogTitleAlignment,
    Widget? closeIcon,
    Widget? closeActiveIcon,
    Widget? checkIcon,
    Widget? unCheckIcon,
    ChipThemeData? chipThemeData,
    double? chipSpacing,
  ) =>
      BoringFilterStyle(
          textInputDecoration: textInputDecoration ?? this.textInputDecoration,
          dropdownBoxDecoration:
              dropdownBoxDecoration ?? this.dropdownBoxDecoration,
          hintStyle: hintStyle ?? this.hintStyle,
          titleStyle: titleStyle ?? this.titleStyle,
          prefixIcon: prefixIcon ?? this.prefixIcon,
          applyFiltersButtonStyle:
              applyFiltersButtonStyle ?? this.applyFiltersButtonStyle,
          removeFiltersButtonStyle:
              removeFiltersButtonStyle ?? this.removeFiltersButtonStyle,
          applyFiltersTextStyle:
              applyFiltersTextStyle ?? this.applyFiltersTextStyle,
          removeFiltersTextStyle:
              removeFiltersTextStyle ?? this.removeFiltersTextStyle,
          applyFiltersText: applyFiltersText ?? this.applyFiltersText,
          openFiltersDialogWidget:
              openFiltersDialogWidget ?? this.openFiltersDialogWidget,
          removeFiltersText: removeFiltersText ?? this.removeFiltersText,
          filterDialogTitle: filterDialogTitle ?? this.filterDialogTitle,
          filterDialogTitleAlignment:
              filterDialogTitleAlignment ?? this.filterDialogTitleAlignment,
          closeActiveIcon: closeActiveIcon ?? this.closeActiveIcon,
          searchDecoration: searchDecoration ?? this.searchDecoration,
          closeIcon: closeIcon ?? this.closeIcon,
          checkIcon: checkIcon ?? this.checkIcon,
          unCheckIcon: unCheckIcon ?? this.unCheckIcon,
          chipThemeData: chipThemeData ?? this.chipThemeData,
          chipSpacing: chipSpacing ?? this.chipSpacing);
}
