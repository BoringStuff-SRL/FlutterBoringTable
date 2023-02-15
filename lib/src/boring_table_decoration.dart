import 'package:flutter/material.dart';

class BoringTableDecoration {
  BoringTableDecoration(
      {this.headerColor,
      this.rowColor,
      this.rowHoverColor,
      this.rowSplashColor,
      this.rowHighlightColor,
      this.dividerColor,
      this.headerPadding,
      this.rowPadding,
      this.headerTextStyle,
      this.rowTextStyle,
      this.showDivider});

  final Color? headerColor;
  final Color? rowColor;
  final Color? rowHoverColor;
  final Color? rowSplashColor;
  final Color? rowHighlightColor;
  final Color? dividerColor;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? rowPadding;
  final TextStyle? headerTextStyle;
  final TextStyle? rowTextStyle;
  final bool? showDivider;
}
