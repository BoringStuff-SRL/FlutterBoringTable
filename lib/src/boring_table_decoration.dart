// ignore_for_file: public_member_api_docs, sort_constructors_first
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
      this.evenRowColor,
      this.oddRowColor,
      this.showDivider,
      this.prototypeItem = true});

  final Color? headerColor;
  final Color? rowColor;
  final Color? rowHoverColor;
  final Color? rowSplashColor;
  final Color? rowHighlightColor;
  final Color? dividerColor;
  final Color? evenRowColor;
  final Color? oddRowColor;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? rowPadding;
  final TextStyle? headerTextStyle;
  final TextStyle? rowTextStyle;
  final bool? showDivider;
  final bool prototypeItem;
}
