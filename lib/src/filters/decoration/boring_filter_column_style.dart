// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BoringFilterColumnStyle {
  final Widget? title;
  final Widget? checkIcon;
  final Widget? unCheckIcon;
  final ButtonStyle? applyFiltersButtonStyle;
  final ButtonStyle? removeFiltersButtonStyle;
  final TextStyle? checkTextStyle;
  final TextStyle? applyFiltersTextStyle;
  final TextStyle? removeFiltersTextStyle;
  final String? applyText;
  final String? removeText;
  final Widget? filterIcon;
  final Widget? closeActiveIcon;
  final Widget? closeIcon;

  BoringFilterColumnStyle(
      {this.title,
      this.checkIcon,
      this.unCheckIcon,
      this.applyFiltersButtonStyle,
      this.removeFiltersButtonStyle,
      this.checkTextStyle,
      this.applyFiltersTextStyle,
      this.removeFiltersTextStyle,
      this.applyText,
      this.removeText,
      this.filterIcon,
      this.closeActiveIcon, this.closeIcon});
}
