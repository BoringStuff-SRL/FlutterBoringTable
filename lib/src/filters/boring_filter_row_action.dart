import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BoringFilterRowAction<T> {
  const BoringFilterRowAction(
      {required this.onTap,
      this.svgAsset,
      this.icon,
      this.buttonStyle,
      this.tooltip,
      this.fillButton = false,
      this.buttonText})
      : assert(icon == null || svgAsset == null,
            "You can't set both svgAsset and icon"),
        assert(svgAsset != null || icon != null || buttonText != null,
            "You have to set at least one parameter between icon, svgAsser or buttonText"),
        assert(buttonStyle == null || buttonText != null,
            "You can't set buttonStyle if buttonText is null");

  final String? svgAsset;
  final Widget? icon;
  final String? buttonText;
  final Function(T?) onTap;
  final ButtonStyle? buttonStyle;
  final String? tooltip;
  final bool fillButton;
  final double svgHeight = 30;
  final double svgWidth = 30;

  Widget _icon() =>
      icon ??
      SvgPicture.asset(
        svgAsset!,
        height: svgHeight,
        width: svgWidth,
      );

  bool _hasIcon() => icon != null || svgAsset != null;

  Widget actionWidget(T? item) {
    if (buttonText != null) {
      return _hasIcon()
          ? ElevatedButton.icon(
              onPressed: () => onTap(item),
              icon: _icon(),
              label: Text(buttonText!),
              style: buttonStyle)
          : fillButton
              ? ElevatedButton(
                  onPressed: () => onTap(item),
                  style: buttonStyle,
                  child: Text(buttonText!),
                )
              : TextButton(
                  onPressed: () => onTap(item),
                  style: buttonStyle,
                  child: Text(buttonText!),
                );
    }

    return InkWell(
      onTap: () => onTap(item),
      radius: 8,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _icon(),
      ),
    );
  }

  Widget build(BuildContext context, T? item) {
    if (tooltip != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Tooltip(
          message: tooltip,
          child: actionWidget(item),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: actionWidget(item),
    );
  }
}
