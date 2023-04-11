import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BoringRowAction {
  const BoringRowAction(
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
  final Function(int) onTap;
  final ButtonStyle? buttonStyle;
  final String? tooltip;
  final bool fillButton;
  final double svgHeight = 30;
  final double svgWidth = 30;

  _icon() =>
      icon ??
      SvgPicture.asset(
        svgAsset!,
        height: svgHeight,
        width: svgWidth,
      );

  bool _hasIcon() => icon != null || svgAsset != null;

  Widget actionWidget(int index) {
    if (buttonText != null) {
      return _hasIcon()
          ? ElevatedButton.icon(
              onPressed: () => onTap(index),
              icon: _icon(),
              label: Text(buttonText!),
              style: buttonStyle)
          : fillButton
              ? ElevatedButton(
                  onPressed: () => onTap(index),
                  style: buttonStyle,
                  child: Text(buttonText!),
                )
              : TextButton(
                  onPressed: () => onTap(index),
                  style: buttonStyle,
                  child: Text(buttonText!),
                );
    }

    return InkWell(
      onTap: () => onTap(index),
      radius: 8,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _icon(),
      ),
    );
  }

  Widget build(BuildContext context, int index) {
    if (tooltip != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Tooltip(
          message: tooltip,
          child: actionWidget(index),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: actionWidget(index),
    );
  }
}
