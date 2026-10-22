import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : flexible = false,
        softWrap = true;

  /// Automatically wraps long text.

  const AppText.flexible(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : flexible = true,
        softWrap = true;

  /// Single/multiple line text ending with ...
  const AppText.ellipsis(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines = 1,
  })  : flexible = false,
        overflow = TextOverflow.ellipsis,
        softWrap = true;

  /// Ellipsis text intended for Row/Flex.
  const AppText.flexibleEllipsis(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines = 1,
  })  : flexible = true,
        overflow = TextOverflow.ellipsis,
        softWrap = true;

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  final bool flexible;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );

    if (!flexible) {
      return textWidget;
    }

    return Flexible(
      child: textWidget,
    );
  }
}
