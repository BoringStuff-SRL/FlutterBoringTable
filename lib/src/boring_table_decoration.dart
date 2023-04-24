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

  BoringTableDecoration copyWith(
      {Color? headerColor,
      Color? rowColor,
      Color? rowHoverColor,
      Color? rowSplashColor,
      Color? rowHighlightColor,
      Color? dividerColor,
      Color? evenRowColor,
      Color? oddRowColor,
      EdgeInsetsGeometry? headerPadding,
      EdgeInsetsGeometry? rowPadding,
      TextStyle? headerTextStyle,
      TextStyle? rowTextStyle,
      bool? showDivider,
      bool? prototypeItem}) {
    return BoringTableDecoration(
        headerColor: headerColor ?? this.headerColor,
        rowColor: rowColor ?? this.rowColor,
        rowHoverColor: rowHoverColor ?? this.rowHoverColor,
        rowSplashColor: rowSplashColor ?? this.rowSplashColor,
        rowHighlightColor: rowHighlightColor ?? this.rowHighlightColor,
        dividerColor: dividerColor ?? this.dividerColor,
        evenRowColor: evenRowColor ?? this.evenRowColor,
        oddRowColor: oddRowColor ?? this.oddRowColor,
        headerPadding: headerPadding ?? this.headerPadding,
        rowPadding: rowPadding ?? this.rowPadding,
        headerTextStyle: headerTextStyle ?? this.headerTextStyle,
        rowTextStyle: rowTextStyle ?? this.rowTextStyle,
        showDivider: showDivider ?? this.showDivider,
        prototypeItem: prototypeItem ?? this.prototypeItem);
  }
}
